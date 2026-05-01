import 'dart:math';

import '../models/chess_move.dart';
import '../models/chess_state.dart';
import '../models/enums.dart';
import 'chess_ai.dart';

class EasyChessAi extends ChessAi {
  final Random _random = Random();

  @override
  Future<ChessMove?> findBestMove(
    ChessState state, {
    Duration? timeLimit,
    bool Function()? isCancelled,
  }) async {
    final moves = state.allLegalMoves;
    if (moves.isEmpty) return null;

    final scoredMoves = <(ChessMove, int)>[];
    for (final move in moves) {
      int score = 0;

      final captured = state.pieceAt(move.toRow, move.toCol);
      if (captured != null) {
        score += captured.type.baseValue * 10;
      }

      if (move.isEnPassant) {
        score += 100;
      }

      if (move.promotionPiece != null) {
        score += move.promotionPiece!.baseValue * 10;
      }

      final centerDist =
          (move.toRow - 3.5).abs() + (move.toCol - 3.5).abs();
      score += ((7 - centerDist) * 2).toInt();

      score += _random.nextInt(200);

      scoredMoves.add((move, score));
    }

    scoredMoves.sort((a, b) => b.$2.compareTo(a.$2));

    if (_random.nextDouble() < 0.2 && scoredMoves.length > 1) {
      final idx = 1 + _random.nextInt(min(3, scoredMoves.length - 1));
      return scoredMoves[idx].$1;
    }

    return scoredMoves.first.$1;
  }
}
