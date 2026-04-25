import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/providers/database_provider.dart';
import '../guess_arrangement/models/playing_card.dart';
import 'models/bluff_bar_state.dart';
import 'models/bluff_bar_player.dart';
import 'models/roulette_deck.dart';
import 'models/enums.dart';
import 'logic/bluff_bar_rules.dart';
import 'ai/bluff_bar_ai.dart';
import 'ai/easy_ai.dart';
import 'ai/medium_ai.dart';
import 'ai/hard_ai.dart';

part 'bluff_bar_provider.g.dart';

/// Bluff Bar game state provider
@riverpod
class BluffBarGame extends _$BluffBarGame {
  final Map<int, BluffBarAi> _ais = {}; // Map player index to AI instance
  Timer? _gameTimer;

  @override
  BluffBarState build() {
    ref.onDispose(() {
      _gameTimer?.cancel();
    });
    return BluffBarState.initial();
  }

  // ============ Game Lifecycle ============

  /// Start a new game
  void startGame({
    required int playerCount,
    required List<AiDifficulty> aiDifficulties,
  }) {
    _gameTimer?.cancel();
    _ais.clear();

    // Initialize state
    state = BluffBarState.newGame(
      playerCount: playerCount,
      aiDifficulties: aiDifficulties,
    );

    // Create AI instances for each non-human player
    for (final player in state.players) {
      if (!player.isHuman && player.aiDifficulty != null) {
        _ais[player.index] = _createAi(player.aiDifficulty!);
      }
    }

    // Deal cards
    _dealCards();
  }

