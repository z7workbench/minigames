import 'dart:math';

import '../models/connect_four_state.dart';
import '../models/enums.dart';
import '../logic/connect_four_rules.dart';
import 'connect_four_ai.dart';

class HardConnectFourAi extends ConnectFourAi {
  static const int _maxDepth = 6;
  static const int _timeBudgetMs = 1800;

  int? _bestMoveFound;
  bool _cancelled = false;

  @override
  Future<int?> findBestMove(
    ConnectFourState state, {
    Duration? timeLimit,
    bool Function()? isCancelled,
  }) async {
    _bestMoveFound = null;
    _cancelled = false;

    final effectiveTimeLimit =
        timeLimit ?? const Duration(milliseconds: _timeBudgetMs);
    final deadline = DateTime.now().add(effectiveTimeLimit);

    final validCols = state.validColumns;
    if (validCols.isEmpty) return null;

    if (validCols.length == 1) return validCols.first;

    final aiPiece = state.currentTurn;
    final playerPiece = aiPiece.opposite;

    for (final col in validCols) {
      if (ConnectFourRules.wouldWin(state, col, aiPiece)) return col;
    }

    for (final col in validCols) {
      if (ConnectFourRules.wouldWin(state, col, playerPiece)) return col;
    }

    final orderedCols = _orderColumns(state, validCols);
    _bestMoveFound = orderedCols.first;

    for (int depth = 1; depth <= _maxDepth; depth++) {
      if (_cancelled) break;
      if (DateTime.now().isAfter(deadline)) break;

      int bestScore = -999999;
      int? bestCol;

      for (final col in orderedCols) {
        if (_cancelled || DateTime.now().isAfter(deadline)) break;

        final newState = ConnectFourRules.applyMove(state, col);
        final score = -_alphaBeta(
          newState,
          depth - 1,
          -999999,
          -bestScore,
          deadline,
          aiPiece,
        );

        if (_cancelled) break;

        if (score > bestScore) {
          bestScore = score;
          bestCol = col;
        }
      }

      if (!_cancelled && bestCol != null) {
        _bestMoveFound = bestCol;
      }
    }

    return _bestMoveFound;
  }

  int _alphaBeta(
    ConnectFourState state,
    int depth,
    int alpha,
    int beta,
    DateTime deadline,
    CellState aiPiece,
  ) {
    if (_cancelled || DateTime.now().isAfter(deadline)) {
      _cancelled = true;
      return 0;
    }

    final validCols = state.validColumns;
    if (validCols.isEmpty) return 0;

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
        if (_cancelled) break;

        final newState = ConnectFourRules.applyMove(state, col);
        final score =
            _alphaBeta(newState, depth - 1, alpha, beta, deadline, aiPiece);
        best = max(best, score);
        alpha = max(alpha, best);
        if (beta <= alpha) break;
      }
      return best;
    } else {
      int best = 999999;
      for (final col in orderedCols) {
        if (_cancelled) break;

        final newState = ConnectFourRules.applyMove(state, col);
        final score =
            _alphaBeta(newState, depth - 1, alpha, beta, deadline, aiPiece);
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

      final aiPiece = state.currentTurn;
      final playerPiece = aiPiece.opposite;

      if (ConnectFourRules.wouldWin(state, c, aiPiece)) {
        priority += 10000;
      }
      if (ConnectFourRules.wouldWin(state, c, playerPiece)) {
        priority += 5000;
      }

      priority += ConnectFourRules.countThreats(state, c, aiPiece) * 3;

      return (c, priority);
    }).toList();

    scored.sort((a, b) => b.$2.compareTo(a.$2));
    return scored.map((e) => e.$1).toList();
  }
}
