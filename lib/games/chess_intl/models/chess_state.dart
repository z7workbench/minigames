import 'chess_piece.dart';
import 'chess_move.dart';
import 'enums.dart';

class ChessState {
  final List<List<ChessPiece?>> board;
  final PieceColor currentTurn;
  final bool whiteCanCastleKingside;
  final bool whiteCanCastleQueenside;
  final bool blackCanCastleKingside;
  final bool blackCanCastleQueenside;
  final int? enPassantTargetRow;
  final int? enPassantTargetCol;
  final int halfMoveClock;
  final int fullMoveNumber;
  final List<ChessMove> moveHistory;
  final List<String> positionHistory;
  final GameStatus status;
  final PieceColor? winner;
  final DrawReason? drawReason;
  final int? lastMoveFromRow;
  final int? lastMoveFromCol;
  final int? lastMoveToRow;
  final int? lastMoveToCol;
  final bool isImported;
  final List<ChessPiece> capturedWhitePieces;
  final List<ChessPiece> capturedBlackPieces;

  const ChessState({
    required this.board,
    this.currentTurn = PieceColor.white,
    this.whiteCanCastleKingside = true,
    this.whiteCanCastleQueenside = true,
    this.blackCanCastleKingside = true,
    this.blackCanCastleQueenside = true,
    this.enPassantTargetRow,
    this.enPassantTargetCol,
    this.halfMoveClock = 0,
    this.fullMoveNumber = 1,
    this.moveHistory = const [],
    this.positionHistory = const [],
    this.status = GameStatus.playing,
    this.winner,
    this.drawReason,
    this.lastMoveFromRow,
    this.lastMoveFromCol,
    this.lastMoveToRow,
    this.lastMoveToCol,
    this.isImported = false,
    this.capturedWhitePieces = const [],
    this.capturedBlackPieces = const [],
  });

  factory ChessState.initial() {
    return ChessState.fromFen('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1');
  }

  factory ChessState.fromFen(String fen) {
    final parts = fen.split(' ');
    if (parts.length < 4) {
      throw FormatException('Invalid FEN: not enough fields');
    }

    final boardPart = parts[0];
    final turnPart = parts[1];
    final castlingPart = parts[2];
    final enPassantPart = parts[3];
    final halfMove = parts.length > 4 ? int.parse(parts[4]) : 0;
    final fullMove = parts.length > 5 ? int.parse(parts[5]) : 1;

    final board = List<List<ChessPiece?>>.generate(
      8,
      (_) => List<ChessPiece?>.filled(8, null),
    );

    final rows = boardPart.split('/');
    if (rows.length != 8) {
      throw FormatException('Invalid FEN: board must have 8 rows');
    }

    for (int r = 0; r < 8; r++) {
      int c = 0;
      for (final ch in rows[r].split('')) {
        if (ch.codeUnitAt(0) >= 49 && ch.codeUnitAt(0) <= 56) {
          c += int.parse(ch);
        } else {
          final isUpper = ch == ch.toUpperCase();
          final color =
              isUpper ? PieceColor.white : PieceColor.black;
          final type = _pieceTypeFromChar(ch.toLowerCase());
          if (type == null) {
            throw FormatException('Invalid FEN: unknown piece "$ch"');
          }
          board[r][c] = ChessPiece(
            type: type,
            color: color,
            hasMoved: true,
          );
          c++;
        }
      }
      if (c != 8) {
        throw FormatException('Invalid FEN: row $r has $c columns');
      }
    }

    final turn =
        turnPart == 'w' ? PieceColor.white : PieceColor.black;

    final whiteKingside = castlingPart.contains('K');
    final whiteQueenside = castlingPart.contains('Q');
    final blackKingside = castlingPart.contains('k');
    final blackQueenside = castlingPart.contains('q');

    int? epRow;
    int? epCol;
    if (enPassantPart != '-') {
      epCol = ChessMove.fileToCol(enPassantPart[0]);
      epRow = ChessMove.rankToRow(enPassantPart[1]);
    }

    return ChessState(
      board: board,
      currentTurn: turn,
      whiteCanCastleKingside: whiteKingside,
      whiteCanCastleQueenside: whiteQueenside,
      blackCanCastleKingside: blackKingside,
      blackCanCastleQueenside: blackQueenside,
      enPassantTargetRow: epRow,
      enPassantTargetCol: epCol,
      halfMoveClock: halfMove,
      fullMoveNumber: fullMove,
      status: GameStatus.playing,
    );
  }

