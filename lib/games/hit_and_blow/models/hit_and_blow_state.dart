import 'package:flutter/foundation.dart';

enum GameStatus { idle, playing, won, lost }

enum Difficulty { easy, hard }

class HitAndBlowState {
  final GameStatus status;
  final Difficulty difficulty;
  final List<int> targetNumber; // Hidden number to guess
  final List<List<int>> guessHistory; // All guesses made
  final List<int> hitsHistory; // Hits for each guess
  final List<int> blowsHistory; // Blows for each guess
  final int attemptsUsed;
  final int maxAttempts;
  final DateTime? startTime;
  final Duration? duration;

  const HitAndBlowState({
    required this.status,
    required this.difficulty,
    required this.targetNumber,
    required this.guessHistory,
    required this.hitsHistory,
    required this.blowsHistory,
    required this.attemptsUsed,
    required this.maxAttempts,
    this.startTime,
    this.duration,
  });

  factory HitAndBlowState.initial(Difficulty difficulty) {
    final maxAttempts = 10;
    final targetLength = difficulty == Difficulty.easy ? 4 : 6;

    return HitAndBlowState(
      status: GameStatus.idle,
      difficulty: difficulty,
      targetNumber: List.filled(targetLength, 0),
      guessHistory: [],
      hitsHistory: [],
      blowsHistory: [],
      attemptsUsed: 0,
      maxAttempts: maxAttempts,
    );
  }

  factory HitAndBlowState.playing({
    required Difficulty difficulty,
    required List<int> targetNumber,
  }) {
    final maxAttempts = 10;

    return HitAndBlowState(
      status: GameStatus.playing,
      difficulty: difficulty,
      targetNumber: targetNumber,
      guessHistory: [],
      hitsHistory: [],
      blowsHistory: [],
      attemptsUsed: 0,
      maxAttempts: maxAttempts,
      startTime: DateTime.now(),
    );
  }

  HitAndBlowState copyWith({
    GameStatus? status,
    Difficulty? difficulty,
    List<int>? targetNumber,
    List<List<int>>? guessHistory,
    List<int>? hitsHistory,
    List<int>? blowsHistory,
    int? attemptsUsed,
    int? maxAttempts,
    DateTime? startTime,
    Duration? duration,
  }) {
    return HitAndBlowState(
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      targetNumber: targetNumber ?? this.targetNumber,
      guessHistory: guessHistory ?? this.guessHistory,
      hitsHistory: hitsHistory ?? this.hitsHistory,
      blowsHistory: blowsHistory ?? this.blowsHistory,
      attemptsUsed: attemptsUsed ?? this.attemptsUsed,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HitAndBlowState &&
        status == other.status &&
        difficulty == other.difficulty &&
        listEquals(targetNumber, other.targetNumber) &&
        listEquals(guessHistory, other.guessHistory) &&
        listEquals(hitsHistory, other.hitsHistory) &&
        listEquals(blowsHistory, other.blowsHistory) &&
        attemptsUsed == other.attemptsUsed &&
        maxAttempts == other.maxAttempts &&
        startTime == other.startTime &&
        duration == other.duration;
  }

  @override
  int get hashCode => Object.hashAll([
    status,
    difficulty,
    targetNumber,
    guessHistory,
    hitsHistory,
    blowsHistory,
    attemptsUsed,
    maxAttempts,
    startTime,
    duration,
  ]);
}
