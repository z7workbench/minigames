import 'dart:math';

import '../models/mancala_state.dart';
import 'mancala_ai.dart';

/// Medium AI that uses heuristic-based decision making.
///
/// Strategy priorities:
/// 1. Capture opponent's seeds if possible
/// 2. Get an extra turn if possible
/// 3. Prevent opponent from capturing on next turn
/// 4. Prefer pits with more seeds
class MediumAi extends MancalaAi {
  final Random _random = Random();

  @override
  Future<AiDecision> decide(MancalaState state) async {
    final validPits = state.validPits;

    if (validPits.isEmpty) {
      throw StateError('No valid pits available for AI');
    }

    // Score each pit and select the best one
    int bestPit = validPits.first;
    int bestScore = -999999;

    for (final pitIndex in validPits) {
      final score = _evaluatePit(state, pitIndex);
      if (score > bestScore) {
        bestScore = score;
        bestPit = pitIndex;
      }
    }

    return AiDecision(
      pitIndex: bestPit,
      delayMs: 600 + _random.nextInt(400), // 600-1000ms delay
    );
  }

  /// Evaluate a pit and return a heuristic score.
  int _evaluatePit(MancalaState state, int pitIndex) {
    int score = 0;
    final seeds = state.board[pitIndex];

    // Simulate the move
    final result = state.sowSeeds(pitIndex);

    // High priority: capture opponent's seeds
    if (result.captured > 0) {
      score += result.captured * 100;
    }

    // High priority: get an extra turn
    if (result.landedInStore) {
      score += 50;
    }

    // Medium priority: add to our store
    final storeGain = result.newState.board[13] - state.board[13];
    score += storeGain * 10;

    // Low priority: prefer more seeds (more control)
    score += seeds;

    // Penalty: leaving opponent with capture opportunity
    // Check if opponent can capture on their next turn
    if (!result.landedInStore && !result.newState.isGameOver) {
      final opponentPits = result.newState.currentPlayer == 0
          ? result.newState.player1Pits
          : result.newState.player2Pits;

      for (int i = 0; i < opponentPits.length; i++) {
        if (opponentPits[i] > 0) {
          final opponentResult = result.newState.sowSeeds(
            result.newState.currentPlayer == 0 ? i : i + 7,
          );
          if (opponentResult.captured > 0) {
            score -= opponentResult.captured * 30;
          }
        }
      }
    }

    // Bonus: prefer moves that lead to more valid moves next turn
    if (result.landedInStore) {
      final nextValidPits = result.newState.validPits;
      score += nextValidPits.length * 5;
    }

    return score;
  }
}