  static PieceType? _pieceTypeFromChar(String ch) {
    switch (ch) {
      case 'k':
        return PieceType.king;
      case 'q':
        return PieceType.queen;
      case 'r':
        return PieceType.rook;
      case 'b':
        return PieceType.bishop;
      case 'n':
        return PieceType.knight;
      case 'p':
        return PieceType.pawn;
      default:
        return null;
    }
  }

  String toFen() {
    final buffer = StringBuffer();

    for (int r = 0; r < 8; r++) {
      int empty = 0;
      for (int c = 0; c < 8; c++) {
        final piece = board[r][c];
        if (piece == null) {
          empty++;
        } else {
          if (empty > 0) {
            buffer.write(empty);
            empty = 0;
          }
          buffer.write(piece.symbol);
        }
      }
      if (empty > 0) buffer.write(empty);
      if (r < 7) buffer.write('/');
    }

    buffer.write(currentTurn == PieceColor.white ? ' w' : ' b');

    final castling = StringBuffer();
    if (whiteCanCastleKingside) castling.write('K');
    if (whiteCanCastleQueenside) castling.write('Q');
    if (blackCanCastleKingside) castling.write('k');
    if (blackCanCastleQueenside) castling.write('q');
    buffer.write(castling.isEmpty ? ' -' : ' ${castling}');

    if (enPassantTargetRow != null && enPassantTargetCol != null) {
      final epFile = ChessMove.colToFile(enPassantTargetCol!);
      final epRank = ChessMove.rowToRank(enPassantTargetRow!);
      buffer.write(' $epFile$epRank');
    } else {
      buffer.write(' -');
    }

    buffer.write(' $halfMoveClock');
    buffer.write(' $fullMoveNumber');

    return buffer.toString();
  }

