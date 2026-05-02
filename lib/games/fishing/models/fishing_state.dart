import 'package:flutter/material.dart';
import '../fishing_config.dart';

enum FishingStatus {
  idle,
  waiting,
  biting,
  miniGame,
  success,
  failed,
}

enum FishMovementState {
  staying,
  moving,
}

class FishingState {
  final FishingStatus status;
  final FishType fishType;
  final double fishY;
  final FishMovementState fishMovementState;
  final double fishMoveProgress;
  final double fishStayTimer;
  final double powerBlockY;
  final double progress;
  final double miniGameTimeLeft;
  final double biteTimeLeft;
  final int fishCaught;
  final int fishEscaped;
  final double targetY;

  const FishingState({
    this.status = FishingStatus.idle,
    this.fishType = FishType.easy,
    this.fishY = 0.5,
    this.fishMovementState = FishMovementState.staying,
    this.fishMoveProgress = 0.0,
    this.fishStayTimer = 0.0,
    this.powerBlockY = 0.5,
    this.progress = 0.0,
    this.miniGameTimeLeft = 0.0,
    this.biteTimeLeft = 0.0,
    this.fishCaught = 0,
    this.fishEscaped = 0,
    this.targetY = 0.5,
  });

  factory FishingState.initial() => const FishingState();

  bool get isSuccess => status == FishingStatus.success;
  bool get isFailed => status == FishingStatus.failed;
  bool get isPlaying => status == FishingStatus.waiting || status == FishingStatus.biting || status == FishingStatus.miniGame;
  bool get canThrow => status == FishingStatus.idle || status == FishingStatus.success || status == FishingStatus.failed;

  double get progressPercent => (progress / 100.0).clamp(0.0, 1.0);
  double get timePercent => miniGameTimeLeft / FishingConfig.miniGameDurationSeconds;

  FishConfig get fishConfig => FishConfig.getConfig(fishType);

  Color get statusColor {
    switch (status) {
      case FishingStatus.idle:
        return Colors.grey;
      case FishingStatus.waiting:
        return Colors.blue;
      case FishingStatus.biting:
        return Colors.orange;
      case FishingStatus.miniGame:
        return fishConfig.color;
      case FishingStatus.success:
        return Colors.green;
      case FishingStatus.failed:
        return Colors.red;
    }
  }

  FishingState copyWith({
    FishingStatus? status,
    FishType? fishType,
    double? fishY,
    FishMovementState? fishMovementState,
    double? fishMoveProgress,
    double? fishStayTimer,
    double? powerBlockY,
    double? progress,
    double? miniGameTimeLeft,
    double? biteTimeLeft,
    int? fishCaught,
    int? fishEscaped,
    double? targetY,
  }) {
    return FishingState(
      status: status ?? this.status,
      fishType: fishType ?? this.fishType,
      fishY: fishY ?? this.fishY,
      fishMovementState: fishMovementState ?? this.fishMovementState,
      fishMoveProgress: fishMoveProgress ?? this.fishMoveProgress,
      fishStayTimer: fishStayTimer ?? this.fishStayTimer,
      powerBlockY: powerBlockY ?? this.powerBlockY,
      progress: progress ?? this.progress,
      miniGameTimeLeft: miniGameTimeLeft ?? this.miniGameTimeLeft,
      biteTimeLeft: biteTimeLeft ?? this.biteTimeLeft,
      fishCaught: fishCaught ?? this.fishCaught,
      fishEscaped: fishEscaped ?? this.fishEscaped,
      targetY: targetY ?? this.targetY,
    );
  }

  @override
  String toString() {
    return 'FishingState(status: $status, fishType: $fishType, fishY: ${fishY.toStringAsFixed(2)}, '
        'powerBlockY: ${powerBlockY.toStringAsFixed(2)}, progress: ${progress.toStringAsFixed(1)}, '
        'miniGameTimeLeft: ${miniGameTimeLeft.toStringAsFixed(1)})';
  }
}

extension FishingStatusExtension on FishingStatus {
  bool get isIdle => this == FishingStatus.idle;
  bool get isWaiting => this == FishingStatus.waiting;
  bool get isBiting => this == FishingStatus.biting;
  bool get isMiniGame => this == FishingStatus.miniGame;
  bool get isSuccess => this == FishingStatus.success;
  bool get isFailed => this == FishingStatus.failed;
  bool get isFinished => this == FishingStatus.success || this == FishingStatus.failed;
}