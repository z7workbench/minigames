import 'dart:async';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/providers/database_provider.dart';
import 'models/chess_move.dart';
import 'models/chess_state.dart';
import 'models/enums.dart';
import 'ai/chess_ai.dart';
import 'ai/easy_ai.dart';
import 'ai/hard_ai.dart';
import 'logic/pgn_exporter.dart';
import 'logic/san_converter.dart';

part 'chess_intl_provider.g.dart';

@riverpod
class ChessGame extends _$ChessGame {
  ChessAi? _ai;
  bool _aiThinking = false;
  Timer? _gameTimer;

  @override
  ChessState build() {
    ref.onDispose(() {
      _gameTimer?.cancel();
      _aiThinking = false;
    });
    return ChessState.initial();
  }

  void startGame({
    required AiDifficulty difficulty,
    required PieceColor playerColor,
    String? fen,
  }) {
    _gameTimer?.cancel();
    _aiThinking = false;

    _ai = difficulty == AiDifficulty.easy ? EasyChessAi() : HardChessAi();

    if (fen != null && fen.isNotEmpty) {
      state = ChessState.fromFen(fen);
      state = state.copyWith(isImported: true);
    } else {
      state = ChessState.initial();
    }

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.status == GameStatus.checkmate ||
          state.status == GameStatus.stalemate ||
          state.status == GameStatus.draw ||
          state.status == GameStatus.gameOver) {
        timer.cancel();
      }
    });

    if (_shouldAiMove()) {
      _scheduleAiMove();
    }
  }

  bool _shouldAiMove() {
    return state.currentTurn == PieceColor.black &&
        _ai != null &&
        state.status != GameStatus.checkmate &&
        state.status != GameStatus.stalemate &&
        state.status != GameStatus.draw &&
        state.status != GameStatus.gameOver;
  }

  void makeMove(ChessMove move) {
    if (_aiThinking) return;
    if (state.status == GameStatus.checkmate ||
        state.status == GameStatus.stalemate ||
        state.status == GameStatus.draw ||
        state.status == GameStatus.gameOver) return;

    final legalMoves = state.getLegalMovesForSquare(move.fromRow, move.fromCol);
    final matching = legalMoves.where((m) =>
        m.toRow == move.toRow &&
        m.toCol == move.toCol &&
        (move.promotionPiece == null || m.promotionPiece == move.promotionPiece));

    if (matching.isEmpty) return;

    final actualMove = matching.first;
    state = state.applyMove(actualMove);

    _checkGameEnd();

    if (_shouldAiMove()) {
      _scheduleAiMove();
    }
  }

  void makePromotionMove(ChessMove move, PieceType promotionPiece) {
    if (_aiThinking) return;

    final legalMoves = state.getLegalMovesForSquare(move.fromRow, move.fromCol);
    final matching = legalMoves.where((m) =>
        m.toRow == move.toRow &&
        m.toCol == move.toCol &&
        m.promotionPiece == promotionPiece);

    if (matching.isEmpty) return;

    state = state.applyMove(matching.first);
    _checkGameEnd();

    if (_shouldAiMove()) {
      _scheduleAiMove();
    }
  }

  void _scheduleAiMove() {
    if (_ai == null) return;
    _aiThinking = true;

    Future.delayed(Duration(milliseconds: _ai!.getRandomDelay()), () async {
      if (state.status == GameStatus.checkmate ||
          state.status == GameStatus.stalemate ||
          state.status == GameStatus.draw ||
          state.status == GameStatus.gameOver) {
        _aiThinking = false;
        return;
      }

      final move = await _ai!.findBestMove(state);

      if (move != null &&
          state.status != GameStatus.checkmate &&
          state.status != GameStatus.stalemate &&
          state.status != GameStatus.draw &&
          state.status != GameStatus.gameOver) {
        state = state.applyMove(move);
        _checkGameEnd();
      }

      _aiThinking = false;
    });
  }

  void _checkGameEnd() {
    if (state.status == GameStatus.checkmate ||
        state.status == GameStatus.stalemate ||
        state.status == GameStatus.draw) {
      _gameTimer?.cancel();
      _saveGameRecord();
      state = state.copyWith(status: GameStatus.gameOver);
    }
  }

  void undoMove() {
    if (_aiThinking) return;
    if (state.moveHistory.length < 2) return;

    final moves = List<ChessMove>.from(state.moveHistory);
    moves.removeLast();
    moves.removeLast();

    var newState = state.isImported
        ? ChessState.fromFen(state.positionHistory.isNotEmpty
            ? state.positionHistory.first
            : 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
        : ChessState.initial();

    for (final move in moves) {
      newState = newState.applyMove(move);
    }

    state = newState;
  }

  void resetGame() {
    _gameTimer?.cancel();
    _aiThinking = false;
    state = ChessState.initial();
  }

  String exportPgn({
    String? white,
    String? black,
  }) {
    return PgnExporter.exportPgn(
      state,
      white: white ?? 'Player',
      black: black ?? 'AI',
    );
  }

  String get currentFen => state.toFen();

  List<String> get moveHistorySan {
    if (state.moveHistory.isEmpty) return [];
    return SanConverter.moveToPgnMoves(state);
  }

  bool get isAiThinking => _aiThinking;

  List<ChessMove> getLegalMovesForSquare(int row, int col) {
    return state.getLegalMovesForSquare(row, col);
  }

  bool isLegalMoveTarget(int row, int col) {
    return state.allLegalMoves.any(
      (m) => m.toRow == row && m.toCol == col,
    );
  }

  Future<void> _saveGameRecord() async {
    final dao = ref.read(gameRecordsDaoProvider);

    final isWin = state.winner == PieceColor.white;
    final isDraw = state.status == GameStatus.draw ||
        state.status == GameStatus.stalemate;

    await dao.insertRecord(
      GameRecordsCompanion.insert(
        gameType: 'chess_intl',
        score: Value(isWin ? 1 : (isDraw ? 0 : -1)),
      ),
    );
  }
}
