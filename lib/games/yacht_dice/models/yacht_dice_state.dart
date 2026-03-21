import 'scoring_category.dart';

enum GamePhase { rolling, selectingDice, selectingCategory, gameOver }

enum PlayerType { human, ai }

enum AiDifficulty { easy, medium, hard }

class PlayerState {
  final String name;
  final PlayerType type;
  final List<int> dice; // 5 dice values (1-6)
  final List<bool> kept; // Which dice are kept
  final int rollsRemaining; // 0-3
  final Map<ScoringCategory, int?> scores; // Category -> score or null
  final int totalScore;
  final int bonusEarned;

  const PlayerState({
    required this.name,
    required this.type,
    required this.dice,
    required this.kept,
    required this.rollsRemaining,
    required this.scores,
    required this.totalScore,
    required this.bonusEarned,
  });

  PlayerState.initial({required this.name, required this.type})
    : dice = List.filled(5, 0), // 0 means not rolled yet
      kept = List.filled(5, false),
      rollsRemaining = 3,
      scores = {
        ScoringCategory.ones: null,
        ScoringCategory.twos: null,
        ScoringCategory.threes: null,
        ScoringCategory.fours: null,
        ScoringCategory.fives: null,
        ScoringCategory.sixes: null,
        ScoringCategory.allSelect: null,
        ScoringCategory.fullHouse: null,
        ScoringCategory.fourOfAKind: null,
        ScoringCategory.smallStraight: null,
        ScoringCategory.largeStraight: null,
        ScoringCategory.yacht: null,
      },
      totalScore = 0,
      bonusEarned = 0;

  PlayerState copyWith({
    String? name,
    PlayerType? type,
    List<int>? dice,
    List<bool>? kept,
    int? rollsRemaining,
    Map<ScoringCategory, int?>? scores,
    int? totalScore,
    int? bonusEarned,
  }) {
    return PlayerState(
      name: name ?? this.name,
      type: type ?? this.type,
      dice: dice ?? this.dice,
      kept: kept ?? this.kept,
      rollsRemaining: rollsRemaining ?? this.rollsRemaining,
      scores: scores ?? this.scores,
      totalScore: totalScore ?? this.totalScore,
      bonusEarned: bonusEarned ?? this.bonusEarned,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PlayerState) return false;

    return name == other.name &&
        type == other.type &&
        dice == other.dice &&
        kept == other.kept &&
        rollsRemaining == other.rollsRemaining &&
        scores == other.scores &&
        totalScore == other.totalScore &&
        bonusEarned == other.bonusEarned;
  }

  @override
  int get hashCode => Object.hash(
    name,
    type,
    dice,
    kept,
    rollsRemaining,
    scores,
    totalScore,
    bonusEarned,
  );

  /// Serialize PlayerState to JSON
  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type.name,
    'dice': dice,
    'kept': kept,
    'rollsRemaining': rollsRemaining,
    'scores': scores.map((k, v) => MapEntry(k.name, v)),
    'totalScore': totalScore,
    'bonusEarned': bonusEarned,
  };

  /// Deserialize PlayerState from JSON
  factory PlayerState.fromJson(Map<String, dynamic> json) => PlayerState(
    name: json['name'] as String,
    type: PlayerType.values.byName(json['type'] as String),
    dice: (json['dice'] as List<dynamic>).cast<int>(),
    kept: (json['kept'] as List<dynamic>).cast<bool>(),
    rollsRemaining: json['rollsRemaining'] as int,
    scores: Map.fromEntries(
      (json['scores'] as Map<String, dynamic>).entries.map(
        (e) => MapEntry(ScoringCategory.values.byName(e.key), e.value as int?),
      ),
    ),
    totalScore: json['totalScore'] as int,
    bonusEarned: json['bonusEarned'] as int,
  );
}

class YachtDiceState {
  final GamePhase phase;
  final int currentPlayerIndex;
  final List<PlayerState> players;
  final int roundsCompleted;
  final AiDifficulty? aiDifficulty;

