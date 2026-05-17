import 'dart:math';

import '../models/connect_four_state.dart';
import '../models/enums.dart';
import '../logic/connect_four_rules.dart';
import 'connect_four_ai.dart';

class MediumConnectFourAi extends ConnectFourAi {
  static const int _maxDepth = 4;

  @override
  Future<int?> findBestMove(
    ConnectFourState state, {
    Duration? timeLimit,
    bool Function()? isCancelled,
  }) async {
    final validCols = state.validColumns;
    if (validCols.isEmpty) return null;

    if (validCols.length == 1) return validCols.first;

    final aiPiece = state.currentTurn;
    final playerPiece = aiPiece.opposite;

    for (final col in validCols) {
      if (ConnectFourRules.wouldWin(state, col, aiPiece)) {
        return col;
      }
    }

    for (final col in validCols) {
      if (ConnectFourRules.wouldWin(state, col, playerPiece)) {
        return col;
      }
    }

    final orderedCols = _orderColumns(state, validCols);

    int bestScore = -999999;
    int? bestCol = orderedCols.first;

    for (final col in orderedCols) {
      if (isCancelled?.call() == true) break;

      final newState = ConnectFourRules.applyMove(state, col);
      final score = -_alphaBeta(
        newState,
        _maxDepth - 1,
        -999999,
        -bestScore,
        playerPiece,
      );

      if (score > bestScore) {
        bestScore = score;
        bestCol = col;
      }
    }

    return bestCol;
  }

  int _alphaBeta(
    ConnectFourState state,
    int depth,
    int alpha,
    int beta,
    CellState aiPiece,
  ) {
    final validCols = state.validColumns;
    if (validCols.isEmpty) {
      return 0;
    }

    if (depth <= 0) {
      return ConnectFourRules.evaluateBoard(state, aiPiece);
    }

    final isMaximizing = state.currentTurn == aiPiece;

    for (final col in validCols) {
      if (ConnectFourRules.wouldWin(state, col, state.currentTurn)) {
        return isMaximizing ? 99999 + depth : -(99999 + depth);
      }
    }

    final orderedCols = _orderColumns(state, validCols);

    if (isMaximizing) {
      int best = -999999;
      for (final col in orderedCols) {
        final newState = ConnectFourRules.applyMove(state, col);
        final score = _alphaBeta(newState, depth - 1, alpha, beta, aiPiece);
        best = max(best, score);
        alpha = max(alpha, best);
        if (beta <= alpha) break;
      }
      return best;
    } else {
      int best = 999999;
      for (final col in orderedCols) {
        final newState = ConnectFourRules.applyMove(state, col);
        final score = _alphaBeta(newState, depth - 1, alpha, beta, aiPiece);
        best = min(best, score);
        beta = min(beta, best);
        if (beta <= alpha) break;
      }
      return best;
    }
  }

  List<int> _orderColumns(ConnectFourState state, List<int> cols) {
    const center = ConnectFourState.cols ~/ 2;
    final scored = cols.map((c) {
      int priority = 0;
      final distFromCenter = (c - center).abs();
      priority = (ConnectFourState.cols - distFromCenter) * 10;

      final row = state.getDropRow(c);
      if (row > 0 && row < ConnectFourState.rows - 1) {
        priority += 5;
      }

      return (c, priority);
    }).toList();

    scored.sort((a, b) => b.$2.compareTo(a.$2));
    return scored.map((e) => e.$1).toList();
  }
}
