import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:minigames/data/database.dart';
import 'package:minigames/data/daos/game_records_dao.dart';
import 'package:minigames/data/providers/database_provider.dart';
import 'package:minigames/models/game_type.dart';
import 'package:minigames/games/hit_and_blow/models/hit_and_blow_state.dart';
import 'package:drift/drift.dart';

part 'hit_and_blow_provider.g.dart';

@riverpod
class HitAndBlowStateProvider extends _$HitAndBlowStateProvider {
  @override
  HitAndBlowState build() {
    return HitAndBlowState.initial(Difficulty.easy);
  }

  void startGame(Difficulty difficulty, {bool allowDuplicates = false}) {
    final targetLength = difficulty == Difficulty.easy ? 4 : 6;
    final maxDigit = difficulty == Difficulty.easy ? 6 : 8;

    final random = Random();
    final List<int> targetNumber;

    if (allowDuplicates) {
      targetNumber = List.generate(
        targetLength,
        (_) => random.nextInt(maxDigit) + 1,
      );
    } else {
      final pool = List.generate(maxDigit, (i) => i + 1)..shuffle(random);
      targetNumber = pool.sublist(0, targetLength);
    }

    state = HitAndBlowState.playing(
      difficulty: difficulty,
      targetNumber: targetNumber,
      allowDuplicates: allowDuplicates,
    );
  }

  void submitGuess(List<int> guess) {
    if (state.status != GameStatus.playing ||
        guess.length != state.targetNumber.length ||
        state.attemptsUsed >= state.maxAttempts) {
      return;
    }

    // Validate guess - ensure all digits are in valid range
    final maxDigit = state.difficulty == Difficulty.easy ? 6 : 8;
    if (guess.any((digit) => digit < 1 || digit > maxDigit)) {
      return;
    }

    // Validate no duplicates when not allowed
    if (!state.allowDuplicates && guess.toSet().length != guess.length) {
      return;
    }

    // Calculate hits and blows
    final hits = calculateHits(guess, state.targetNumber);
    final blows = calculateBlows(guess, state.targetNumber, hits);

    final newAttemptsUsed = state.attemptsUsed + 1;
    final isWon = hits == state.targetNumber.length;
    final isLost = newAttemptsUsed >= state.maxAttempts && !isWon;

    final newGuessHistory = List<List<int>>.from(state.guessHistory)
      ..add(guess);
    final newHitsHistory = List<int>.from(state.hitsHistory)..add(hits);
    final newBlowsHistory = List<int>.from(state.blowsHistory)..add(blows);

    HitAndBlowState newState = state.copyWith(
      guessHistory: newGuessHistory,
      hitsHistory: newHitsHistory,
      blowsHistory: newBlowsHistory,
      attemptsUsed: newAttemptsUsed,
    );

    // Update game status
    if (isWon) {
      final duration = DateTime.now().difference(state.startTime!);
      newState = newState.copyWith(status: GameStatus.won, duration: duration);
      _saveGameRecord(true, duration, newState.attemptsUsed);
    } else if (isLost) {
      final duration = DateTime.now().difference(state.startTime!);
      newState = newState.copyWith(status: GameStatus.lost, duration: duration);
      _saveGameRecord(false, duration, newState.attemptsUsed);
    }

    state = newState;
  }

  void resetGame() {
    state = HitAndBlowState.initial(state.difficulty, allowDuplicates: state.allowDuplicates);
  }

  int calculateHits(List<int> guess, List<int> target) {
    int hits = 0;
    for (int i = 0; i < guess.length; i++) {
      if (guess[i] == target[i]) {
        hits++;
      }
    }
    return hits;
  }

  int calculateBlows(List<int> guess, List<int> target, int hits) {
    // Count total correct digits (including hits)
    Map<int, int> targetCounts = {};
    Map<int, int> guessCounts = {};

    for (int digit in target) {
      targetCounts[digit] = (targetCounts[digit] ?? 0) + 1;
    }

    for (int digit in guess) {
      guessCounts[digit] = (guessCounts[digit] ?? 0) + 1;
    }

    int totalCorrect = 0;
    for (var entry in guessCounts.entries) {
      final digit = entry.key;
      final guessCount = entry.value;
      final targetCount = targetCounts[digit] ?? 0;
      totalCorrect += min(guessCount, targetCount);
    }

    // Blows = total correct - hits
    return totalCorrect - hits;
  }

  Future<void> _saveGameRecord(
    bool won,
    Duration duration,
    int attempts,
  ) async {
    final dao = ref.read(gameRecordsDaoProvider);
    final difficultyStr = state.difficulty == Difficulty.easy ? 'easy' : 'hard';

    await dao.insertRecord(
      GameRecordsCompanion.insert(
        gameType: 'hit_and_blow',
        score: Value(attempts),
        durationSeconds: Value(duration.inSeconds),
        difficulty: Value(difficultyStr),
        playedAt: Value(DateTime.now()),
      ),
    );
  }
}
