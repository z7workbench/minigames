import 'dart:async';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/database.dart';
import '../../data/providers/database_provider.dart';
import 'models/connect_four_state.dart';
import 'models/enums.dart';
import 'logic/connect_four_rules.dart';
import 'ai/connect_four_ai.dart';
import 'ai/easy_ai.dart';
import 'ai/medium_ai.dart';
import 'ai/hard_ai.dart';

part 'connect_four_provider.g.dart';

@riverpod
class ConnectFourGame extends _$ConnectFourGame {
  ConnectFourAi? _ai;
  bool _aiThinking = false;

  @override
  ConnectFourState build() {
    ref.onDispose(() {
      _aiThinking = false;
    });
    return ConnectFourState.initial();
  }

  void startGame({
    required AiDifficulty difficulty,
  }) {
    _aiThinking = false;

    switch (difficulty) {
      case AiDifficulty.easy:
        _ai = EasyConnectFourAi();
        break;
      case AiDifficulty.medium:
        _ai = MediumConnectFourAi();
        break;
      case AiDifficulty.hard:
        _ai = HardConnectFourAi();
        break;
    }

    state = ConnectFourState.initial(difficulty: difficulty);
    state = state.copyWith(phase: GamePhase.playing);
    _saveDifficulty(difficulty);
  }

  void dropPiece(int col) {
    if (_aiThinking) return;
    if (state.phase != GamePhase.playing) return;
    if (state.currentTurn != CellState.player) return;
    if (!ConnectFourRules.isValidMove(state, col)) return;

    state = ConnectFourRules.applyMove(state, col);
    state = ConnectFourRules.checkGameResult(state);

    if (state.phase == GamePhase.gameOver) {
      _saveGameRecord();
      return;
    }

    if (_shouldAiMove()) {
      _scheduleAiMove();
    }
  }

  bool _shouldAiMove() {
    return state.currentTurn == CellState.ai &&
        _ai != null &&
        state.phase == GamePhase.playing;
  }

  void _scheduleAiMove() {
    if (_ai == null) return;
    _aiThinking = true;

    Future.delayed(Duration(milliseconds: _ai!.getRandomDelay()), () async {
      if (state.phase == GamePhase.gameOver) {
        _aiThinking = false;
        return;
      }

      final col = await _ai!.findBestMove(state);

      if (col != null &&
          state.phase != GamePhase.gameOver &&
          ConnectFourRules.isValidMove(state, col)) {
        state = ConnectFourRules.applyMove(state, col);
        state = ConnectFourRules.checkGameResult(state);

        if (state.phase == GamePhase.gameOver) {
          _saveGameRecord();
          _aiThinking = false;
          return;
        }
      }

      _aiThinking = false;
    });
  }

  void undoMove() {
    if (_aiThinking) return;
    if (!state.canUndo) return;

    final history = List<int>.from(state.moveHistory);
    if (history.length < 2) return;

    history.removeLast();
    history.removeLast();

    var newState = ConnectFourState.initial(difficulty: state.difficulty);
    newState = newState.copyWith(phase: GamePhase.playing);

    CellState turn = CellState.player;
    for (final col in history) {
      final row = newState.getDropRow(col);
      final newBoard =
          newState.board.map((r) => List<CellState>.from(r)).toList();
      newBoard[row][col] = turn;
      final newColHeight = List<int>.from(newState.colHeight);
      newColHeight[col]++;

      newState = newState.copyWith(
        board: newBoard,
        colHeight: newColHeight,
        moveCount: newState.moveCount + 1,
        moveHistory: [...newState.moveHistory, col],
        lastMoveRow: row,
        lastMoveCol: col,
        currentTurn: turn.opposite,
      );
      turn = turn.opposite;
    }

    state = newState;
  }

  void resetGame() {
    _aiThinking = false;
    startGame(difficulty: state.difficulty);
  }

  bool get isAiThinking => _aiThinking;

  Future<void> _saveGameRecord() async {
    final dao = ref.read(gameRecordsDaoProvider);
    final isWin = state.result == GameResult.playerWin;
    final isDraw = state.result == GameResult.draw;

    await dao.insertRecord(
      GameRecordsCompanion.insert(
        gameType: 'connect_four',
        score: Value(isWin ? 1 : (isDraw ? 0 : -1)),
      ),
    );
  }

  Future<void> _saveDifficulty(AiDifficulty difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('connect_four_difficulty', difficulty.index);
  }

  Future<AiDifficulty> loadDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    final idx = prefs.getInt('connect_four_difficulty');
    if (idx != null && idx < AiDifficulty.values.length) {
      return AiDifficulty.values[idx];
    }
    return AiDifficulty.easy;
  }
}
