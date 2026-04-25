import 'dart:math';

import 'package:equatable/equatable.dart';

import '../../guess_arrangement/models/playing_card.dart';
import 'enums.dart';
import 'bluff_bar_player.dart';
import '../logic/bluff_bar_rules.dart';

/// Represents played cards with a claim
class PlayedCards extends Equatable {
  final List<PlayingCard> cards; // Cards actually played
  final CardRank claimedRank; // Rank claimed by player
  final int playerIndex; // Index of player who played

  const PlayedCards({
    required this.cards,
    required this.claimedRank,
    required this.playerIndex,
  });

  /// Check if the claim was truthful (all cards match claimed rank)
  bool get isTruthful {
    return cards.every((c) => c.rank == claimedRank);
  }

  /// Check if the claim was a lie (at least one card doesn't match)
  bool get isLie => !isTruthful;

  /// Number of cards played
  int get count => cards.length;

  PlayedCards copyWith({
    List<PlayingCard>? cards,
    CardRank? claimedRank,
    int? playerIndex,
  }) {
    return PlayedCards(
      cards: cards ?? this.cards,
      claimedRank: claimedRank ?? this.claimedRank,
      playerIndex: playerIndex ?? this.playerIndex,
    );
  }

  Map<String, dynamic> toJson() => {
    'cards': cards.map((c) => c.toJson()).toList(),
    'claimedRank': claimedRank.value,
    'playerIndex': playerIndex,
  };

  factory PlayedCards.fromJson(Map<String, dynamic> json) {
    return PlayedCards(
      cards: (json['cards'] as List)
          .map((c) => PlayingCard.fromJson(c as Map<String, dynamic>))
          .toList(),
      claimedRank: CardRank.values.firstWhere(
        (r) => r.value == json['claimedRank'],
      ),
      playerIndex: json['playerIndex'] as int,
    );
  }

  @override
  List<Object?> get props => [cards, claimedRank, playerIndex];
}

/// Main Bluff Bar game state
class BluffBarState extends Equatable {
  final GameStatus status;
  final GamePhase phase;
  final List<BluffBarPlayer> players;
  final int currentPlayerIndex;
  final int humanPlayerIndex;
  final List<PlayingCard> mainDeck; // 26-card deck (6♠J + 6♦Q + 6♣K + 6♥A + 2 Joker)
  final CardRank? targetCard; // Current target rank to play
  final List<PlayedCards> playedPile; // All played cards this round
  final int? lastPlayerIndex; // Last player who played
  final CardRank? lastClaim; // Last claim made
  final int? challengerIndex; // Player who challenged (if any)
  final List<PlayingCard> revealedCards; // Cards revealed during challenge
  final ChallengeResult challengeResult;
  final int? roulettePlayerIndex; // Player facing roulette
  final bool rouletteSurvived; // Did roulette player survive?
  final int? lastRoulettePlayerIndex; // Player who fired roulette, starts next round
  final int roundNumber;
  final int? winnerIndex;
  final int elapsedSeconds;

  const BluffBarState({
    required this.status,
    required this.phase,
    required this.players,
    required this.currentPlayerIndex,
    required this.humanPlayerIndex,
    required this.mainDeck,
    this.targetCard,
    required this.playedPile,
    this.lastPlayerIndex,
    this.lastClaim,
    this.challengerIndex,
    required this.revealedCards,
    required this.challengeResult,
    this.roulettePlayerIndex,
    this.rouletteSurvived = false,
    this.lastRoulettePlayerIndex,
    required this.roundNumber,
    this.winnerIndex,
    this.elapsedSeconds = 0,
  });

  factory BluffBarState.initial() {
    return const BluffBarState(
      status: GameStatus.idle,
      phase: GamePhase.setup,
      players: [],
      currentPlayerIndex: 0,
      humanPlayerIndex: 0,
      mainDeck: [],
      playedPile: [],
      revealedCards: [],
      challengeResult: ChallengeResult.noChallenge,
      roundNumber: 1,
    );
  }

  factory BluffBarState.newGame({
    required int playerCount,
    required List<AiDifficulty> aiDifficulties,
  }) {
    // Human is ALWAYS at position 0 (South/南)
    const humanIndex = 0;
    final random = Random();

    final players = List.generate(playerCount, (i) {
      final isHuman = i == humanIndex;
      final difficulty = isHuman ? null : aiDifficulties[i - 1];
      return BluffBarPlayer.create(
        index: i,
        isHuman: isHuman,
        aiDifficulty: difficulty,
      );
    });

    // Create 26-card deck
    final deck = BluffBarRules.createMainDeck();
    deck.shuffle(random);

    return BluffBarState(
      status: GameStatus.dealing,
      phase: GamePhase.deal,
      players: players,
      currentPlayerIndex: humanIndex,
      humanPlayerIndex: humanIndex,
       mainDeck: deck,
       playedPile: [],
       revealedCards: [],
       challengeResult: ChallengeResult.noChallenge,
       roundNumber: 1,
       lastRoulettePlayerIndex: null,
     );
   }


