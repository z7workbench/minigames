import 'enums.dart';

class ChessMove {
  final int fromRow;
  final int fromCol;
  final int toRow;
  final int toCol;
  final PieceType? promotionPiece;
  final bool isCastling;
  final bool isEnPassant;
  final PieceType? capturedPieceType;

  const ChessMove({
    required this.fromRow,
    required this.fromCol,
    required this.toRow,
    required this.toCol,
    this.promotionPiece,
    this.isCastling = false,
    this.isEnPassant = false,
    this.capturedPieceType,
  });

  String get uci {
    final from = colToFile(fromCol) + rowToRank(fromRow);
    final to = colToFile(toCol) + rowToRank(toRow);
    final promo = promotionPiece != null ? promotionPiece!.symbol : '';
    return '$from$to$promo';
  }

  static String colToFile(int col) => String.fromCharCode(97 + col);
  static String rowToRank(int row) => (8 - row).toString();

  static int fileToCol(String file) => file.codeUnitAt(0) - 97;
  static int rankToRow(String rank) => 8 - int.parse(rank);

  factory ChessMove.fromUci(String uci) {
    final fromCol = fileToCol(uci[0]);
    final fromRow = rankToRow(uci[1]);
    final toCol = fileToCol(uci[2]);
    final toRow = rankToRow(uci[3]);
    PieceType? promo;
    if (uci.length > 4) {
      promo = PieceType.values.firstWhere(
        (t) => t.symbol == uci[4],
      );
    }
    return ChessMove(
      fromRow: fromRow,
      fromCol: fromCol,
      toRow: toRow,
      toCol: toCol,
      promotionPiece: promo,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChessMove &&
          runtimeType == other.runtimeType &&
          fromRow == other.fromRow &&
          fromCol == other.fromCol &&
          toRow == other.toRow &&
          toCol == other.toCol &&
          promotionPiece == other.promotionPiece;

  @override
  int get hashCode =>
      Object.hash(fromRow, fromCol, toRow, toCol, promotionPiece);

  @override
  String toString() => uci;
}
