import 'dart:math';

import 'package:equatable/equatable.dart';

import 'enums.dart';
import 'hearts_player.dart';
import 'trick.dart';

/// Main Hearts game state
class HeartsState extends Equatable {
  final GameStatus status;
  final List<HeartsPlayer> players; // 4 players
  final int currentPlayerIndex; // Whose turn it is
  final Trick currentTrick; // Cards in current trick
  final List<Trick> completedTricks; // Tricks completed this round
  final int humanPlayerIndex; // Which player is human (randomized)
  final bool heartsBroken; // Has a heart been played as non-lead?
  final PassDirection passDirection; // Current pass direction
  final int roundNumber; // Current round (1-4 then cycles)
  final int trickNumber; // Current trick (1-13)
  final TimerOption timerOption; // Pass timer setting
  final MoonAnnouncementOption moonOption; // Moon announcement setting
  final int? timerRemaining; // Seconds left for pass timer
  final DateTime? startTime; // When game started
  final int elapsedSeconds; // Game duration
  final bool isShootingMoon; // Is someone attempting moon?
  final int? moonShooterIndex; // Who is shooting moon

  const HeartsState({
    required this.status,
    required this.players,
    required this.currentPlayerIndex,
    required this.currentTrick,
    required this.completedTricks,
    required this.humanPlayerIndex,
    required this.heartsBroken,
    required this.passDirection,
    required this.roundNumber,
    required this.trickNumber,
    required this.timerOption,
    required this.moonOption,
    this.timerRemaining,
    this.startTime,
    this.elapsedSeconds = 0,
    this.isShootingMoon = false,
    this.moonShooterIndex,
  });

  factory HeartsState.initial() {
    return const HeartsState(
      status: GameStatus.idle,
      players: [],
      currentPlayerIndex: 0,
      currentTrick: Trick(),
      completedTricks: [],
      humanPlayerIndex: 0,
      heartsBroken: false,
      passDirection: PassDirection.left,
      roundNumber: 1,
      trickNumber: 1,
      timerOption: TimerOption.seconds15,
      moonOption: MoonAnnouncementOption.hidden,
      elapsedSeconds: 0,
    );
  }

  factory HeartsState.newGame({
    required List<AiDifficulty> aiDifficulties,
    required TimerOption timerOption,
    required MoonAnnouncementOption moonOption,
  }) {
    // Create 4 players with fixed positions: human always at South (position 0)
    final random = Random();
    final humanIndex = random.nextInt(4);

    // Available positions for AI: West(1), North(2), East(3)
    final aiPositions = [1, 2, 3]..shuffle();

    int aiIndex = 0; // Track which AI difficulty to use
    int aiPositionIndex = 0; // Track AI position assignment

    final players = List.generate(4, (i) {
      final isHuman = i == humanIndex;
      final difficulty = isHuman ? null : aiDifficulties[aiIndex++];

      // Human always at position 0 (South), AI at shuffled positions 1-3
      final position = isHuman ? 0 : aiPositions[aiPositionIndex++];

      return HeartsPlayer.create(
        index: i,
        isHuman: isHuman,
        aiDifficulty: difficulty,
        position: position,
      );
    });

    return HeartsState(
      status: GameStatus.dealing,
      players: players,
      currentPlayerIndex: humanIndex, // Start with human player
      currentTrick: const Trick(),
      completedTricks: const [],
      humanPlayerIndex: humanIndex,
      heartsBroken: false,
      passDirection: _getPassDirection(1),
      roundNumber: 1,
      trickNumber: 1,
      timerOption: timerOption,
      moonOption: moonOption,
      startTime: DateTime.now(),
    );
  }