  BluffBarAi _createAi(AiDifficulty difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return EasyBluffBarAi();
      case AiDifficulty.medium:
        return MediumBluffBarAi();
      case AiDifficulty.hard:
        return HardBluffBarAi();
    }
  }

  /// Deal cards to all players - each active player gets exactly 5 cards
  void _dealCards() {
    final mainDeck = BluffBarRules.createMainDeck();
    mainDeck.shuffle();

    // Count active players (not eliminated)
    final activePlayers = state.players.where((p) => !p.isEliminated).toList();
    
    // Fixed 5 cards per player, regardless of total deck size
    const cardsPerPlayer = 5;
    final totalCardsNeeded = cardsPerPlayer * activePlayers.length;
    
    // Deck: 24 cards (5xJ/Q/K/A + 4 Jokers)
    // For 4 players: 20 cards dealt, 4 cards remain in deck (including possible Jokers)
    final cardsToDeal = mainDeck.sublist(0, totalCardsNeeded.clamp(0, mainDeck.length));
    
    final updatedPlayers = List<BluffBarPlayer>.from(state.players);
    int cardIndex = 0;
    
    for (var player in activePlayers) {
      // Each active player gets exactly 5 cards
      final hand = cardsToDeal.sublist(cardIndex, cardIndex + cardsPerPlayer);
      updatedPlayers[player.index] = player.copyWith(
        hand: hand,
        rouletteDeck: RouletteDeck.create(),
      );
      cardIndex += cardsPerPlayer;
    }
    
    // Eliminated players get empty hand
    for (var player in state.players.where((p) => p.isEliminated)) {
      updatedPlayers[player.index] = player.copyWith(hand: []);
    }

    // Remaining cards stay in mainDeck (not dealt to players)
    final remainingDeck = mainDeck.sublist(totalCardsNeeded.clamp(0, mainDeck.length));

    state = state.copyWith(
      status: GameStatus.dealing,
      phase: GamePhase.deal,
      players: updatedPlayers,
      mainDeck: remainingDeck,
    );

    // Brief dealing animation, then select target card
    Future.delayed(const Duration(milliseconds: 500), () {
      _selectTargetCard();
    });
  }

  /// Select the target card for this round
  void _selectTargetCard() {
    final tableDeck = BluffBarRules.createTableDeck();
    tableDeck.shuffle();
    final targetCard = tableDeck.first;

    state = state.copyWith(
      phase: GamePhase.play,
      targetCard: targetCard.rank,
      mainDeck: [...state.mainDeck, ...tableDeck], // Add table deck to main
    );

    _startPlayPhase();
  }

  /// Start the play phase
  void _startPlayPhase() {
    // Start game timer
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.status == GameStatus.playing) {
        state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      } else if (state.status == GameStatus.gameOver) {
        timer.cancel();
      }
    });

    state = state.copyWith(status: GameStatus.playing);

    // Trigger AI turn if needed
    if (!state.isHumanTurn) {
      _scheduleAiTurn();
    }
  }

  // ============ Player Actions ============

  /// Human player plays cards with a claim
  void playCards(List<int> cardIndices, CardRank claimedRank) {
    if (state.status != GameStatus.playing) return;
    if (!state.isHumanTurn) return;

    _executePlayCards(cardIndices, claimedRank);
  }

  /// Human player challenges the last player's claim
  void challengePlayer() {
    if (state.status != GameStatus.playing) return;
    if (state.lastPlayerIndex == null) return;
    if (!state.canPlayerChallenge(state.humanPlayerIndex)) return;

    state = state.copyWith(
      phase: GamePhase.challenge,
      challengerIndex: state.humanPlayerIndex,
    );

    _revealAndResolveChallenge();
  }

  /// Human player passes (does not challenge)
  void passTurn() {
    if (state.status != GameStatus.playing) return;

    _nextPlayer();
  }

  // ============ Internal Methods ============

  /// Execute playing cards with a claim
  void _executePlayCards(List<int> cardIndices, CardRank claimedRank) {
    final player = state.currentPlayer;
    final cards = cardIndices.map((i) => player.hand[i]).toList();

    // Validate the play
    if (!BluffBarRules.isLegalPlay(cardIndices, claimedRank, player, state)) {
      return;
    }

    // Remove cards from hand
    final updatedPlayers = List<BluffBarPlayer>.from(state.players);
    final newHand = <PlayingCard>[];
    for (int i = 0; i < player.hand.length; i++) {
      if (!cardIndices.contains(i)) {
        newHand.add(player.hand[i]);
      }
    }
    updatedPlayers[player.index] = player.copyWith(hand: newHand);

    // Add to played pile
    final playedCards = PlayedCards(
      cards: cards,
      claimedRank: claimedRank,
      playerIndex: player.index,
    );

    // Update state
    state = state.copyWith(
      players: updatedPlayers,
      playedPile: [...state.playedPile, playedCards],
      lastPlayerIndex: player.index,
      lastClaim: claimedRank,
    );

    // Check remaining players with cards
    final activePlayersWithCards = updatedPlayers
        .where((p) => !p.isEliminated && p.hand.isNotEmpty)
        .toList();

    if (activePlayersWithCards.isEmpty) {
      // All players have no cards - last player who played faces roulette
      // Because no one can challenge their play anymore
      Future.delayed(const Duration(milliseconds: 500), () {
        _triggerRoulette(player.index);
      });
    } else if (activePlayersWithCards.length == 1) {
      // Only ONE player still has cards - that player faces roulette
      // Because no one else can play cards to challenge them
      final lastPlayerWithCards = activePlayersWithCards.first;
      Future.delayed(const Duration(milliseconds: 500), () {
        _triggerRoulette(lastPlayerWithCards.index);
      });
    } else {
      // Multiple players still have cards - continue game
      _nextPlayer();
    }
  }

  /// Reveal cards and resolve challenge
  void _revealAndResolveChallenge() {
    final lastPlay = state.playedPile.last;
    final result = BluffBarRules.resolveChallenge(
      lastPlay.cards,
      lastPlay.claimedRank,
    );

    // Determine loser
    final loserIndex = result == ChallengeResult.liarGuilty
        ? state.lastPlayerIndex!
        : state.challengerIndex!;

    state = state.copyWith(
      phase: GamePhase.reveal,
      revealedCards: lastPlay.cards,
      challengeResult: result,
    );

    // Delay for reveal animation, then trigger roulette
    Future.delayed(const Duration(milliseconds: 2000), () {
      _triggerRoulette(loserIndex);
    });
  }

  /// Trigger Russian roulette for a player
  void _triggerRoulette(int playerIndex) {
    state = state.copyWith(
      phase: GamePhase.roulette,
      roulettePlayerIndex: playerIndex,
    );

    // For AI: delay draw to allow overlay to show pre-fire state first
    if (playerIndex != state.humanPlayerIndex) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (state.phase == GamePhase.roulette) {
          _drawRouletteCard();
        }
      });
    }
    // For human: don't auto-draw, wait for tap via drawRouletteCard()
  }

  /// Draw a roulette card
  void _drawRouletteCard() {
    final playerIndex = state.roulettePlayerIndex!;
    final player = state.players[playerIndex];
    final deck = player.rouletteDeck;
    final drawnCard = deck.draw();
    final survived = drawnCard != null && !drawnCard.isBullet;

    final updatedPlayers = List<BluffBarPlayer>.from(state.players);

    // Increment cumulative roulette shots (persists across rounds)
    final newRouletteShots = player.rouletteShots + 1;

    if (survived) {
      // Player survived - advance deck and increment shots
      updatedPlayers[playerIndex] = player.copyWith(
        rouletteDeck: deck.withDraw(),
        roundsSurvived: player.roundsSurvived + 1,
        rouletteShots: newRouletteShots,
      );
    } else {
      // Player eliminated - increment shots and mark eliminated
      updatedPlayers[playerIndex] = player.copyWith(
        isEliminated: true,
        bulletHits: player.bulletHits + 1,
        rouletteShots: newRouletteShots,
      );
    }

    state = state.copyWith(
      phase: GamePhase.play,
      status: GameStatus.playing,
      players: updatedPlayers,
      roulettePlayerIndex: null,
      lastRoulettePlayerIndex: playerIndex,
      rouletteSurvived: survived,
    );

    // If human eliminated, end game immediately
    if (!survived && playerIndex == state.humanPlayerIndex) {
      _endGame();
      return;
    }

    // Check game state
    if (BluffBarRules.shouldEndGame(updatedPlayers)) {
      _endGame();
    } else {
      // After roulette, show round end rankings, then start new round
      _endRound();
    }
  }

  /// Human player draws roulette card (called when player taps)
  void drawRouletteCard() {
    if (state.phase != GamePhase.roulette) return;
    if (state.roulettePlayerIndex != state.humanPlayerIndex) return;
    
    _drawRouletteCard();
  }

  /// Move to the next active player
  void _nextPlayer() {
    final nextIndex = BluffBarRules.getNextActivePlayer(
      state.currentPlayerIndex,
      state.players,
    );

    // Clear last claim display
    state = state.copyWith(
      currentPlayerIndex: nextIndex,
    );

    // Trigger AI if needed
    if (!state.isHumanTurn) {
      _scheduleAiTurn();
    }
  }

  /// End the current round
  void _endRound() {
    // Round ended - directly start next round (no ranking display)
    startNextRound();
  }

   /// Start the next round
   void startNextRound() {
     // Skip if game is over
     if (state.status == GameStatus.gameOver) return;

     // Increment round number
     final nextRound = state.roundNumber + 1;

     // Reset players' roulette decks (reshuffle for new round) BUT keep cumulative rouletteShots
     final updatedPlayers = state.players.map((p) {
       if (p.isEliminated) return p;
       // Reshuffle roulette deck for new round, but keep the shot count
       return p.copyWith(rouletteDeck: RouletteDeck.create());
     }).toList();

     // Start next round from player who fired roulette (or skip if eliminated)
     final nextStarter = _findNextActivePlayer(state.lastRoulettePlayerIndex ?? state.humanPlayerIndex);

     state = state.copyWith(
       roundNumber: nextRound,
       playedPile: [],
       lastPlayerIndex: null,
       lastClaim: null,
       revealedCards: [],
       challengeResult: ChallengeResult.noChallenge,
       players: updatedPlayers,
       currentPlayerIndex: nextStarter,
       lastRoulettePlayerIndex: null,
     );

     // Deal new cards
     _dealCards();
   }

   /// Find next active player from a starting index (skip eliminated)
   int _findNextActivePlayer(int startIndex) {
     final activePlayers = state.players.where((p) => !p.isEliminated).toList();
     if (activePlayers.isEmpty) return startIndex;
     
     // Find the position in clockwise order
     final clockwiseOrder = [0, 1, 3, 2];
     final startPos = clockwiseOrder.indexOf(startIndex);
     
     for (int i = 0; i <= 4; i++) {
       final pos = (startPos + i) % 4;
       final idx = clockwiseOrder[pos];
       if (!state.players[idx].isEliminated) {
         return idx;
       }
     }
     return startIndex;
   }

  /// End the game
  void _endGame() {
    _gameTimer?.cancel();

    // Find winner (last active player)
    final winner = state.players.firstWhere(
      (p) => p.isActive,
      orElse: () => state.players.first,
    );

    state = state.copyWith(
      status: GameStatus.gameOver,
      phase: GamePhase.gameOver,
      winnerIndex: winner.index,
    );

    _saveGameRecord();
  }

  /// Get player rankings (survivors first, then by rounds survived)
  List<BluffBarPlayer> getRankings() {
    final sortedPlayers = List<BluffBarPlayer>.from(state.players);
    sortedPlayers.sort((a, b) {
      // Survivors first
      if (a.isEliminated != b.isEliminated) {
        return a.isEliminated ? 1 : -1;
      }
      // Then by rounds survived (descending)
      return b.roundsSurvived.compareTo(a.roundsSurvived);
    });
    return sortedPlayers;
  }

  // ============ AI Integration ============

  /// Schedule AI turn with delay
  void _scheduleAiTurn() {
    if (state.isHumanTurn) return;

    final currentPlayerIndex = state.currentPlayerIndex;
    final ai = _ais[currentPlayerIndex];

    if (ai == null) return;

    // Fixed 0.8 second delay for AI thinking
    Future.delayed(const Duration(milliseconds: 800), () async {
      if (state.status != GameStatus.playing) return;
      if (state.currentPlayerIndex != currentPlayerIndex) return;

      // First, decide whether to challenge the previous play
      if (state.lastPlayerIndex != null && state.canPlayerChallenge(currentPlayerIndex)) {
        final challengeDecision = await ai.decideChallenge(state);
        
        if (challengeDecision.shouldChallenge) {
          // AI challenges
          state = state.copyWith(
            phase: GamePhase.challenge,
            challengerIndex: currentPlayerIndex,
          );
          _revealAndResolveChallenge();
          return;
        }
      }

      // No challenge - decide what cards to play
      final playDecision = await ai.decidePlay(state);

      if (playDecision.cardIndices.isNotEmpty) {
        // AI plays cards
        _executePlayCards(playDecision.cardIndices, playDecision.claimedRank);
      } else {
        // AI passes (no cards to play or cannot play)
        _nextPlayer();
      }
    });
  }

  // ============ Save/Load ============

  /// Save current game to a slot
  Future<int> saveGame(int slotIndex) async {
    final dao = ref.read(bluffBarSavesDaoProvider);

    final aiScores = state.players
        .where((p) => !p.isHuman)
        .map((p) => p.roundsSurvived)
        .join(',');

    return await dao.saveGame(
      BluffBarSavesCompanion.insert(
        slotIndex: slotIndex,
        gameStateJson: jsonEncode(state.toJson()),
        humanScore: state.humanPlayer.roundsSurvived,
        aiScores: aiScores,
        roundNumber: state.roundNumber,
      ),
    );
  }

  /// Load game from a slot
  Future<void> loadGame(int slotIndex) async {
    final dao = ref.read(bluffBarSavesDaoProvider);
    final save = await dao.getSaveBySlot(slotIndex);

    if (save != null) {
      final loadedState = BluffBarState.fromJson(
        jsonDecode(save.gameStateJson) as Map<String, dynamic>,
      );

      // Recreate AI instances
      _ais.clear();
      for (final player in loadedState.players) {
        if (!player.isHuman && player.aiDifficulty != null) {
          _ais[player.index] = _createAi(player.aiDifficulty!);
        }
      }

      // Cancel existing timers
      _gameTimer?.cancel();

      state = loadedState.copyWith(status: GameStatus.playing);

      // Resume game timer
      _startGameTimer();

      // Trigger AI if needed
      if (!state.isHumanTurn) {
        _scheduleAiTurn();
      }
    }
  }

  /// Delete a save slot
  Future<void> deleteSave(int slotIndex) async {
    final dao = ref.read(bluffBarSavesDaoProvider);
    await dao.deleteSaveBySlot(slotIndex);
  }

  /// Get all saved games
  Future<List<BluffBarSave>> getAllSaves() async {
    final dao = ref.read(bluffBarSavesDaoProvider);
    return await dao.getAllSaves();
  }

  /// Check if there are any saved games
  Future<bool> hasSavedGames() async {
    final dao = ref.read(bluffBarSavesDaoProvider);
    return await dao.hasAnySaves();
  }

  /// Start/resume the game timer
  void _startGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.status == GameStatus.playing) {
        state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      } else if (state.status == GameStatus.gameOver) {
        timer.cancel();
      }
    });
  }

  /// Save game record to database
  Future<void> _saveGameRecord() async {
    final dao = ref.read(gameRecordsDaoProvider);

    final winner = state.winnerIndex != null
        ? state.players[state.winnerIndex!]
        : null;

    final isHumanWinner = winner?.isHuman == true;
    final score = isHumanWinner ? state.humanPlayer.roundsSurvived : -1;

    await dao.insertRecord(
      GameRecordsCompanion.insert(
        gameType: 'bluff_bar',
        score: Value(score),
        durationSeconds: Value(state.elapsedSeconds),
      ),
    );
  }

  // ============ Utility Methods ============

  /// Get cards that can be legally played by current player
  List<PlayingCard> getPlayableCards() {
    if (state.status != GameStatus.playing) return [];
    if (!state.isHumanTurn) return [];

    final player = state.currentPlayer;
    return BluffBarRules.getPlayableCards(player, state);
  }

  /// Check if a specific card selection is valid
  bool canPlayCards(List<int> cardIndices, CardRank claimedRank) {
    if (state.status != GameStatus.playing) return false;
    if (!state.isHumanTurn) return false;

    final player = state.currentPlayer;
    return BluffBarRules.isLegalPlay(cardIndices, claimedRank, player, state);
  }

  /// Check if human player can challenge
  bool canChallenge() {
    if (state.status != GameStatus.playing) return false;
    return state.canPlayerChallenge(state.humanPlayerIndex);
  }

  /// Get display string for target card
  String getTargetCardDisplay() {
    final targetCard = state.targetCard;
    if (targetCard == null) return '';
    return targetCard.symbol;
  }
}