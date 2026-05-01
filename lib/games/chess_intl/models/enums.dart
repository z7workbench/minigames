enum PieceType { king, queen, rook, bishop, knight, pawn }

enum PieceColor { white, black }

enum PieceStyle { outline, filled }

enum GameStatus {
  idle,
  playing,
  check,
  checkmate,
  stalemate,
  draw,
  promotion,
  gameOver,
}

enum AiDifficulty { easy, hard }

enum PlayerColor { white, black }

enum DrawReason {
  stalemate,
  threefoldRepetition,
  fiftyMoveRule,
  insufficientMaterial,
  agreement,
}

extension PieceColorExtension on PieceColor {
  PieceColor get opposite => this == PieceColor.white ? PieceColor.black : PieceColor.white;

  String get symbol => this == PieceColor.white ? 'w' : 'b';
}

extension PieceTypeExtension on PieceType {
  String get symbol {
    switch (this) {
      case PieceType.king:
        return 'k';
      case PieceType.queen:
        return 'q';
      case PieceType.rook:
        return 'r';
      case PieceType.bishop:
        return 'b';
      case PieceType.knight:
        return 'n';
      case PieceType.pawn:
        return 'p';
    }
  }

  int get baseValue {
    switch (this) {
      case PieceType.king:
        return 0;
      case PieceType.queen:
        return 900;
      case PieceType.rook:
        return 500;
      case PieceType.bishop:
        return 330;
      case PieceType.knight:
        return 320;
      case PieceType.pawn:
        return 100;
    }
  }

  String get unicodeWhite {
    switch (this) {
      case PieceType.king:
        return '\u2654';
      case PieceType.queen:
        return '\u2655';
      case PieceType.rook:
        return '\u2656';
      case PieceType.bishop:
        return '\u2657';
      case PieceType.knight:
        return '\u2658';
      case PieceType.pawn:
        return '\u2659';
    }
  }

  String get unicodeBlack {
    switch (this) {
      case PieceType.king:
        return '\u265A';
      case PieceType.queen:
        return '\u265B';
      case PieceType.rook:
        return '\u265C';
      case PieceType.bishop:
        return '\u265D';
      case PieceType.knight:
        return '\u265E';
      case PieceType.pawn:
        return '\u265F';
    }
  }

  String unicodeByStyle(PieceColor color, PieceStyle style) {
    if (style == PieceStyle.outline) {
      return color == PieceColor.white ? unicodeWhite : unicodeBlack;
    }
    return unicodeBlack;
  }
}
