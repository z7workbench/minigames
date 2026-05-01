import '../models/chess_state.dart';
import '../models/enums.dart';

class FenValidator {
  static (ChessState?, String?) parse(String fen) {
    final trimmed = fen.trim();
    if (trimmed.isEmpty) {
      return (null, 'FEN string is empty');
    }

    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length < 4) {
      return (null, 'FEN must have at least 4 fields (got ${parts.length})');
    }

    if (parts.length > 6) {
      return (null, 'FEN has too many fields (got ${parts.length})');
    }

    final boardPart = parts[0];
    final rows = boardPart.split('/');
    if (rows.length != 8) {
      return (null, 'Board must have 8 rows (got ${rows.length})');
    }

    int whiteKingCount = 0;
    int blackKingCount = 0;

    for (int r = 0; r < 8; r++) {
      int colCount = 0;
      for (final ch in rows[r].split('')) {
        if (ch.codeUnitAt(0) >= 49 && ch.codeUnitAt(0) <= 56) {
          colCount += int.parse(ch);
        } else if ('kqrbnp'.contains(ch.toLowerCase())) {
          colCount++;
          if (ch == 'K') whiteKingCount++;
          if (ch == 'k') blackKingCount++;
          if (ch.toLowerCase() == 'p' && (r == 0 || r == 7)) {
            return (null, 'Pawns cannot be on rank ${r == 0 ? 1 : 8}');
          }
        } else {
          return (null, 'Invalid character "$ch" in board');
        }
      }
      if (colCount != 8) {
        return (null, 'Row ${r + 1} has $colCount squares (expected 8)');
      }
    }

    if (whiteKingCount != 1) {
      return (null, 'White must have exactly 1 king (found $whiteKingCount)');
    }
    if (blackKingCount != 1) {
      return (null, 'Black must have exactly 1 king (found $blackKingCount)');
    }

    final turnPart = parts[1];
    if (turnPart != 'w' && turnPart != 'b') {
      return (null, 'Active color must be "w" or "b" (got "$turnPart")');
    }

    final castlingPart = parts[2];
    if (castlingPart != '-') {
      final validCastling = RegExp(r'^[KQkq]+$');
      if (!validCastling.hasMatch(castlingPart)) {
        return (null, 'Invalid castling availability: "$castlingPart"');
      }
    }

    final epPart = parts[3];
    if (epPart != '-') {
      if (epPart.length != 2) {
        return (null, 'Invalid en passant square: "$epPart"');
      }
      final file = epPart[0];
      final rank = epPart[1];
      if (file.codeUnitAt(0) < 97 || file.codeUnitAt(0) > 104) {
        return (null, 'Invalid en passant file: "$file"');
      }
      if (rank != '3' && rank != '6') {
        return (null, 'Invalid en passant rank: "$rank"');
      }
    }

    if (parts.length > 4) {
      final halfMove = int.tryParse(parts[4]);
      if (halfMove == null || halfMove < 0) {
        return (null, 'Invalid half-move clock: "${parts[4]}"');
      }
    }

    if (parts.length > 5) {
      final fullMove = int.tryParse(parts[5]);
      if (fullMove == null || fullMove < 1) {
        return (null, 'Invalid full-move number: "${parts[5]}"');
      }
    }

    try {
      final state = ChessState.fromFen(trimmed);
      if (state.isCheck) {
        if (turnPart == state.currentTurn.symbol) {
          return (null,
              'The side to move ($turnPart) is in check, which is illegal');
        }
      }
      return (state, null);
    } catch (e) {
      return (null, 'Failed to parse FEN: $e');
    }
  }
}