  BluffBarState copyWith({
    GameStatus? status,
    GamePhase? phase,
    List<BluffBarPlayer>? players,
    int? currentPlayerIndex,
    int? humanPlayerIndex,
    List<PlayingCard>? mainDeck,
    CardRank? targetCard,
    List<PlayedCards>? playedPile,
    int? lastPlayerIndex,
    CardRank? lastClaim,
    int? challengerIndex,
    List<PlayingCard>? revealedCards,
    ChallengeResult? challengeResult,
     int? roulettePlayerIndex,
     bool? rouletteSurvived,
     int? lastRoulettePlayerIndex,
     int? roundNumber,
    int? winnerIndex,
    int? elapsedSeconds,
  }) {
    return BluffBarState(
      status: status ?? this.status,
      phase: phase ?? this.phase,
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      humanPlayerIndex: humanPlayerIndex ?? this.humanPlayerIndex,
      mainDeck: mainDeck ?? this.mainDeck,
      targetCard: targetCard ?? this.targetCard,
      playedPile: playedPile ?? this.playedPile,
      lastPlayerIndex: lastPlayerIndex ?? this.lastPlayerIndex,
      lastClaim: lastClaim ?? this.lastClaim,
      challengerIndex: challengerIndex ?? this.challengerIndex,
      revealedCards: revealedCards ?? this.revealedCards,
      challengeResult: challengeResult ?? this.challengeResult,
       roulettePlayerIndex: roulettePlayerIndex ?? this.roulettePlayerIndex,
       rouletteSurvived: rouletteSurvived ?? this.rouletteSurvived,
       lastRoulettePlayerIndex: lastRoulettePlayerIndex ?? this.lastRoulettePlayerIndex,
       roundNumber: roundNumber ?? this.roundNumber,
      winnerIndex: winnerIndex ?? this.winnerIndex,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'phase': phase.name,
    'players': players.map((p) => p.toJson()).toList(),
    'currentPlayerIndex': currentPlayerIndex,
    'humanPlayerIndex': humanPlayerIndex,
    'mainDeck': mainDeck.map((c) => c.toJson()).toList(),
    'targetCard': targetCard?.value,
    'playedPile': playedPile.map((p) => p.toJson()).toList(),
    'lastPlayerIndex': lastPlayerIndex,
    'lastClaim': lastClaim?.value,
    'challengerIndex': challengerIndex,
    'revealedCards': revealedCards.map((c) => c.toJson()).toList(),
    'challengeResult': challengeResult.name,
     'roulettePlayerIndex': roulettePlayerIndex,
     'rouletteSurvived': rouletteSurvived,
     'lastRoulettePlayerIndex': lastRoulettePlayerIndex,
     'roundNumber': roundNumber,
    'winnerIndex': winnerIndex,
    'elapsedSeconds': elapsedSeconds,
  };

  factory BluffBarState.fromJson(Map<String, dynamic> json) {
    return BluffBarState(
      status: GameStatus.values.byName(json['status'] as String),
      phase: GamePhase.values.byName(json['phase'] as String),
      players: (json['players'] as List)
          .map((p) => BluffBarPlayer.fromJson(p as Map<String, dynamic>))
          .toList(),
      currentPlayerIndex: json['currentPlayerIndex'] as int,
      humanPlayerIndex: json['humanPlayerIndex'] as int,
      mainDeck: (json['mainDeck'] as List)
          .map((c) => PlayingCard.fromJson(c as Map<String, dynamic>))
          .toList(),
      targetCard: json['targetCard'] != null
          ? CardRank.values.firstWhere((r) => r.value == json['targetCard'])
          : null,
      playedPile: (json['playedPile'] as List)
          .map((p) => PlayedCards.fromJson(p as Map<String, dynamic>))
          .toList(),
      lastPlayerIndex: json['lastPlayerIndex'] as int?,
      lastClaim: json['lastClaim'] != null
          ? CardRank.values.firstWhere((r) => r.value == json['lastClaim'])
          : null,
      challengerIndex: json['challengerIndex'] as int?,
      revealedCards: (json['revealedCards'] as List)
          .map((c) => PlayingCard.fromJson(c as Map<String, dynamic>))
          .toList(),
      challengeResult: ChallengeResult.values.byName(
        json['challengeResult'] as String,
      ),
       roulettePlayerIndex: json['roulettePlayerIndex'] as int?,
       rouletteSurvived: json['rouletteSurvived'] as bool,
       lastRoulettePlayerIndex: json['lastRoulettePlayerIndex'] as int?,
       roundNumber: json['roundNumber'] as int,
      winnerIndex: json['winnerIndex'] as int?,
      elapsedSeconds: json['elapsedSeconds'] as int,
    );
  }

  @override
  List<Object?> get props => [
    status,
    phase,
    players,
    currentPlayerIndex,
    humanPlayerIndex,
    mainDeck,
    targetCard,
    playedPile,
    lastPlayerIndex,
    lastClaim,
    challengerIndex,
    revealedCards,
    challengeResult,
     roulettePlayerIndex,
     rouletteSurvived,
     lastRoulettePlayerIndex,
     roundNumber,
    winnerIndex,
    elapsedSeconds,
  ];

  // Computed properties
  bool get isHumanTurn => currentPlayerIndex == humanPlayerIndex;
  BluffBarPlayer get currentPlayer => players[currentPlayerIndex];
  BluffBarPlayer get humanPlayer => players[humanPlayerIndex];
  bool get isGameOver =>
      players.where((p) => p.isActive).length <= 1 || winnerIndex != null;
  int get activePlayerCount => players.where((p) => p.isActive).length;
  int get deckRemaining => mainDeck.length;

  /// Get next active player index (skip eliminated players)
  int nextActivePlayerIndex() {
    int next = (currentPlayerIndex + 1) % players.length;
    int attempts = 0;
    while (!players[next].isActive && attempts < players.length) {
      next = (next + 1) % players.length;
      attempts++;
    }
    return next;
  }

  /// Check if a specific player can challenge
  bool canPlayerChallenge(int playerIndex) {
    return playerIndex != lastPlayerIndex &&
        players[playerIndex].isActive &&
        lastClaim != null;
  }

  /// Get the last played cards (for challenge reveal)
  PlayedCards? get lastPlayedCards =>
      playedPile.isNotEmpty ? playedPile.last : null;
}