import '../models/chess_move.dart';
import '../models/chess_piece.dart';
import '../models/chess_state.dart';
import '../models/enums.dart';

class SanConverter {
  static String moveToSan(ChessState state, ChessMove move) {
    if (move.isCastling) {
      return move.toCol == 6 ? 'O-O' : 'O-O-O';
    }

    final piece = state.pieceAt(move.fromRow, move.fromCol);
    if (piece == null) return move.uci;

    final buffer = StringBuffer();

    if (piece.type != PieceType.pawn) {
      buffer.write(piece.type.symbol.toUpperCase());

      final disambig = _getDisambiguation(state, move, piece);
      buffer.write(disambig);
    }

    final isCapture = state.pieceAt(move.toRow, move.toCol) != null ||
        move.isEnPassant;
    if (isCapture) {
      if (piece.type == PieceType.pawn) {
        buffer.write(ChessMove.colToFile(move.fromCol));
      }
      buffer.write('x');
    }

    buffer.write(ChessMove.colToFile(move.toCol));
    buffer.write(ChessMove.rowToRank(move.toRow));

    if (move.promotionPiece != null) {
      buffer.write('=${move.promotionPiece!.symbol.toUpperCase()}');
    }

    final newState = state.applyMove(move);
    if (newState.status == GameStatus.checkmate) {
      buffer.write('#');
    } else if (newState.isCheck) {
      buffer.write('+');
    }

    return buffer.toString();
  }

  static String _getDisambiguation(
      ChessState state, ChessMove move, ChessPiece piece) {
    final sameTypePieces = <(int, int)>[];
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (r == move.fromRow && c == move.fromCol) continue;
        final p = state.board[r][c];
        if (p != null &&
            p.type == piece.type &&
            p.color == piece.color) {
          final legalMoves = state.getLegalMovesForSquare(r, c);
          if (legalMoves.any(
            (m) => m.toRow == move.toRow && m.toCol == move.toCol,
          )) {
            sameTypePieces.add((r, c));
          }
        }
      }
    }

    if (sameTypePieces.isEmpty) return '';

    final sameFile =
        sameTypePieces.any((pos) => pos.$2 == move.fromCol);
    final sameRank =
        sameTypePieces.any((pos) => pos.$1 == move.fromRow);

    if (!sameFile) {
      return ChessMove.colToFile(move.fromCol);
    } else if (!sameRank) {
      return ChessMove.rowToRank(move.fromRow);
    } else {
      return '${ChessMove.colToFile(move.fromCol)}${ChessMove.rowToRank(move.fromRow)}';
    }
  }

  static List<String> moveToPgnMoves(ChessState state) {
    final moves = <String>[];
    var currentState = ChessState.fromFen(
      state.isImported
          ? _getInitialFen(state)
          : 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
    );

    for (final move in state.moveHistory) {
      final san = moveToSan(currentState, move);
      if (currentState.currentTurn == PieceColor.white) {
        moves.add('${currentState.fullMoveNumber}.$san');
      } else {
        if (moves.isEmpty) {
          moves.add('${currentState.fullMoveNumber}...$san');
        } else {
          moves.add(san);
        }
      }
      currentState = currentState.applyMove(move);
    }

    return moves;
  }

  static String _getInitialFen(ChessState state) {
    if (state.positionHistory.isNotEmpty) {
      return _reconstructFenFromHistory(state);
    }
    return 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  }

  static String _reconstructFenFromHistory(ChessState state) {
    final moves = state.moveHistory;
    if (moves.isEmpty) return state.toFen();

    var current = ChessState.initial();
    for (int i = 0; i < moves.length; i++) {
      current = current.applyMove(moves[i]);
    }

    if (state.isImported && state.positionHistory.isNotEmpty) {
      return state.positionHistory.first;
    }

    return 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  }
}
