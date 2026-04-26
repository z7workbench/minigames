import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database.dart';
import '../../data/providers/database_provider.dart';
import 'models/reaction_test_state.dart';

part 'reaction_test_provider.g.dart';

final _random = Random();

@Riverpod(keepAlive: true)
class ReactionTestGame extends _$ReactionTestGame {
  Timer? _waitTimer;
  static const _minWaitSeconds = 3;
  static const _maxWaitSeconds = 5;
  static const _totalTests = 5;

  @override
  ReactionTestState build() {
    ref.onDispose(() {
      _waitTimer?.cancel();
    });
    return ReactionTestState.initial();
  }

  void setColorPreset(int presetIndex) {
    if (presetIndex < 0 || presetIndex >= ReactionTestState.colorPresets.length) {
      return;
    }
    final preset = ReactionTestState.colorPresets[presetIndex];
    state = state.copyWith(
      selectedPresetIndex: presetIndex,
      beforeColor: preset.beforeColor,
      afterColor: preset.afterColor,
    );
  }

  void setCustomColors(Color before, Color after) {
    if (before == after) return;
    state = state.copyWith(
      selectedPresetIndex: 3,
      beforeColor: before,
      afterColor: after,
    );
  }

  void startGame() {
    _waitTimer?.cancel();

    state = state.copyWith(
      status: ReactionTestStatus.waiting,
      currentTestNumber: 1,
      reactionTimes: const [],
      averageReactionTime: 0,
      startTime: null,
      endTime: null,
    );

    _startWaitTimer();
  }

  void _startWaitTimer() {
    _waitTimer?.cancel();
    final waitSeconds = _minWaitSeconds + _random.nextInt(_maxWaitSeconds - _minWaitSeconds + 1);
    _waitTimer = Timer(Duration(seconds: waitSeconds), () {
      _onColorChanged();
    });
  }

  void _onColorChanged() {
    state = state.copyWith(
      status: ReactionTestStatus.colorChanged,
      startTime: DateTime.now().millisecondsSinceEpoch,
    );
  }

  void recordReaction() {
    if (state.status != ReactionTestStatus.colorChanged) {
      return;
    }

    final endTime = DateTime.now().millisecondsSinceEpoch;
    final startTime = state.startTime;

    if (startTime == null) {
      return;
    }

    final reactionTime = endTime - startTime;
    final newReactionTimes = [...state.reactionTimes, reactionTime];
    final newTestNumber = state.currentTestNumber + 1;

    if (newTestNumber > _totalTests) {
      final average = newReactionTimes.reduce((a, b) => a + b) ~/ newReactionTimes.length;
      state = state.copyWith(
        status: ReactionTestStatus.completed,
        reactionTimes: newReactionTimes,
        averageReactionTime: average,
        endTime: endTime,
      );
      _saveGameRecord(average);
    } else {
      state = state.copyWith(
        status: ReactionTestStatus.testing,
        currentTestNumber: newTestNumber,
        reactionTimes: newReactionTimes,
        endTime: endTime,
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        if (state.status == ReactionTestStatus.testing) {
          state = state.copyWith(
            status: ReactionTestStatus.waiting,
            startTime: null,
          );
          _startWaitTimer();
        }
      });
    }
  }

  void reset() {
    _waitTimer?.cancel();
    state = ReactionTestState.initial();
  }

  void _saveGameRecord(int averageReactionTime) {
    final dao = ref.read(gameRecordsDaoProvider);
    dao.insertRecord(
      GameRecordsCompanion.insert(
        gameType: 'reaction_test',
        score: Value(averageReactionTime),
      ),
    );
  }
}
