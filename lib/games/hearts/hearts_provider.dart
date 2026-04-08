import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/providers/database_provider.dart';
import '../guess_arrangement/models/playing_card.dart';
import 'models/hearts_state.dart';
import 'models/hearts_player.dart';
import 'models/trick.dart';
import 'models/enums.dart';
import 'logic/hearts_rules.dart';
import 'logic/hearts_scoring.dart';
import 'utils/deck_utils.dart';
import 'utils/card_utils.dart';
import 'ai/hearts_ai.dart';
import 'ai/easy_ai.dart';
import 'ai/medium_ai.dart';
import 'ai/hard_ai.dart';

part 'hearts_provider.g.dart';

/// Hearts game state provider
@riverpod
class HeartsGame extends _$HeartsGame {
  Map<int, HeartsAi> _ais = {}; // Map player index to AI instance
  Timer? _passTimer;
  Timer? _gameTimer;

  @override
  HeartsState build() {
    ref.onDispose(() {
      _passTimer?.cancel();
      _gameTimer?.cancel();
    });
    return HeartsState.initial();
  }

  // ============ Game Lifecycle ============

  /// Start a new game
  void startGame({
    required List<AiDifficulty> aiDifficulties,
    required TimerOption timerOption,
    required MoonAnnouncementOption moonOption,
  }) {
    _passTimer?.cancel();
    _gameTimer?.cancel();
    _ais.clear();

    // Initialize state (this creates players with randomized positions)
    state = HeartsState.newGame(
      aiDifficulties: aiDifficulties,
      timerOption: timerOption,
      moonOption: moonOption,
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

  HeartsAi _createAi(AiDifficulty difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return EasyHeartsAi();
      case AiDifficulty.medium:
        return MediumHeartsAi();
      case AiDifficulty.hard:
        return HardHeartsAi();
    }
  }

  /// Deal cards to all players
  void _dealCards() {
    final deck = HeartsDeck.shuffle(HeartsDeck.createDeck());
    final hands = HeartsDeck.deal(deck);

    // Validate: Ensure no duplicate cards in the deck
    final allCards = hands.expand((h) => h).toList();
    final uniqueCards = allCards.toSet();
    assert(
      allCards.length == uniqueCards.length,
      'Duplicate cards detected in deck! ${allCards.length} vs ${uniqueCards.length}',
    );

    // Validate: Ensure each hand has exactly 13 cards
    for (int i = 0; i < 4; i++) {
      assert(
        hands[i].length == 13,
        'Player $i has ${hands[i].length} cards, expected 13',
      );
    }

    // Update players with dealt cards (preserve existing player state, only update hand)
    final updatedPlayers = List<HeartsPlayer>.from(state.players);
    for (int i = 0; i < 4; i++) {
      // Clear round-specific data for new round
      updatedPlayers[i] = updatedPlayers[i].copyWith(
        hand: hands[i],
        roundScore: 0,
        tricksWon: [],
        selectedPassCards: null, // Clear selected pass cards
        receivedPassCards: null, // Clear received cards from previous round
      );
    }

    // Find who has 2 of clubs (leads first trick)
    final firstPlayer = HeartsDeck.findTwoOfClubsOwner(hands);

    state = state.copyWith(
      status: GameStatus.dealing,
      players: updatedPlayers,
      currentPlayerIndex: firstPlayer,
    );

    // Brief dealing animation, then start pass phase
    Future.delayed(const Duration(milliseconds: 500), () {
      _startPassPhase();
    });
  }

  // ============ Pass Phase ============

  void _startPassPhase() {
    // Debug: Log pass direction
    print(
      '[Hearts] Starting pass phase. Round: ${state.roundNumber}, PassDirection: ${state.passDirection}',
    );

    if (state.passDirection == PassDirection.none) {
      // No passing this round, start playing
      print('[Hearts] Pass direction is none, skipping pass phase');
      state = state.copyWith(status: GameStatus.playing);
      _startPlayingPhase();
      return;
    }

    state = state.copyWith(status: GameStatus.passing);

    // Start timer for human player
    _startPassTimer();

    // Trigger AI passing
    _triggerAiPassing();
  }

  void _startPassTimer() {
    if (state.timerOption == TimerOption.unlimited) return;

    final seconds = _getTimerSeconds(state.timerOption);
    state = state.copyWith(timerRemaining: seconds);

    _passTimer?.cancel();
    _passTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.status != GameStatus.passing) {
        timer.cancel();
        return;
      }
      if (state.timerRemaining != null && state.timerRemaining! > 0) {
        state = state.copyWith(timerRemaining: state.timerRemaining! - 1);
      } else {
        // Time's up - auto-submit
        _autoSubmitPass();
      }
    });
  }

  int _getTimerSeconds(TimerOption option) {
    switch (option) {
      case TimerOption.unlimited:
        return -1;
      case TimerOption.seconds15:
        return 15;
      case TimerOption.seconds20:
        return 20;
      case TimerOption.seconds30:
        return 30;
    }
  }

  /// Human player selects cards to pass
  void selectPassCards(List<PlayingCard> cards) {
    if (state.status != GameStatus.passing) return;
    if (cards.length != 3) return;

    final humanIndex = state.humanPlayerIndex;
    final updatedPlayers = List<HeartsPlayer>.from(state.players);
    updatedPlayers[humanIndex] = updatedPlayers[humanIndex].copyWith(
      selectedPassCards: cards,
    );

    state = state.copyWith(players: updatedPlayers);

    // Check if all players have selected
    _checkPassComplete();
  }

  /// Toggle a card selection for passing
  void togglePassCardSelection(PlayingCard card) {
    if (state.status != GameStatus.passing) return;

    final humanIndex = state.humanPlayerIndex;
    final human = state.players[humanIndex];
    final selected = human.selectedPassCards ?? [];

    if (selected.contains(card)) {
      // Remove from selection
      final newSelected = selected.where((c) => c != card).toList();
      final updatedPlayers = List<HeartsPlayer>.from(state.players);
      updatedPlayers[humanIndex] = updatedPlayers[humanIndex].copyWith(
        selectedPassCards: newSelected.isEmpty ? null : newSelected,
      );
      state = state.copyWith(players: updatedPlayers);
    } else if (selected.length < 3) {
      // Add to selection
      final newSelected = [...selected, card];
      final updatedPlayers = List<HeartsPlayer>.from(state.players);
      updatedPlayers[humanIndex] = updatedPlayers[humanIndex].copyWith(
        selectedPassCards: newSelected,
      );
      state = state.copyWith(players: updatedPlayers);
    }
  }

  void _autoSubmitPass() {
    _passTimer?.cancel();

    // Select highest cards if not enough selected
    final humanIndex = state.humanPlayerIndex;
    final human = state.players[humanIndex];
    final selected = human.selectedPassCards ?? [];

    if (selected.length < 3) {
      final remaining = human.hand.where((c) => !selected.contains(c)).toList();
      remaining.sort((a, b) => CardUtils.compareByRank(b, a));

      final newSelected = List<PlayingCard>.from(selected);
      while (newSelected.length < 3 && remaining.isNotEmpty) {
        newSelected.add(remaining.removeAt(0));
      }

      selectPassCards(newSelected);
    }
  }

  void _triggerAiPassing() async {
    print(
      '[Hearts] _triggerAiPassing called. AI instances: ${_ais.keys.toList()}',
    );

    // Process AI players one by one with delays
    for (int i = 0; i < state.players.length; i++) {
      if (i == state.humanPlayerIndex) {
        print('[Hearts] Skipping human player at index $i');
        continue;
      }

      final player = state.players[i];
      if (player.selectedPassCards != null) {
        print('[Hearts] Player $i already has selectedPassCards');
        continue;
      }

      final ai = _ais[i];
      if (ai == null) {
        print('[Hearts] ERROR: AI instance for player $i is null!');
        continue;
      }

      print('[Hearts] AI player $i is deciding pass...');

      // Small delay before AI decision
      await Future.delayed(Duration(milliseconds: ai.getRandomDelay()));

      if (state.status != GameStatus.passing) {
        print('[Hearts] Status changed, aborting AI passing');
        return;
      }

      final decision = await ai.decidePass(player.hand, state.passDirection);
      print(
        '[Hearts] AI player $i decided to pass: ${decision.cardsToPass.map((c) => c.displayString).join(', ')}',
      );

      final updatedPlayers = List<HeartsPlayer>.from(state.players);
      updatedPlayers[i] = updatedPlayers[i].copyWith(
        selectedPassCards: decision.cardsToPass,
      );

      state = state.copyWith(players: updatedPlayers);
    }

    print('[Hearts] All AI players processed, checking pass complete...');
    _checkPassComplete();
  }

  void _checkPassComplete() {
    // Check if all players have selected 3 cards
    print('[Hearts] _checkPassComplete called');
    for (int i = 0; i < state.players.length; i++) {
      final p = state.players[i];
      print(
        '[Hearts] Player $i: selectedPassCards = ${p.selectedPassCards?.map((c) => c.displayString).join(', ') ?? 'null'}',
      );
    }

    final allSelected = state.players.every(
      (p) => p.selectedPassCards != null && p.selectedPassCards!.length == 3,
    );

    print('[Hearts] allSelected = $allSelected');

    if (allSelected) {
      print('[Hearts] Executing pass...');
      _executePass();
    }
  }

  void _executePass() {
    _passTimer?.cancel();

    // Transfer cards based on direction
    final updatedPlayers = List<HeartsPlayer>.from(state.players);
    final receivedCards = <int, List<PlayingCard>>{0: [], 1: [], 2: [], 3: []};

    // First, collect cards being passed
    for (int i = 0; i < 4; i++) {
      final passCards = updatedPlayers[i].selectedPassCards!;
      final targetIndex = _getPassTargetIndex(i, state.passDirection);
      receivedCards[targetIndex] = [
        ...receivedCards[targetIndex]!,
        ...passCards,
      ];
    }

    // Then, update hands
    for (int i = 0; i < 4; i++) {
      final passCards = updatedPlayers[i].selectedPassCards!;
      final newHand = CardUtils.removeCards(updatedPlayers[i].hand, passCards);
      final finalHand = CardUtils.addCards(newHand, receivedCards[i]!);

      updatedPlayers[i] = updatedPlayers[i].copyWith(
        hand: finalHand,
        selectedPassCards: null,
        receivedPassCards: receivedCards[i], // Store received cards for display
      );
    }

    // Reset AIs for new round (clear card tracking)
    for (final ai in _ais.values) {
      ai.resetForNewRound();
    }

    // Update state to passComplete - UI will show received cards dialog
    state = state.copyWith(
      status: GameStatus.passComplete,
      players: updatedPlayers,
    );
  }

  /// Called after user confirms they've seen received cards
  void confirmPassComplete() {
    if (state.status != GameStatus.passComplete) return;

    // Clear receivedPassCards after display
    final clearedPlayers = state.players
        .map((p) => p.copyWith(receivedPassCards: null))
        .toList();
    state = state.copyWith(status: GameStatus.playing, players: clearedPlayers);

    _startPlayingPhase();
  }

  int _getPassTargetIndex(int fromIndex, PassDirection direction) {
    switch (direction) {
      case PassDirection.left:
        return (fromIndex + 1) % 4;
      case PassDirection.right:
        return (fromIndex + 3) % 4;
      case PassDirection.across:
        return (fromIndex + 2) % 4;
      case PassDirection.none:
        return fromIndex;
    }
  }

  /// Get pass direction for a given round number
  PassDirection _getPassDirection(int round) {
    final cycle = (round - 1) % 4;
    return PassDirection.values[cycle];
  }

  // ============ Playing Phase ============

  void _startPlayingPhase() {
    // Start game timer
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.status == GameStatus.playing) {
        state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      } else if (state.status == GameStatus.gameOver) {
        timer.cancel();
      }
    });

    // Find who should lead (has 2 of clubs for first trick)
    if (state.completedTricks.isEmpty) {
      // First trick - player with 2♣ leads
      final leaderIndex = HeartsRules.findTwoOfClubsOwner(state);
      state = state.copyWith(currentPlayerIndex: leaderIndex);
    }

    // Trigger AI turn if needed
    if (!state.isHumanTurn) {
      _scheduleAiTurn();
    }
  }

  /// Human player plays a card
  void playCard(PlayingCard card) {
    if (state.status != GameStatus.playing) return;
    if (!state.isHumanTurn) return;

    _executePlayCard(card);
  }

  void _executePlayCard(PlayingCard card) {
    final player = state.players[state.currentPlayerIndex];

    // Validate the play
    if (!HeartsRules.isLegalPlay(card, player, state)) return;

    // Remove card from hand
    final updatedPlayers = List<HeartsPlayer>.from(state.players);
    updatedPlayers[state.currentPlayerIndex] = player.copyWith(
      hand: CardUtils.removeCards(player.hand, [card]),
    );

    // Add to trick
    var newTrick = state.currentTrick.addCard(card, state.currentPlayerIndex);

    // Check for hearts breaking
    var heartsBroken = state.heartsBroken;
    if (!heartsBroken && card.suit == CardSuit.hearts) {
      heartsBroken = true;
    }

    // Update state
    state = state.copyWith(
      players: updatedPlayers,
      currentTrick: newTrick,
      heartsBroken: heartsBroken,
    );

    // Check if trick complete
    if (newTrick.isComplete) {
      // Extra delay when 4th player completes trick (let players see all cards)
      Future.delayed(const Duration(milliseconds: 1000), () {
        _completeTrick();
      });
    } else {
      // Next player (clockwise by visual position)
      final nextPlayer = HeartsRules.getNextPlayer(
        state.currentPlayerIndex,
        state.players,
      );
      state = state.copyWith(currentPlayerIndex: nextPlayer);

      // Trigger AI if needed
      if (!state.isHumanTurn) {
        _scheduleAiTurn();
      }
    }
  }

  void _completeTrick() {
    final winnerIndex = HeartsRules.determineTrickWinner(state.currentTrick);
    final penalty = HeartsRules.calculateTrickPenalty(state.currentTrick);

    // Record trick for AI tracking
    for (final ai in _ais.values) {
      ai.recordTrick(state.currentTrick);
    }

    // Give trick to winner
    final updatedPlayers = List<HeartsPlayer>.from(state.players);
    final winner = updatedPlayers[winnerIndex];
    updatedPlayers[winnerIndex] = winner.copyWith(
      tricksWon: [...winner.tricksWon, ...state.currentTrick.cards],
      roundScore: winner.roundScore + penalty,
    );

    // Add to completed tricks
    final completedTricks = [...state.completedTricks, state.currentTrick];

    state = state.copyWith(
      status: GameStatus.trickEnd,
      players: updatedPlayers,
      completedTricks: completedTricks,
      currentTrick: Trick(leadPlayerIndex: winnerIndex),
      currentPlayerIndex: winnerIndex,
      trickNumber: state.trickNumber + 1,
    );

    // Check if round complete
    if (HeartsRules.isRoundComplete(state)) {
      // Show final trick longer before showing round results
      Future.delayed(const Duration(seconds: 2), () {
        _completeRound();
      });
    } else {
      // Continue playing after brief pause (let players see the result)
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (state.status == GameStatus.trickEnd) {
          state = state.copyWith(status: GameStatus.playing);
          if (!state.isHumanTurn) {
            _scheduleAiTurn();
          }
        }
      });
    }
  }

  void _completeRound() {
    // Calculate final scores with shoot moon
    final roundScores = HeartsScoring.calculateRoundScores(state);

    // Update total scores
    final updatedPlayers = List<HeartsPlayer>.from(state.players);
    for (int i = 0; i < 4; i++) {
      updatedPlayers[i] = updatedPlayers[i].copyWith(
        totalScore: updatedPlayers[i].totalScore + (roundScores[i] ?? 0),
        roundScore: roundScores[i] ?? 0,
        tricksWon: [],
      );
    }

    // Check for game over
    if (HeartsScoring.shouldEndGame(updatedPlayers)) {
      _gameTimer?.cancel();
      state = state.copyWith(
        status: GameStatus.gameOver,
        players: updatedPlayers,
      );
      _saveGameRecord();
    } else {
      // Prepare for next round
      final nextRound = state.roundNumber + 1;
      final nextPassDirection = _getPassDirection(nextRound);

      // Debug: Log next round setup
      print(
        '[Hearts] Completing round ${state.roundNumber}. Next round: $nextRound, PassDirection: $nextPassDirection',
      );

      state = state.copyWith(
        status: GameStatus.roundEnd,
        players: updatedPlayers,
        roundNumber: nextRound,
        passDirection: nextPassDirection,
        trickNumber: 1,
        heartsBroken: false,
        currentTrick: const Trick(),
        completedTricks: [],
      );
    }
  }

  /// Start next round after round end
  void startNextRound() {
    if (state.status != GameStatus.roundEnd) return;

    // Reset round-specific state before dealing new cards
    state = state.copyWith(
      trickNumber: 1,
      heartsBroken: false,
      currentTrick: const Trick(),
      completedTricks: [],
    );

    // Recreate AI instances for each non-human player (clear old tracking data)
    _ais.clear();
    for (final player in state.players) {
      if (!player.isHuman && player.aiDifficulty != null) {
        _ais[player.index] = _createAi(player.aiDifficulty!);
        print(
          '[Hearts] Created AI for player ${player.index} with difficulty ${player.aiDifficulty}',
        );
      }
    }
    print('[Hearts] AI instances after startNextRound: ${_ais.keys.toList()}');

    // Deal new cards (this will also reset roundScore, tricksWon for each player)
    _dealCards();
  }

  void _scheduleAiTurn() {
    if (state.isHumanTurn) return;

    final currentPlayerIndex = state.currentPlayerIndex;
    final ai = _ais[currentPlayerIndex];

    if (ai == null) return;

    // Short delay (250ms) before AI decision for faster gameplay
    Future.delayed(const Duration(milliseconds: 250), () async {
      if (state.status != GameStatus.playing) return;
      if (state.currentPlayerIndex != currentPlayerIndex) return;

      final decision = await ai.decidePlay(state);

      // Short delay (250ms) for decision execution - total 0.5s
      await Future.delayed(const Duration(milliseconds: 250));

      if (state.status != GameStatus.playing) return;
      if (state.currentPlayerIndex != currentPlayerIndex) return;

      _executePlayCard(decision.card);
    });
  }

  // ============ Save/Load ============

  /// Save current game to a slot
  Future<int> saveGame(int slotIndex) async {
    final dao = ref.read(heartsSavesDaoProvider);

    final aiScores = state.players
        .where((p) => !p.isHuman)
        .map((p) => p.totalScore)
        .join(',');

    return await dao.saveGame(
      HeartsSavesCompanion.insert(
        slotIndex: slotIndex,
        gameStateJson: jsonEncode(state.toJson()),
        humanScore: state.humanPlayer.totalScore,
        aiScores: aiScores,
        roundNumber: state.roundNumber,
      ),
    );
  }

  /// Load game from a slot
  Future<void> loadGame(int slotIndex) async {
    final dao = ref.read(heartsSavesDaoProvider);
    final save = await dao.getSaveBySlot(slotIndex);

    if (save != null) {
      final loadedState = HeartsState.fromJson(
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
      _passTimer?.cancel();
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
    final dao = ref.read(heartsSavesDaoProvider);
    await dao.deleteSaveBySlot(slotIndex);
  }

  /// Get all saved games
  Future<List<HeartsSave>> getAllSaves() async {
    final dao = ref.read(heartsSavesDaoProvider);
    return await dao.getAllSaves();
  }

  /// Check if there are any saved games
  Future<bool> hasSavedGames() async {
    final dao = ref.read(heartsSavesDaoProvider);
    return await dao.hasAnySaves();
  }

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

  Future<void> _saveGameRecord() async {
    final dao = ref.read(gameRecordsDaoProvider);

    // Find winner (lowest score)
    final winnerIndex = HeartsScoring.findWinner(state.players);
    final isHumanWinner = winnerIndex == state.humanPlayerIndex;

    await dao.insertRecord(
      GameRecordsCompanion.insert(
        gameType: 'hearts',
        score: Value(isHumanWinner ? state.humanPlayer.totalScore : -1),
        durationSeconds: Value(state.elapsedSeconds),
      ),
    );
  }

  // ============ Utility Methods ============

  /// Get legal cards for current player
  List<PlayingCard> getLegalCards() {
    if (state.status != GameStatus.playing) return [];
    if (!state.isHumanTurn) return [];

    final player = state.currentPlayer;
    return HeartsRules.getLegalCards(player, state);
  }

  /// Check if a card can be played
  bool canPlayCard(PlayingCard card) {
    final legalCards = getLegalCards();
    return legalCards.contains(card);
  }

  /// Get pass direction display name
  String getPassDirectionName() {
    switch (state.passDirection) {
      case PassDirection.left:
        return 'Pass Left';
      case PassDirection.right:
        return 'Pass Right';
      case PassDirection.across:
        return 'Pass Across';
      case PassDirection.none:
        return 'No Passing';
    }
  }
}
