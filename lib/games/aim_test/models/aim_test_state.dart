/// Preset colors for bubbles.
enum BubbleColor {
  random, // Special value: random color each spawn
  bubbleGumPink,
  skyBlue,
  mintGreen,
  lavender,
  peach,
  coral,
  turquoise,
  lemonYellow,
}

/// The game status for the Aim Test game.
enum AimTestStatus {
  idle,
  countdown,
  playing,
  completed,
}

/// Configuration for bubble appearance.
class BubbleConfig {
  final double minSize;
  final double maxSize;
  final BubbleColor selectedColor; // Single color selection (random = cycle all colors)
  final double deadZonePercentage;
  final int gameDurationSeconds;
  final bool enableAppearAnimation; // Whether to animate bubble appearance

  const BubbleConfig({
    this.minSize = 50.0,
    this.maxSize = 80.0,
    this.selectedColor = BubbleColor.random,
    this.deadZonePercentage = 0.2,
    this.gameDurationSeconds = 30,
    this.enableAppearAnimation = false, // Default: animation disabled
  });

  /// Get all non-random colors for cycling when random is selected
  static const List<BubbleColor> allColors = [
    BubbleColor.bubbleGumPink,
    BubbleColor.skyBlue,
    BubbleColor.mintGreen,
    BubbleColor.lavender,
    BubbleColor.peach,
    BubbleColor.coral,
    BubbleColor.turquoise,
    BubbleColor.lemonYellow,
  ];

  BubbleConfig copyWith({
    double? minSize,
    double? maxSize,
    BubbleColor? selectedColor,
    double? deadZonePercentage,
    int? gameDurationSeconds,
    bool? enableAppearAnimation,
  }) {
    return BubbleConfig(
      minSize: minSize ?? this.minSize,
      maxSize: maxSize ?? this.maxSize,
      selectedColor: selectedColor ?? this.selectedColor,
      deadZonePercentage: deadZonePercentage ?? this.deadZonePercentage,
      gameDurationSeconds: gameDurationSeconds ?? this.gameDurationSeconds,
      enableAppearAnimation: enableAppearAnimation ?? this.enableAppearAnimation,
    );
  }

  Map<String, dynamic> toJson() => {
        'minSize': minSize,
        'maxSize': maxSize,
        'selectedColor': selectedColor.name,
        'deadZonePercentage': deadZonePercentage,
        'gameDurationSeconds': gameDurationSeconds,
        'enableAppearAnimation': enableAppearAnimation,
      };

  factory BubbleConfig.fromJson(Map<String, dynamic> json) {
    return BubbleConfig(
      minSize: (json['minSize'] as num).toDouble(),
      maxSize: (json['maxSize'] as num).toDouble(),
      selectedColor: BubbleColor.values.byName(json['selectedColor'] as String),
      deadZonePercentage: (json['deadZonePercentage'] as num).toDouble(),
      gameDurationSeconds: json['gameDurationSeconds'] as int? ?? 30,
      enableAppearAnimation: json['enableAppearAnimation'] as bool? ?? false,
    );
  }
}

/// Represents the complete state of an Aim Test game.
class AimTestState {
  final AimTestStatus status;
  final int score;
  final int missedCount; // Clicks that didn't hit the bubble
  final int timeRemainingSeconds;
  final BubbleConfig bubbleConfig;
  final double? currentBubbleX;
  final double? currentBubbleY;
  final int bubblesSpawned;
  final int bestScore;
  final int countdownValue; // 3, 2, 1, 0 (0 means "GO!")

  const AimTestState({
    required this.status,
    required this.score,
    this.missedCount = 0,
    required this.timeRemainingSeconds,
    required this.bubbleConfig,
    this.currentBubbleX,
    this.currentBubbleY,
    required this.bubblesSpawned,
    required this.bestScore,
    this.countdownValue = 3,
  });

  /// Creates the initial state for a new game.
  factory AimTestState.initial({BubbleConfig? config}) {
    return AimTestState(
      status: AimTestStatus.idle,
      score: 0,
      missedCount: 0,
      timeRemainingSeconds: config?.gameDurationSeconds ?? 30,
      bubbleConfig: config ?? const BubbleConfig(),
      currentBubbleX: null,
      currentBubbleY: null,
      bubblesSpawned: 0,
      bestScore: 0,
      countdownValue: 3,
    );
  }

