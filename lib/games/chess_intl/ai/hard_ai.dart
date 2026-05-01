import '../models/chess_move.dart';
import '../models/chess_piece.dart';
import '../models/chess_state.dart';
import '../models/enums.dart';
import 'chess_ai.dart';

class HardChessAi extends ChessAi {
  static const int _maxDepth = 5;
  static const int _timeBudgetMs = 1800;

  int _nodesSearched = 0;
  ChessMove? _bestMoveFound;
  bool _cancelled = false;

  static const _pawnTable = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [50, 50, 50, 50, 50, 50, 50, 50],
    [10, 10, 20, 30, 30, 20, 10, 10],
    [5, 5, 10, 25, 25, 10, 5, 5],
    [0, 0, 0, 20, 20, 0, 0, 0],
    [5, -5, -10, 0, 0, -10, -5, 5],
    [5, 10, 10, -20, -20, 10, 10, 5],
    [0, 0, 0, 0, 0, 0, 0, 0],
  ];

  static const _knightTable = [
    [-50, -40, -30, -30, -30, -30, -40, -50],
    [-40, -20, 0, 0, 0, 0, -20, -40],
    [-30, 0, 10, 15, 15, 10, 0, -30],
    [-30, 5, 15, 20, 20, 15, 5, -30],
    [-30, 0, 15, 20, 20, 15, 0, -30],
    [-30, 5, 10, 15, 15, 10, 5, -30],
    [-40, -20, 0, 5, 5, 0, -20, -40],
    [-50, -40, -30, -30, -30, -30, -40, -50],
  ];

  static const _bishopTable = [
    [-20, -10, -10, -10, -10, -10, -10, -20],
    [-10, 0, 0, 0, 0, 0, 0, -10],
    [-10, 0, 10, 10, 10, 10, 0, -10],
    [-10, 5, 5, 10, 10, 5, 5, -10],
    [-10, 0, 10, 10, 10, 10, 0, -10],
    [-10, 10, 10, 10, 10, 10, 10, -10],
    [-10, 5, 0, 0, 0, 0, 5, -10],
    [-20, -10, -10, -10, -10, -10, -10, -20],
  ];

  static const _rookTable = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [5, 10, 10, 10, 10, 10, 10, 5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [-5, 0, 0, 0, 0, 0, 0, -5],
    [0, 0, 0, 5, 5, 0, 0, 0],
  ];

  static const _queenTable = [
    [-20, -10, -10, -5, -5, -10, -10, -20],
    [-10, 0, 0, 0, 0, 0, 0, -10],
    [-10, 0, 5, 5, 5, 5, 0, -10],
    [-5, 0, 5, 5, 5, 5, 0, -5],
    [0, 0, 5, 5, 5, 5, 0, -5],
    [-10, 5, 5, 5, 5, 5, 0, -10],
    [-10, 0, 5, 0, 0, 0, 0, -10],
    [-20, -10, -10, -5, -5, -10, -10, -20],
  ];

  static const _kingMiddleTable = [
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-30, -40, -40, -50, -50, -40, -40, -30],
    [-20, -30, -30, -40, -40, -30, -30, -20],
    [-10, -20, -20, -20, -20, -20, -20, -10],
    [20, 20, 0, 0, 0, 0, 20, 20],
    [20, 30, 10, 0, 0, 10, 30, 20],
  ];

  static const _kingEndTable = [
    [-50, -40, -30, -20, -20, -30, -40, -50],
    [-30, -20, -10, 0, 0, -10, -20, -30],
    [-30, -10, 20, 30, 30, 20, -10, -30],
    [-30, -10, 30, 40, 40, 30, -10, -30],
    [-30, -10, 30, 40, 40, 30, -10, -30],
    [-30, -10, 20, 30, 30, 20, -10, -30],
    [-30, -30, 0, 0, 0, 0, -30, -30],
    [-50, -30, -30, -30, -30, -30, -30, -50],
  ];

  @override
  Future<ChessMove?> findBestMove(
    ChessState state, {
    Duration? timeLimit,
    bool Function()? isCancelled,
  }) async {
    _nodesSearched = 0;
    _bestMoveFound = null;
    _cancelled = false;

    final effectiveTimeLimit =
        timeLimit ?? const Duration(milliseconds: _timeBudgetMs);
    final deadline = DateTime.now().add(effectiveTimeLimit);

    final moves = state.allLegalMoves;
    if (moves.isEmpty) return null;

    if (moves.length == 1) return moves.first;

    final orderedMoves = _orderMoves(state, moves);

    _bestMoveFound = orderedMoves.first;

    for (int depth = 1; depth <= _maxDepth; depth++) {
      if (_cancelled) break;
      if (DateTime.now().isAfter(deadline)) break;

      int bestScore = -999999;
      ChessMove? bestMove;

      for (final move in orderedMoves) {
        if (_cancelled || DateTime.now().isAfter(deadline)) break;

        final newState = state.applyMove(move);
        final score = -_alphaBeta(
          newState,
          depth - 1,
          -999999,
          -bestScore,
          deadline,
        );

        if (_cancelled) break;

        if (score > bestScore) {
          bestScore = score;
          bestMove = move;
        }
      }

      if (!_cancelled && bestMove != null) {
        _bestMoveFound = bestMove;
      }
    }

    return _bestMoveFound;
  }

  int _alphaBeta(
    ChessState state,
    int depth,
    int alpha,
    int beta,
    DateTime deadline,
  ) {
    _nodesSearched++;

    if (_cancelled || DateTime.now().isAfter(deadline)) {
      _cancelled = true;
      return 0;
    }

    final moves = state.allLegalMoves;

    if (moves.isEmpty) {
      if (state.isCheck) {
        return -99999 - depth;
      }
      return 0;
    }

    if (depth <= 0) {
      return _quiescence(state, alpha, beta, 4, deadline);
    }

    final orderedMoves = _orderMoves(state, moves);

    for (final move in orderedMoves) {
      if (_cancelled) break;

      final newState = state.applyMove(move);
      final score = -_alphaBeta(newState, depth - 1, -beta, -alpha, deadline);

      if (score >= beta) {
        return beta;
      }
      if (score > alpha) {
        alpha = score;
      }
    }

    return alpha;
  }

  int _quiescence(
    ChessState state,
    int alpha,
    int beta,
    int depth,
    DateTime deadline,
  ) {
    _nodesSearched++;

    if (_cancelled || DateTime.now().isAfter(deadline)) {
      _cancelled = true;
      return 0;
    }

    final standPat = _evaluate(state);

    if (depth <= 0) return standPat;

    if (standPat >= beta) return beta;
    if (standPat > alpha) alpha = standPat;

    final moves = state.allLegalMoves;
    final captureMoves = moves.where((m) {
      final target = state.pieceAt(m.toRow, m.toCol);
      return target != null || m.isEnPassant || m.promotionPiece != null;
    }).toList();

    final ordered = _orderMoves(state, captureMoves);

    for (final move in ordered) {
      if (_cancelled) break;

      final newState = state.applyMove(move);
      final score =
          -_quiescence(newState, -beta, -alpha, depth - 1, deadline);

      if (score >= beta) return beta;
      if (score > alpha) alpha = score;
    }

    return alpha;
  }

  int _evaluate(ChessState state) {
    int score = 0;
    int totalMaterial = 0;

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final piece = state.board[r][c];
        if (piece == null) continue;

        int pieceScore = piece.type.baseValue;
        pieceScore += _getPieceSquareBonus(piece, r, c, totalMaterial);

        if (piece.color == PieceColor.white) {
          score += pieceScore;
        } else {
          score -= pieceScore;
        }

        if (piece.type != PieceType.king) {
          totalMaterial += piece.type.baseValue;
        }
      }
    }

    final mobility = state.allLegalMoves.length;
    final isWhiteTurn = state.currentTurn == PieceColor.white;
    if (isWhiteTurn) {
      score += mobility * 2;
    } else {
      score -= mobility * 2;
    }

    if (state.isCheck) {
      if (isWhiteTurn) {
        score -= 30;
      } else {
        score += 30;
      }
    }

    score += _evaluatePawnStructure(state);

    return isWhiteTurn ? score : -score;
  }

  int _getPieceSquareBonus(
      ChessPiece piece, int row, int col, int totalMaterial) {
    final isEndgame = totalMaterial < 2600;
    final r = piece.color == PieceColor.white ? row : 7 - row;

    int bonus;
    switch (piece.type) {
      case PieceType.pawn:
        bonus = _pawnTable[r][col];
        break;
      case PieceType.knight:
        bonus = _knightTable[r][col];
        break;
      case PieceType.bishop:
        bonus = _bishopTable[r][col];
        break;
      case PieceType.rook:
        bonus = _rookTable[r][col];
        break;
      case PieceType.queen:
        bonus = _queenTable[r][col];
        break;
      case PieceType.king:
        bonus = isEndgame
            ? _kingEndTable[r][col]
            : _kingMiddleTable[r][col];
        break;
    }

    return bonus;
  }

  int _evaluatePawnStructure(ChessState state) {
    int score = 0;

    for (int c = 0; c < 8; c++) {
      int whitePawns = 0;
      int blackPawns = 0;
      for (int r = 0; r < 8; r++) {
        final p = state.board[r][c];
        if (p != null && p.type == PieceType.pawn) {
          if (p.color == PieceColor.white) {
            whitePawns++;
          } else {
            blackPawns++;
          }
        }
      }

      if (whitePawns > 1) score -= 15 * (whitePawns - 1);
      if (blackPawns > 1) score += 15 * (blackPawns - 1);
    }

    return score;
  }

  List<ChessMove> _orderMoves(ChessState state, List<ChessMove> moves) {
    final scored = moves.map((move) {
      int score = 0;

      final captured = state.pieceAt(move.toRow, move.toCol);
      if (captured != null) {
        final attacker = state.pieceAt(move.fromRow, move.fromCol);
        if (attacker != null) {
          score += captured.type.baseValue * 10 - attacker.type.baseValue;
        }
      }

      if (move.isEnPassant) score += 1000;
      if (move.promotionPiece != null) {
        score += move.promotionPiece!.baseValue * 10;
      }

      if (move.isCastling) score += 500;

      return (move, score);
    }).toList();

    scored.sort((a, b) => b.$2.compareTo(a.$2));
    return scored.map((e) => e.$1).toList();
  }
}
