import 'dart:async';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'fishing_config.dart';
import 'models/fishing_state.dart';

part 'fishing_provider.g.dart';

final _random = Random();

@Riverpod(keepAlive: true)
class FishingGame extends _$FishingGame {
  Timer? _waitTimer;
  Timer? _biteTimer;

  @override
  FishingState build() {
    ref.onDispose(() {
      _waitTimer?.cancel();
      _biteTimer?.cancel();
    });
    return FishingState.initial();
  }

  void startGame() {
    state = FishingState.initial().copyWith(status: FishingStatus.idle);
  }

  void throwRod() {
    if (!state.canThrow) return;
    _waitTimer?.cancel();
    _biteTimer?.cancel();

    state = state.copyWith(status: FishingStatus.waiting);
    _scheduleBite();
  }

  void _scheduleBite() {
    final waitSeconds = FishingConfig.waitMinSeconds +
        _random.nextDouble() * (FishingConfig.waitMaxSeconds - FishingConfig.waitMinSeconds);

    _waitTimer = Timer(Duration(milliseconds: (waitSeconds * 1000).toInt()), () {
      _onBite();
    });
  }

  void _onBite() {
    if (state.status != FishingStatus.waiting) return;
    final fishType = FishConfig.randomType();
    state = state.copyWith(
      status: FishingStatus.biting,
      biteTimeLeft: FishingConfig.biteWindowSeconds,
      fishType: fishType,
    );
    _startBiteCountdown();
  }

  void _startBiteCountdown() {
    _biteTimer?.cancel();
    const tickInterval = Duration(milliseconds: 50);

    _biteTimer = Timer.periodic(tickInterval, (timer) {
      if (state.status != FishingStatus.biting) {
        timer.cancel();
        return;
      }

      final newTimeLeft = state.biteTimeLeft - 0.05;
      if (newTimeLeft <= 0) {
        timer.cancel();
        _onBiteMissed();
      } else {
        state = state.copyWith(biteTimeLeft: newTimeLeft);
      }
    });
  }

  void _onBiteMissed() {
    if (state.status != FishingStatus.biting) return;
    state = state.copyWith(
      status: FishingStatus.failed,
      fishEscaped: state.fishEscaped + 1,
    );
  }

  void onBiteClick() {
    if (state.status == FishingStatus.biting) {
      _biteTimer?.cancel();
      _startMiniGame();
    }
  }

  void _startMiniGame() {
    final fishType = state.fishType;
    final fishConfig = FishConfig.getConfig(fishType);
    final initialY = 0.3 + _random.nextDouble() * 0.4;
    final stayDuration = fishConfig.stayDuration * (0.8 + _random.nextDouble() * 0.4);

    state = state.copyWith(
      status: FishingStatus.miniGame,
      progress: 0.0,
      miniGameTimeLeft: FishingConfig.miniGameDurationSeconds,
      fishY: initialY,
      fishMovementState: FishMovementState.staying,
      fishMoveProgress: 0.0,
      fishStayTimer: stayDuration,
      powerBlockY: 0.8,
      targetY: initialY,
    );
  }

  void updateMiniGame(double dt) {
    if (state.status != FishingStatus.miniGame) return;

    _updateFish(dt);
    _updateProgress(dt);
    _checkMiniGameEnd(dt);
  }

  void _updateFish(double dt) {
    final fishConfig = state.fishConfig;
    var y = state.fishY;
    final movementState = state.fishMovementState;
    var moveProgress = state.fishMoveProgress;
    var stayTimer = state.fishStayTimer;
    final targetY = state.targetY;

    if (movementState == FishMovementState.staying) {
      stayTimer -= dt;
      if (stayTimer <= 0) {
        final newTargetY = 0.15 + _random.nextDouble() * 0.7;
        state = state.copyWith(
          targetY: newTargetY,
          fishMovementState: FishMovementState.moving,
          fishMoveProgress: 0.0,
          fishY: y,
          fishStayTimer: 0,
        );
        return;
      }
      state = state.copyWith(fishStayTimer: stayTimer);
    } else {
      moveProgress += dt / fishConfig.moveTime;
      if (moveProgress >= 1.0) {
        y = targetY;
        stayTimer = fishConfig.stayDuration * (0.8 + _random.nextDouble() * 0.4);
        state = state.copyWith(
          fishY: y,
          fishMovementState: FishMovementState.staying,
          fishMoveProgress: 0.0,
          fishStayTimer: stayTimer,
        );
      } else {
        final prevY = state.fishY;
        y = prevY + (targetY - prevY) * 0.15;
        y = y.clamp(0.1, 0.9);
        state = state.copyWith(
          fishY: y,
          fishMoveProgress: moveProgress,
        );
      }
    }
  }

  void _updateProgress(double dt) {
    final fishY = state.fishY;
    final blockY = state.powerBlockY;

    final bool isAligned = (blockY - fishY).abs() < 0.12;

    double progressDelta;
    if (isAligned) {
      progressDelta = FishingConfig.progressPerSecond * dt;
    } else {
      progressDelta = -FishingConfig.decayPerSecond * dt;
    }

    final newProgress = (state.progress + progressDelta).clamp(0.0, FishingConfig.progressFullThreshold);
    state = state.copyWith(progress: newProgress);
  }

  void _checkMiniGameEnd(double dt) {
    final newTimeLeft = state.miniGameTimeLeft - dt;

    if (state.progress >= FishingConfig.progressFullThreshold) {
      _endMiniGame(success: true);
    } else if (newTimeLeft <= 0) {
      _endMiniGame(success: false);
    } else {
      state = state.copyWith(miniGameTimeLeft: newTimeLeft);
    }
  }

  void _endMiniGame({required bool success}) {
    if (success) {
      state = state.copyWith(
        status: FishingStatus.success,
        fishCaught: state.fishCaught + 1,
      );
    } else {
      state = state.copyWith(
        status: FishingStatus.failed,
        fishEscaped: state.fishEscaped + 1,
      );
    }
  }

  void setPowerBlockY(double y) {
    if (state.status != FishingStatus.miniGame) return;
    state = state.copyWith(powerBlockY: y);
  }

  void reset() {
    _waitTimer?.cancel();
    _biteTimer?.cancel();
    state = FishingState.initial();
  }
}