  /// Returns the countdown display text.
  String get countdownDisplay {
    if (countdownValue == 0) return 'GO!';
    return countdownValue.toString();
  }

  /// Returns the current accuracy (hits / bubbles spawned).
  double get accuracy {
    if (bubblesSpawned == 0) return 0.0;
    return score / bubblesSpawned;
  }

  /// Returns whether there is an active bubble on screen.
  bool get hasActiveBubble =>
      currentBubbleX != null && currentBubbleY != null;

  /// Creates a copy of this state with the given fields replaced.
  AimTestState copyWith({
    AimTestStatus? status,
    int? score,
    int? missedCount,
    int? timeRemainingSeconds,
    BubbleConfig? bubbleConfig,
    double? currentBubbleX,
    double? currentBubbleY,
    int? bubblesSpawned,
    int? bestScore,
    int? countdownValue,
    bool clearBubble = false,
  }) {
    return AimTestState(
      status: status ?? this.status,
      score: score ?? this.score,
      missedCount: missedCount ?? this.missedCount,
      timeRemainingSeconds: timeRemainingSeconds ?? this.timeRemainingSeconds,
      bubbleConfig: bubbleConfig ?? this.bubbleConfig,
      currentBubbleX: clearBubble ? null : (currentBubbleX ?? this.currentBubbleX),
      currentBubbleY: clearBubble ? null : (currentBubbleY ?? this.currentBubbleY),
      bubblesSpawned: bubblesSpawned ?? this.bubblesSpawned,
      bestScore: bestScore ?? this.bestScore,
      countdownValue: countdownValue ?? this.countdownValue,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AimTestState) return false;

    return status == other.status &&
        score == other.score &&
        missedCount == other.missedCount &&
        timeRemainingSeconds == other.timeRemainingSeconds &&
        bubbleConfig == other.bubbleConfig &&
        currentBubbleX == other.currentBubbleX &&
        currentBubbleY == other.currentBubbleY &&
        bubblesSpawned == other.bubblesSpawned &&
        bestScore == other.bestScore &&
        countdownValue == other.countdownValue;
  }

  @override
  int get hashCode => Object.hash(
        status,
        score,
        missedCount,
        timeRemainingSeconds,
        bubbleConfig,
        currentBubbleX,
        currentBubbleY,
        bubblesSpawned,
        bestScore,
        countdownValue,
      );

  /// Serializes this state to JSON for saving.
  Map<String, dynamic> toJson() => {
        'status': status.name,
        'score': score,
        'missedCount': missedCount,
        'timeRemainingSeconds': timeRemainingSeconds,
        'bubbleConfig': bubbleConfig.toJson(),
        'currentBubbleX': currentBubbleX,
        'currentBubbleY': currentBubbleY,
        'bubblesSpawned': bubblesSpawned,
        'bestScore': bestScore,
        'countdownValue': countdownValue,
      };

  /// Deserializes a state from JSON.
  factory AimTestState.fromJson(Map<String, dynamic> json) {
    return AimTestState(
      status: AimTestStatus.values.byName(json['status'] as String),
      score: json['score'] as int,
      missedCount: json['missedCount'] as int? ?? 0,
      timeRemainingSeconds: json['timeRemainingSeconds'] as int,
      bubbleConfig:
          BubbleConfig.fromJson(json['bubbleConfig'] as Map<String, dynamic>),
      currentBubbleX: json['currentBubbleX'] as double?,
      currentBubbleY: json['currentBubbleY'] as double?,
      bubblesSpawned: json['bubblesSpawned'] as int,
      bestScore: json['bestScore'] as int,
      countdownValue: json['countdownValue'] as int? ?? 3,
    );
  }

  @override
  String toString() =>
      'AimTestState(score: $score, status: $status, time: $timeRemainingSeconds, accuracy: ${(accuracy * 100).toStringAsFixed(1)}%)';
}