  HeartsState copyWith({
    GameStatus? status,
    List<HeartsPlayer>? players,
    int? currentPlayerIndex,
    Trick? currentTrick,
    List<Trick>? completedTricks,
    int? humanPlayerIndex,
    bool? heartsBroken,
    PassDirection? passDirection,
    int? roundNumber,
    int? trickNumber,
    TimerOption? timerOption,
    MoonAnnouncementOption? moonOption,
    int? timerRemaining,
    DateTime? startTime,
    int? elapsedSeconds,
    bool? isShootingMoon,
    int? moonShooterIndex,
  }) {
    return HeartsState(
      status: status ?? this.status,
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      currentTrick: currentTrick ?? this.currentTrick,
      completedTricks: completedTricks ?? this.completedTricks,
      humanPlayerIndex: humanPlayerIndex ?? this.humanPlayerIndex,
      heartsBroken: heartsBroken ?? this.heartsBroken,
      passDirection: passDirection ?? this.passDirection,
      roundNumber: roundNumber ?? this.roundNumber,
      trickNumber: trickNumber ?? this.trickNumber,
      timerOption: timerOption ?? this.timerOption,
      moonOption: moonOption ?? this.moonOption,
      timerRemaining: timerRemaining ?? this.timerRemaining,
      startTime: startTime ?? this.startTime,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isShootingMoon: isShootingMoon ?? this.isShootingMoon,
      moonShooterIndex: moonShooterIndex ?? this.moonShooterIndex,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'players': players.map((p) => p.toJson()).toList(),
    'currentPlayerIndex': currentPlayerIndex,
    'currentTrick': currentTrick.toJson(),
    'completedTricks': completedTricks.map((t) => t.toJson()).toList(),
    'humanPlayerIndex': humanPlayerIndex,
    'heartsBroken': heartsBroken,
    'passDirection': passDirection.name,
    'roundNumber': roundNumber,
    'trickNumber': trickNumber,
    'timerOption': timerOption.name,
    'moonOption': moonOption.name,
    'timerRemaining': timerRemaining,
    'startTime': startTime?.toIso8601String(),
    'elapsedSeconds': elapsedSeconds,
    'isShootingMoon': isShootingMoon,
    'moonShooterIndex': moonShooterIndex,
  };

  factory HeartsState.fromJson(Map<String, dynamic> json) {
    return HeartsState(
      status: GameStatus.values.byName(json['status'] as String),
      players: (json['players'] as List)
          .map((p) => HeartsPlayer.fromJson(p as Map<String, dynamic>))
          .toList(),
      currentPlayerIndex: json['currentPlayerIndex'] as int,
      currentTrick: Trick.fromJson(
        json['currentTrick'] as Map<String, dynamic>,
      ),
      completedTricks: (json['completedTricks'] as List)
          .map((t) => Trick.fromJson(t as Map<String, dynamic>))
          .toList(),
      humanPlayerIndex: json['humanPlayerIndex'] as int,
      heartsBroken: json['heartsBroken'] as bool,
      passDirection: PassDirection.values.byName(
        json['passDirection'] as String,
      ),
      roundNumber: json['roundNumber'] as int,
      trickNumber: json['trickNumber'] as int,
      timerOption: TimerOption.values.byName(json['timerOption'] as String),
      moonOption: MoonAnnouncementOption.values.byName(
        json['moonOption'] as String,
      ),
      timerRemaining: json['timerRemaining'] as int?,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : null,
      elapsedSeconds: json['elapsedSeconds'] as int,
      isShootingMoon: json['isShootingMoon'] as bool,
      moonShooterIndex: json['moonShooterIndex'] as int?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    players,
    currentPlayerIndex,
    currentTrick,
    completedTricks,
    humanPlayerIndex,
    heartsBroken,
    passDirection,
    roundNumber,
    trickNumber,
    timerOption,
    moonOption,
    timerRemaining,
    startTime,
    elapsedSeconds,
    isShootingMoon,
    moonShooterIndex,
  ];

  // Computed properties
  bool get isHumanTurn => currentPlayerIndex == humanPlayerIndex;
  HeartsPlayer get currentPlayer => players[currentPlayerIndex];
  HeartsPlayer get humanPlayer => players[humanPlayerIndex];
  bool get isRoundOver => completedTricks.length == 13;
  bool get isGameOver => players.any((p) => p.totalScore >= 100);
  int? get winner => isGameOver ? _findWinner() : null;

  /// Get pass direction for a round number
  static PassDirection _getPassDirection(int round) {
    final cycle = (round - 1) % 4;
    return PassDirection.values[cycle];
  }

  /// Randomize visual positions (human always at South)
  static List<int> _randomizePositions() {
    final positions = [0, 1, 2, 3]; // South, West, North, East
    positions.shuffle();
    // Note: Position 0 (South) is reserved for human player
    // The human player will be assigned position 0, others get shuffled positions
    return positions;
  }

  /// Find the winner (player with lowest score)
  int _findWinner() {
    int minScore = players.first.totalScore;
    int winnerIndex = 0;
    for (int i = 1; i < players.length; i++) {
      if (players[i].totalScore < minScore) {
        minScore = players[i].totalScore;
        winnerIndex = i;
      }
    }
    return winnerIndex;
  }
}