  const YachtDiceState({
    required this.phase,
    required this.currentPlayerIndex,
    required this.players,
    required this.roundsCompleted,
    this.aiDifficulty,
  });

  YachtDiceState.initial(int playerCount, [AiDifficulty? aiDifficulty])
    : phase = GamePhase.rolling,
      currentPlayerIndex = 0,
      players = List.generate(
        aiDifficulty != null ? 2 : playerCount,
        (index) => PlayerState.initial(
          name: index == 0
              ? 'Player 1'
              : (aiDifficulty != null ? 'AI' : 'Player ${index + 1}'),
          type: index == 0
              ? PlayerType.human
              : (aiDifficulty != null ? PlayerType.ai : PlayerType.human),
        ),
      ),
      roundsCompleted = 0,
      aiDifficulty = aiDifficulty;

  YachtDiceState copyWith({
    GamePhase? phase,
    int? currentPlayerIndex,
    List<PlayerState>? players,
    int? roundsCompleted,
    AiDifficulty? aiDifficulty,
  }) {
    return YachtDiceState(
      phase: phase ?? this.phase,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      players: players ?? this.players,
      roundsCompleted: roundsCompleted ?? this.roundsCompleted,
      aiDifficulty: aiDifficulty ?? this.aiDifficulty,
    );
  }

  bool get isGameOver {
    // Game is over when all players have filled all 12 categories
    for (final player in players) {
      final hasAllCategories = player.scores.values.every(
        (score) => score != null,
      );
      if (!hasAllCategories) return false;
    }
    return true;
  }

  int calculateTotalScore(PlayerState player) {
    final upperSectionSum = [
      ScoringCategory.ones,
      ScoringCategory.twos,
      ScoringCategory.threes,
      ScoringCategory.fours,
      ScoringCategory.fives,
      ScoringCategory.sixes,
    ].map((category) => player.scores[category] ?? 0).reduce((a, b) => a + b);

    final bonus = upperSectionSum >= 63 ? 35 : 0;

    final lowerSectionSum = [
      ScoringCategory.allSelect,
      ScoringCategory.fullHouse,
      ScoringCategory.fourOfAKind,
      ScoringCategory.smallStraight,
      ScoringCategory.largeStraight,
      ScoringCategory.yacht,
    ].map((category) => player.scores[category] ?? 0).reduce((a, b) => a + b);

    return upperSectionSum + lowerSectionSum + bonus;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! YachtDiceState) return false;

    return phase == other.phase &&
        currentPlayerIndex == other.currentPlayerIndex &&
        players == other.players &&
        roundsCompleted == other.roundsCompleted &&
        aiDifficulty == other.aiDifficulty;
  }

  @override
  int get hashCode => Object.hash(
    phase,
    currentPlayerIndex,
    players,
    roundsCompleted,
    aiDifficulty,
  );

  /// Serialize YachtDiceState to JSON
  Map<String, dynamic> toJson() => {
    'phase': phase.name,
    'currentPlayerIndex': currentPlayerIndex,
    'players': players.map((p) => p.toJson()).toList(),
    'roundsCompleted': roundsCompleted,
    'aiDifficulty': aiDifficulty?.name,
  };

  /// Deserialize YachtDiceState from JSON
  factory YachtDiceState.fromJson(Map<String, dynamic> json) => YachtDiceState(
    phase: GamePhase.values.byName(json['phase'] as String),
    currentPlayerIndex: json['currentPlayerIndex'] as int,
    players: (json['players'] as List<dynamic>)
        .map((p) => PlayerState.fromJson(p as Map<String, dynamic>))
        .toList(),
    roundsCompleted: json['roundsCompleted'] as int,
    aiDifficulty: json['aiDifficulty'] != null
        ? AiDifficulty.values.byName(json['aiDifficulty'] as String)
        : null,
  );
}
