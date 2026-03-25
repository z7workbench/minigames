import 'dart:math';

import '../models/mancala_state.dart';
import 'mancala_ai.dart';

/// Hard AI that uses Minimax algorithm with alpha-beta pruning.
///
/// Strategy:
/// - Searches game tree to a configurable depth
/// - Uses alpha-beta pruning for optimization
/// - Evaluates positions using a multi-factor heuristic
/// - Prioritizes winning strategies over immediate gains
class HardAi extends MancalaAi {
  /// Maximum search depth for minimax.
  final int maxDepth;

  final Random _random = Random();

  HardAi({this.maxDepth = 6});

  @override
  Future<AiDecision> decide(MancalaState state) async {
    final validPits = state.validPits;

    if (validPits.isEmpty) {
      throw StateError('No valid pits available for AI');
    }

    if (validPits.length == 1) {
      return AiDecision(pitIndex: validPits.first, delayMs: 400);
    }

    // Run minimax with alpha-beta pruning
    int bestPit = validPits.first;
    int bestScore = -999999;

    for (final pitIndex in validPits) {
      final result = state.sowSeeds(pitIndex);
      final score = _minimax(
        result.newState,
        maxDepth - 1,
        -999999,
        999999,
        false, // Minimizing player (opponent)
      );

      // Add small random factor to break ties
      final adjustedScore = score + _random.nextDouble() * 0.1;

      if (adjustedScore > bestScore) {
        bestScore = adjustedScore.toInt();
        bestPit = pitIndex;
      }
    }

    return AiDecision(
      pitIndex: bestPit,
      delayMs: 800 + _random.nextInt(400), // 800-1200ms delay
    );
  }

  /// Minimax algorithm with alpha-beta pruning.
  int _minimax(
    MancalaState state,
    int depth,
    int alpha,
    int beta,
    bool isMaximizing,
  ) {
    // Terminal conditions
    if (depth == 0 || state.isGameOver) {
      return _evaluatePosition(state);
    }

    final validPits = state.validPits;

    if (validPits.isEmpty) {
      return _evaluatePosition(state);
    }

    if (isMaximizing) {
      int maxEval = -999999;

      for (final pitIndex in validPits) {
        final result = state.sowSeeds(pitIndex);

        // If extra turn, continue maximizing
        final eval = result.landedInStore && !result.newState.isGameOver
            ? _minimax(result.newState, depth - 1, alpha, beta, true)
            : _minimax(result.newState, depth - 1, alpha, beta, false);

        maxEval = max(maxEval, eval);
        alpha = max(alpha, eval);

        if (beta <= alpha) {
          break; // Beta cutoff
        }
      }

      return maxEval;
    } else {
      int minEval = 999999;

      for (final pitIndex in validPits) {
        final result = state.sowSeeds(pitIndex);

        // If extra turn, continue minimizing
        final eval = result.landedInStore && !result.newState.isGameOver
            ? _minimax(result.newState, depth - 1, alpha, beta, false)
            : _minimax(result.newState, depth - 1, alpha, beta, true);

        minEval = min(minEval, eval);
        beta = min(beta, eval);

        if (beta <= alpha) {
          break; // Alpha cutoff
        }
      }

      return minEval;
    }
  }

  /// Evaluate a board position from AI's perspective.
  /// Higher scores are better for AI (Player 2).
  int _evaluatePosition(MancalaState state) {
    // Game over evaluation
    if (state.isGameOver) {
      final winner = state.winner;
      if (winner == 1) return 100000; // AI wins
      if (winner == 0) return -100000; // Player wins
      return 0; // Draw
    }

    int score = 0;

    // Primary: store difference (most important)
    final storeDiff = state.player2Store - state.player1Store;
    score += storeDiff * 10;

    // Secondary: seeds on each side
    final p1Seeds = state.player1Pits.fold(0, (a, b) => a + b);
    final p2Seeds = state.player2Pits.fold(0, (a, b) => a + b);
    score += (p2Seeds - p1Seeds) * 2;

    // Tertiary: capture opportunities
    // Count empty pits on AI's side that could capture
    for (int i = 7; i < 13; i++) {
      if (state.board[i] == 0) {
        final oppositeIndex = 12 - i;
        if (state.board[oppositeIndex] > 0) {
          score += 5; // Potential capture
        }
      }
    }

    // Penalize empty pits on opponent's side that could capture
    for (int i = 0; i < 6; i++) {
      if (state.board[i] == 0) {
        final oppositeIndex = 12 - i;
        if (state.board[oppositeIndex] > 0) {
          score -= 5; // Opponent capture threat
        }
      }
    }

    // Bonus for extra turn potential
    // Pits that would land in store
    for (int i = 7; i < 13; i++) {
      if (state.board[i] > 0) {
        final seeds = state.board[i];
        final landingSpot = (i + seeds) % 14;
        // Account for skipping opponent's store
        int actualLanding = landingSpot;
        int steps = seeds;
        int pos = i;
        while (steps > 0) {
          pos = (pos + 1) % 14;
          if (pos != 6) {
            // Skip opponent's store
            steps--;
            actualLanding = pos;
          }
        }
        if (actualLanding == 13) {
          score += 15; // Extra turn potential
        }
      }
    }

    return score;
  }
}
