import 'enums.dart';

class ChessPiece {
  final PieceType type;
  final PieceColor color;
  final bool hasMoved;

  const ChessPiece({
    required this.type,
    required this.color,
    this.hasMoved = false,
  });

  ChessPiece copyWith({
    PieceType? type,
    PieceColor? color,
    bool? hasMoved,
  }) {
    return ChessPiece(
      type: type ?? this.type,
      color: color ?? this.color,
      hasMoved: hasMoved ?? this.hasMoved,
    );
  }

  String get unicode =>
      color == PieceColor.white ? type.unicodeWhite : type.unicodeBlack;

  String unicodeStyled(PieceStyle style) =>
      type.unicodeByStyle(color, style);

  String get symbol {
    final s = type.symbol;
    return color == PieceColor.white ? s.toUpperCase() : s;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChessPiece &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          color == other.color &&
          hasMoved == other.hasMoved;

  @override
  int get hashCode => Object.hash(type, color, hasMoved);

  Map<String, dynamic> toJson() => {
        'type': type.symbol,
        'color': color.symbol,
        'hasMoved': hasMoved,
      };

  factory ChessPiece.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final colorStr = json['color'] as String;
    final type = PieceType.values.firstWhere(
      (t) => t.symbol == typeStr,
    );
    final color = colorStr == 'w' ? PieceColor.white : PieceColor.black;
    return ChessPiece(
      type: type,
      color: color,
      hasMoved: json['hasMoved'] as bool? ?? false,
    );
  }
}