  String get positionKey {
    final castling = StringBuffer();
    if (whiteCanCastleKingside) castling.write('K');
    if (whiteCanCastleQueenside) castling.write('Q');
    if (blackCanCastleKingside) castling.write('k');
    if (blackCanCastleQueenside) castling.write('q');

    final ep = (enPassantTargetRow != null && enPassantTargetCol != null)
        ? '${enPassantTargetCol!},${enPassantTargetRow!}'
        : '-';

    final pieces = StringBuffer();
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final p = board[r][c];
        if (p != null) {
          pieces.write('$r$c${p.symbol}');
        }
      }
    }

    return '${pieces}_${currentTurn.symbol}_${castling}_$ep';
  }

  ChessPiece? pieceAt(int row, int col) {
    if (row < 0 || row > 7 || col < 0 || col > 7) return null;
    return board[row][col];
  }

  bool get isCheck {
    final kingPos = _findKing(currentTurn);
    if (kingPos == null) return false;
    return _isSquareAttacked(kingPos.$1, kingPos.$2, currentTurn.opposite);
  }

  (int, int)? _findKing(PieceColor color) {
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final p = board[r][c];
        if (p != null && p.type == PieceType.king && p.color == color) {
          return (r, c);
        }
      }
    }
    return null;
  }

  bool _isSquareAttacked(int row, int col, PieceColor byColor) {
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final p = board[r][c];
        if (p == null || p.color != byColor) continue;
        if (_canPieceAttack(r, c, row, col, p)) return true;
      }
    }
    return false;
  }

  bool _canPieceAttack(
      int fromRow, int fromCol, int toRow, int toCol, ChessPiece piece) {
    final dr = toRow - fromRow;
    final dc = toCol - fromCol;

    switch (piece.type) {
      case PieceType.pawn:
        final dir = piece.color == PieceColor.white ? -1 : 1;
        return dr == dir && dc.abs() == 1;
      case PieceType.knight:
        return (dr.abs() == 2 && dc.abs() == 1) ||
            (dr.abs() == 1 && dc.abs() == 2);
      case PieceType.bishop:
        if (dr.abs() != dc.abs() || dr == 0) return false;
        return _isPathClear(fromRow, fromCol, toRow, toCol);
      case PieceType.rook:
        if (dr != 0 && dc != 0) return false;
        return _isPathClear(fromRow, fromCol, toRow, toCol);
      case PieceType.queen:
        if (dr == 0 || dc == 0 || dr.abs() == dc.abs()) {
          return _isPathClear(fromRow, fromCol, toRow, toCol);
        }
        return false;
      case PieceType.king:
        return dr.abs() <= 1 && dc.abs() <= 1;
    }
  }

  bool _isPathClear(int fromRow, int fromCol, int toRow, int toCol) {
    final dr = (toRow - fromRow).sign;
    final dc = (toCol - fromCol).sign;
    int r = fromRow + dr;
    int c = fromCol + dc;
    while (r != toRow || c != toCol) {
      if (board[r][c] != null) return false;
      r += dr;
      c += dc;
    }
    return true;
  }

  List<ChessMove> get legalMoves => _generateLegalMoves(currentTurn);

  List<ChessMove> _generateLegalMoves(PieceColor color) {
    final moves = <ChessMove>[];
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final p = board[r][c];
        if (p == null || p.color != color) continue;
        moves.addAll(_generatePieceMoves(r, c, p));
      }
    }
    return moves;
  }

  List<ChessMove> _generatePieceMoves(int row, int col, ChessPiece piece) {
    final moves = <ChessMove>[];

    switch (piece.type) {
      case PieceType.pawn:
        _generatePawnMoves(row, col, piece, moves);
        break;
      case PieceType.knight:
        _generateKnightMoves(row, col, piece, moves);
        break;
      case PieceType.bishop:
        _generateSlidingMoves(row, col, piece, moves, [
          (-1, -1),
          (-1, 1),
          (1, -1),
          (1, 1),
        ]);
        break;
      case PieceType.rook:
        _generateSlidingMoves(row, col, piece, moves, [
          (-1, 0),
          (1, 0),
          (0, -1),
          (0, 1),
        ]);
        break;
      case PieceType.queen:
        _generateSlidingMoves(row, col, piece, moves, [
          (-1, -1),
          (-1, 1),
          (1, -1),
          (1, 1),
          (-1, 0),
          (1, 0),
          (0, -1),
          (0, 1),
        ]);
        break;
      case PieceType.king:
        _generateKingMoves(row, col, piece, moves);
        break;
    }

    return moves;
  }

  void _generatePawnMoves(
      int row, int col, ChessPiece piece, List<ChessMove> moves) {
    final dir = piece.color == PieceColor.white ? -1 : 1;
    final startRow = piece.color == PieceColor.white ? 6 : 1;
    final promoRow = piece.color == PieceColor.white ? 0 : 7;

    final oneStepRow = row + dir;
    if (oneStepRow >= 0 &&
        oneStepRow < 8 &&
        board[oneStepRow][col] == null) {
      if (oneStepRow == promoRow) {
        for (final promo in [
          PieceType.queen,
          PieceType.rook,
          PieceType.bishop,
          PieceType.knight,
        ]) {
          moves.add(ChessMove(
            fromRow: row,
            fromCol: col,
            toRow: oneStepRow,
            toCol: col,
            promotionPiece: promo,
          ));
        }
      } else {
        moves.add(ChessMove(
          fromRow: row,
          fromCol: col,
          toRow: oneStepRow,
          toCol: col,
        ));
      }

      if (row == startRow) {
        final twoStepRow = row + 2 * dir;
        if (board[twoStepRow][col] == null) {
          moves.add(ChessMove(
            fromRow: row,
            fromCol: col,
            toRow: twoStepRow,
            toCol: col,
          ));
        }
      }
    }

    for (final dc in [-1, 1]) {
      final captureCol = col + dc;
      if (captureCol < 0 || captureCol > 7) continue;

      final targetRow = oneStepRow;
      if (targetRow < 0 || targetRow > 7) continue;

      final target = board[targetRow][captureCol];
      if (target != null && target.color != piece.color) {
        if (targetRow == promoRow) {
          for (final promo in [
            PieceType.queen,
            PieceType.rook,
            PieceType.bishop,
            PieceType.knight,
          ]) {
            moves.add(ChessMove(
              fromRow: row,
              fromCol: col,
              toRow: targetRow,
              toCol: captureCol,
              promotionPiece: promo,
              capturedPieceType: target.type,
            ));
          }
        } else {
          moves.add(ChessMove(
            fromRow: row,
            fromCol: col,
            toRow: targetRow,
            toCol: captureCol,
            capturedPieceType: target.type,
          ));
        }
      }

      if (targetRow == enPassantTargetRow &&
          captureCol == enPassantTargetCol) {
        moves.add(ChessMove(
          fromRow: row,
          fromCol: col,
          toRow: targetRow,
          toCol: captureCol,
          isEnPassant: true,
          capturedPieceType: PieceType.pawn,
        ));
      }
    }
  }

  void _generateKnightMoves(
      int row, int col, ChessPiece piece, List<ChessMove> moves) {
    const offsets = [
      (-2, -1),
      (-2, 1),
      (-1, -2),
      (-1, 2),
      (1, -2),
      (1, 2),
      (2, -1),
      (2, 1),
    ];
    for (final (dr, dc) in offsets) {
      final nr = row + dr;
      final nc = col + dc;
      if (nr < 0 || nr > 7 || nc < 0 || nc > 7) continue;
      final target = board[nr][nc];
      if (target == null || target.color != piece.color) {
        moves.add(ChessMove(
          fromRow: row,
          fromCol: col,
          toRow: nr,
          toCol: nc,
          capturedPieceType: target?.type,
        ));
      }
    }
  }

  void _generateSlidingMoves(int row, int col, ChessPiece piece,
      List<ChessMove> moves, List<(int, int)> directions) {
    for (final (dr, dc) in directions) {
      int nr = row + dr;
      int nc = col + dc;
      while (nr >= 0 && nr < 8 && nc >= 0 && nc < 8) {
        final target = board[nr][nc];
        if (target == null) {
          moves.add(ChessMove(
            fromRow: row,
            fromCol: col,
            toRow: nr,
            toCol: nc,
          ));
        } else {
          if (target.color != piece.color) {
            moves.add(ChessMove(
              fromRow: row,
              fromCol: col,
              toRow: nr,
              toCol: nc,
              capturedPieceType: target.type,
            ));
          }
          break;
        }
        nr += dr;
        nc += dc;
      }
    }
  }

  void _generateKingMoves(
      int row, int col, ChessPiece piece, List<ChessMove> moves) {
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        final nr = row + dr;
        final nc = col + dc;
        if (nr < 0 || nr > 7 || nc < 0 || nc > 7) continue;
        final target = board[nr][nc];
        if (target == null || target.color != piece.color) {
          moves.add(ChessMove(
            fromRow: row,
            fromCol: col,
            toRow: nr,
            toCol: nc,
            capturedPieceType: target?.type,
          ));
        }
      }
    }

    if (piece.color == PieceColor.white) {
      if (whiteCanCastleKingside &&
          board[7][5] == null &&
          board[7][6] == null &&
          !_isSquareAttacked(7, 4, PieceColor.black) &&
          !_isSquareAttacked(7, 5, PieceColor.black) &&
          !_isSquareAttacked(7, 6, PieceColor.black)) {
        moves.add(const ChessMove(
          fromRow: 7,
          fromCol: 4,
          toRow: 7,
          toCol: 6,
          isCastling: true,
        ));
      }
      if (whiteCanCastleQueenside &&
          board[7][3] == null &&
          board[7][2] == null &&
          board[7][1] == null &&
          !_isSquareAttacked(7, 4, PieceColor.black) &&
          !_isSquareAttacked(7, 3, PieceColor.black) &&
          !_isSquareAttacked(7, 2, PieceColor.black)) {
        moves.add(const ChessMove(
          fromRow: 7,
          fromCol: 4,
          toRow: 7,
          toCol: 2,
          isCastling: true,
        ));
      }
    } else {
      if (blackCanCastleKingside &&
          board[0][5] == null &&
          board[0][6] == null &&
          !_isSquareAttacked(0, 4, PieceColor.white) &&
          !_isSquareAttacked(0, 5, PieceColor.white) &&
          !_isSquareAttacked(0, 6, PieceColor.white)) {
        moves.add(const ChessMove(
          fromRow: 0,
          fromCol: 4,
          toRow: 0,
          toCol: 6,
          isCastling: true,
        ));
      }
      if (blackCanCastleQueenside &&
          board[0][3] == null &&
          board[0][2] == null &&
          board[0][1] == null &&
          !_isSquareAttacked(0, 4, PieceColor.white) &&
          !_isSquareAttacked(0, 3, PieceColor.white) &&
          !_isSquareAttacked(0, 2, PieceColor.white)) {
        moves.add(const ChessMove(
          fromRow: 0,
          fromCol: 4,
          toRow: 0,
          toCol: 2,
          isCastling: true,
        ));
      }
    }
  }

  List<ChessMove> getLegalMovesForSquare(int row, int col) {
    final piece = board[row][col];
    if (piece == null || piece.color != currentTurn) return [];
    final pseudoMoves = _generatePieceMoves(row, col, piece);
    return pseudoMoves.where((m) => _isLegalMove(m)).toList();
  }

  bool _isLegalMove(ChessMove move) {
    final newState = _applyMoveUnchecked(move);
    final ourColor = currentTurn;
    final kingPos = newState._findKing(ourColor);
    if (kingPos == null) return false;
    return !newState._isSquareAttacked(kingPos.$1, kingPos.$2, ourColor.opposite);
  }

  List<ChessMove> get allLegalMoves {
    final pseudoMoves = _generateLegalMoves(currentTurn);
    return pseudoMoves.where((m) => _isLegalMove(m)).toList();
  }

  ChessState _applyMoveUnchecked(ChessMove move) {
    final newBoard = List<List<ChessPiece?>>.generate(
      8,
      (r) => List<ChessPiece?>.from(board[r]),
    );

    final piece = newBoard[move.fromRow][move.fromCol]!;
    final movedPiece = piece.copyWith(hasMoved: true);

    newBoard[move.fromRow][move.fromCol] = null;

    if (move.isEnPassant) {
      final capturedRow =
          piece.color == PieceColor.white ? move.toRow + 1 : move.toRow - 1;
      newBoard[capturedRow][move.toCol] = null;
    }

    if (move.isCastling) {
      newBoard[move.fromRow][move.fromCol] = null;
      if (move.toCol == 6) {
        newBoard[move.fromRow][5] =
            newBoard[move.fromRow][7]?.copyWith(hasMoved: true);
        newBoard[move.fromRow][7] = null;
      } else {
        newBoard[move.fromRow][3] =
            newBoard[move.fromRow][0]?.copyWith(hasMoved: true);
        newBoard[move.fromRow][0] = null;
      }
    }

    if (move.promotionPiece != null) {
      newBoard[move.toRow][move.toCol] = ChessPiece(
        type: move.promotionPiece!,
        color: piece.color,
        hasMoved: true,
      );
    } else {
      newBoard[move.toRow][move.toCol] = movedPiece;
    }

    int? newEpRow;
    int? newEpCol;
    if (piece.type == PieceType.pawn &&
        (move.toRow - move.fromRow).abs() == 2) {
      newEpRow = (move.fromRow + move.toRow) ~/ 2;
      newEpCol = move.fromCol;
    }

    bool wK = whiteCanCastleKingside;
    bool wQ = whiteCanCastleQueenside;
    bool bK = blackCanCastleKingside;
    bool bQ = blackCanCastleQueenside;

    if (piece.type == PieceType.king) {
      if (piece.color == PieceColor.white) {
        wK = false;
        wQ = false;
      } else {
        bK = false;
        bQ = false;
      }
    }
    if (piece.type == PieceType.rook) {
      if (move.fromRow == 7 && move.fromCol == 0) wQ = false;
      if (move.fromRow == 7 && move.fromCol == 7) wK = false;
      if (move.fromRow == 0 && move.fromCol == 0) bQ = false;
      if (move.fromRow == 0 && move.fromCol == 7) bK = false;
    }
    if (move.toRow == 7 && move.toCol == 0) wQ = false;
    if (move.toRow == 7 && move.toCol == 7) wK = false;
    if (move.toRow == 0 && move.toCol == 0) bQ = false;
    if (move.toRow == 0 && move.toCol == 7) bK = false;

    final isCapture = board[move.toRow][move.toCol] != null || move.isEnPassant;
    final isPawnMove = piece.type == PieceType.pawn;
    final newHalfMove = (isCapture || isPawnMove) ? 0 : halfMoveClock + 1;
    final newFullMove =
        currentTurn == PieceColor.black ? fullMoveNumber + 1 : fullMoveNumber;

    return ChessState(
      board: newBoard,
      currentTurn: currentTurn.opposite,
      whiteCanCastleKingside: wK,
      whiteCanCastleQueenside: wQ,
      blackCanCastleKingside: bK,
      blackCanCastleQueenside: bQ,
      enPassantTargetRow: newEpRow,
      enPassantTargetCol: newEpCol,
      halfMoveClock: newHalfMove,
      fullMoveNumber: newFullMove,
      status: GameStatus.playing,
    );
  }

  ChessState applyMove(ChessMove move) {
    final piece = board[move.fromRow][move.fromCol];
    if (piece == null) return this;

    final captured = board[move.toRow][move.toCol];
    final List<ChessPiece> newCapturedWhite = List.from(capturedWhitePieces);
    final List<ChessPiece> newCapturedBlack = List.from(capturedBlackPieces);

    if (captured != null) {
      if (captured.color == PieceColor.white) {
        newCapturedWhite.add(captured);
      } else {
        newCapturedBlack.add(captured);
      }
    }

    if (move.isEnPassant) {
      final capturedRow =
          piece.color == PieceColor.white ? move.toRow + 1 : move.toRow - 1;
      final epCaptured = board[capturedRow][move.toCol];
      if (epCaptured != null) {
        if (epCaptured.color == PieceColor.white) {
          newCapturedWhite.add(epCaptured);
        } else {
          newCapturedBlack.add(epCaptured);
        }
      }
    }

    var newState = _applyMoveUnchecked(move);
    final newHistory = [...moveHistory, move];
    final newPosHistory = [...positionHistory, positionKey];

    newState = ChessState(
      board: newState.board,
      currentTurn: newState.currentTurn,
      whiteCanCastleKingside: newState.whiteCanCastleKingside,
      whiteCanCastleQueenside: newState.whiteCanCastleQueenside,
      blackCanCastleKingside: newState.blackCanCastleKingside,
      blackCanCastleQueenside: newState.blackCanCastleQueenside,
      enPassantTargetRow: newState.enPassantTargetRow,
      enPassantTargetCol: newState.enPassantTargetCol,
      halfMoveClock: newState.halfMoveClock,
      fullMoveNumber: newState.fullMoveNumber,
      moveHistory: newHistory,
      positionHistory: newPosHistory,
      lastMoveFromRow: move.fromRow,
      lastMoveFromCol: move.fromCol,
      lastMoveToRow: move.toRow,
      lastMoveToCol: move.toCol,
      capturedWhitePieces: newCapturedWhite,
      capturedBlackPieces: newCapturedBlack,
    );

    return newState._updateGameStatus();
  }

  ChessState _updateGameStatus() {
    final legal = allLegalMoves;

    if (legal.isEmpty) {
      if (isCheck) {
      return copyWith(
        status: GameStatus.checkmate,
        winner: currentTurn.opposite,
      );
      } else {
        return copyWith(
          status: GameStatus.stalemate,
          drawReason: DrawReason.stalemate,
        );
      }
    }

    if (halfMoveClock >= 100) {
      return copyWith(
        status: GameStatus.draw,
        drawReason: DrawReason.fiftyMoveRule,
      );
    }

    if (_isInsufficientMaterial()) {
      return copyWith(
        status: GameStatus.draw,
        drawReason: DrawReason.insufficientMaterial,
      );
    }

    int count = 0;
    for (final pos in positionHistory) {
      if (pos == positionKey) count++;
    }
    if (count >= 3) {
      return copyWith(
        status: GameStatus.draw,
        drawReason: DrawReason.threefoldRepetition,
      );
    }

    if (isCheck) {
      return copyWith(status: GameStatus.check);
    }

    return copyWith(status: GameStatus.playing);
  }

  bool _isInsufficientMaterial() {
    final pieces = <PieceColor, List<PieceType>>{
      PieceColor.white: [],
      PieceColor.black: [],
    };

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final p = board[r][c];
        if (p != null) {
          pieces[p.color]!.add(p.type);
        }
      }
    }

    final whitePieces = pieces[PieceColor.white]!;
    final blackPieces = pieces[PieceColor.black]!;

    if (whitePieces.length == 1 && blackPieces.length == 1) return true;

    if (whitePieces.length == 1 &&
        blackPieces.length == 2 &&
        (blackPieces.contains(PieceType.bishop) ||
            blackPieces.contains(PieceType.knight))) return true;

    if (blackPieces.length == 1 &&
        whitePieces.length == 2 &&
        (whitePieces.contains(PieceType.bishop) ||
            whitePieces.contains(PieceType.knight))) return true;

    return false;
  }

  ChessState copyWith({
    PieceColor? currentTurn,
    bool? whiteCanCastleKingside,
    bool? whiteCanCastleQueenside,
    bool? blackCanCastleKingside,
    bool? blackCanCastleQueenside,
    int? enPassantTargetRow,
    int? enPassantTargetCol,
    int? halfMoveClock,
    int? fullMoveNumber,
    List<ChessMove>? moveHistory,
    List<String>? positionHistory,
    GameStatus? status,
    PieceColor? winner,
    DrawReason? drawReason,
    int? lastMoveFromRow,
    int? lastMoveFromCol,
    int? lastMoveToRow,
    int? lastMoveToCol,
    bool? isImported,
    List<ChessPiece>? capturedWhitePieces,
    List<ChessPiece>? capturedBlackPieces,
  }) {
    return ChessState(
      board: board,
      currentTurn: currentTurn ?? this.currentTurn,
      whiteCanCastleKingside:
          whiteCanCastleKingside ?? this.whiteCanCastleKingside,
      whiteCanCastleQueenside:
          whiteCanCastleQueenside ?? this.whiteCanCastleQueenside,
      blackCanCastleKingside:
          blackCanCastleKingside ?? this.blackCanCastleKingside,
      blackCanCastleQueenside:
          blackCanCastleQueenside ?? this.blackCanCastleQueenside,
      enPassantTargetRow: enPassantTargetRow ?? this.enPassantTargetRow,
      enPassantTargetCol: enPassantTargetCol ?? this.enPassantTargetCol,
      halfMoveClock: halfMoveClock ?? this.halfMoveClock,
      fullMoveNumber: fullMoveNumber ?? this.fullMoveNumber,
      moveHistory: moveHistory ?? this.moveHistory,
      positionHistory: positionHistory ?? this.positionHistory,
      status: status ?? this.status,
      winner: winner ?? this.winner,
      drawReason: drawReason ?? this.drawReason,
      lastMoveFromRow: lastMoveFromRow ?? this.lastMoveFromRow,
      lastMoveFromCol: lastMoveFromCol ?? this.lastMoveFromCol,
      lastMoveToRow: lastMoveToRow ?? this.lastMoveToRow,
      lastMoveToCol: lastMoveToCol ?? this.lastMoveToCol,
      isImported: isImported ?? this.isImported,
      capturedWhitePieces: capturedWhitePieces ?? this.capturedWhitePieces,
      capturedBlackPieces: capturedBlackPieces ?? this.capturedBlackPieces,
    );
  }

  ChessState undoLastMove() {
    if (moveHistory.isEmpty) return this;

    if (isImported) {
      final original = ChessState.fromFen(
          '${toFen().split(' ').sublist(0, 4).join(' ')} 0 1');
      return original;
    }

    return ChessState.initial();
  }

  Map<String, dynamic> toJson() => {
        'fen': toFen(),
        'moveHistory': moveHistory.map((m) => m.uci).toList(),
        'positionHistory': positionHistory,
        'status': status.name,
        'winner': winner?.name,
        'drawReason': drawReason?.name,
        'isImported': isImported,
        'capturedWhite':
            capturedWhitePieces.map((p) => p.toJson()).toList(),
        'capturedBlack':
            capturedBlackPieces.map((p) => p.toJson()).toList(),
      };

  factory ChessState.fromJson(Map<String, dynamic> json) {
    final fen = json['fen'] as String;
    var state = ChessState.fromFen(fen);

    final moveHistoryUci = (json['moveHistory'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [];
    final moves = moveHistoryUci.map((u) => ChessMove.fromUci(u)).toList();

    final posHistory = (json['positionHistory'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [];

    final statusStr = json['status'] as String?;
    final status = statusStr != null
        ? GameStatus.values.byName(statusStr)
        : GameStatus.playing;

    final winnerStr = json['winner'] as String?;
    final winner =
        winnerStr != null ? PieceColor.values.byName(winnerStr) : null;

    final drawStr = json['drawReason'] as String?;
    final drawReason = drawStr != null
        ? DrawReason.values.byName(drawStr)
        : null;

    final capturedWhite = (json['capturedWhite'] as List<dynamic>?)
            ?.map((e) => ChessPiece.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final capturedBlack = (json['capturedBlack'] as List<dynamic>?)
            ?.map((e) => ChessPiece.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return ChessState(
      board: state.board,
      currentTurn: state.currentTurn,
      whiteCanCastleKingside: state.whiteCanCastleKingside,
      whiteCanCastleQueenside: state.whiteCanCastleQueenside,
      blackCanCastleKingside: state.blackCanCastleKingside,
      blackCanCastleQueenside: state.blackCanCastleQueenside,
      enPassantTargetRow: state.enPassantTargetRow,
      enPassantTargetCol: state.enPassantTargetCol,
      halfMoveClock: state.halfMoveClock,
      fullMoveNumber: state.fullMoveNumber,
      moveHistory: moves,
      positionHistory: posHistory,
      status: status,
      winner: winner,
      drawReason: drawReason,
      isImported: json['isImported'] as bool? ?? false,
      capturedWhitePieces: capturedWhite,
      capturedBlackPieces: capturedBlack,
    );
  }
}
