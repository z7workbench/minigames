import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/providers/database_provider.dart';
import 'models/schulte_grid_state.dart';

part 'schulte_grid_provider.g.dart';

@Riverpod(keepAlive: true)
class SchulteGridGame extends _$SchulteGridGame {
  Timer? _timer;
  int _pauseAccumulatedMs = 0;
  int? _pauseStartMs;

  @override
  SchulteGridState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return SchulteGridState.initial();
  }

  void startGame(SchulteGridSize size) {
    _timer?.cancel();
    _pauseAccumulatedMs = 0;
    _pauseStartMs = null;

    final grid = SchulteGridState.generateGrid(size);
    state = SchulteGridState(
      gridSize: size,
      grid: grid,
      nextNumber: 1,
      elapsedMs: 0,
      status: SchulteGridStatus.idle,
      startTimeMs: null,
    );
  }

  void onTap(int row, int col) {
    if (state.status == SchulteGridStatus.completed) return;

    final tappedNumber = state.grid[row][col];

    if (tappedNumber != state.nextNumber) {
      HapticFeedback.lightImpact();
      state = state.copyWith(
        wrongTapRow: row,
        wrongTapCol: col,
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        if (state.wrongTapRow == row && state.wrongTapCol == col) {
          state = state.copyWith(
            wrongTapRow: null,
            wrongTapCol: null,
          );
        }
      });
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    if (state.status == SchulteGridStatus.idle) {
      state = state.copyWith(
        status: SchulteGridStatus.running,
        startTimeMs: now,
        nextNumber: state.nextNumber + 1,
        wrongTapRow: null,
        wrongTapCol: null,
      );
      _startTimer();
      return;
    }

    final newNext = state.nextNumber + 1;
    if (newNext > state.gridSize.total) {
      _timer?.cancel();
      final totalMs = state.elapsedMs;
      state = state.copyWith(
        nextNumber: newNext,
        status: SchulteGridStatus.completed,
        wrongTapRow: null,
        wrongTapCol: null,
      );
      _saveRecord(totalMs);
    } else {
      state = state.copyWith(
        nextNumber: newNext,
        wrongTapRow: null,
        wrongTapCol: null,
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (state.status != SchulteGridStatus.running) return;
      final now = DateTime.now().millisecondsSinceEpoch;
      final startMs = state.startTimeMs;
      if (startMs == null) return;
      state = state.copyWith(
        elapsedMs: now - startMs - _pauseAccumulatedMs,
      );
    });
  }

  void pauseTimer() {
    if (state.status != SchulteGridStatus.running) return;
    _pauseStartMs = DateTime.now().millisecondsSinceEpoch;
    _timer?.cancel();
    state = state.copyWith(status: SchulteGridStatus.paused);
  }

  void resumeTimer() {
    if (state.status != SchulteGridStatus.paused) return;
    if (_pauseStartMs != null) {
      _pauseAccumulatedMs +=
          DateTime.now().millisecondsSinceEpoch - _pauseStartMs!;
      _pauseStartMs = null;
    }
    state = state.copyWith(status: SchulteGridStatus.running);
    _startTimer();
  }

  Future<void> _saveRecord(int durationMs) async {
    final dao = ref.read(gameRecordsDaoProvider);

    final existing = await dao.getTopScoresByGameType(
      state.gridSize.gameTypeKey,
      limit: 10,
    );

    bool isNewBest = false;
    if (existing.isEmpty) {
      isNewBest = true;
    } else if (durationMs < existing.first.score) {
      isNewBest = true;
    }

    if (existing.length < 10 || durationMs < existing.last.score) {
      await dao.insertRecord(
        GameRecordsCompanion.insert(
          gameType: state.gridSize.gameTypeKey,
          score: Value(durationMs),
        ),
      );
    }

    state = state.copyWith(isNewBest: isNewBest);
  }

  void reset() {
    _timer?.cancel();
    _pauseAccumulatedMs = 0;
    _pauseStartMs = null;
    state = SchulteGridState.initial();
  }
}
