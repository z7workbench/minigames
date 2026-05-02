import 'package:flutter/material.dart';

enum FishType {
  easy,
  medium,
  hard,
  wild,
  legendary,
}

class FishConfig {
  final double size;
  final double moveTime;
  final double stayDuration;
  final double randomFactor;
  final Color color;
  final String name;

  const FishConfig({
    required this.size,
    required this.moveTime,
    required this.stayDuration,
    required this.randomFactor,
    required this.color,
    required this.name,
  });

  static FishConfig getConfig(FishType type) {
    switch (type) {
      case FishType.easy:
        return FishConfig(
          size: 8,
          moveTime: 0.3,
          stayDuration: 2.5,
          randomFactor: 0.2,
          color: Color(0xFF8BC34A),
          name: 'Easy Fish',
        );
      case FishType.medium:
        return FishConfig(
          size: 8,
          moveTime: 0.25,
          stayDuration: 2.0,
          randomFactor: 0.35,
          color: Color(0xFF4CAF50),
          name: 'Medium Fish',
        );
      case FishType.hard:
        return FishConfig(
          size: 8,
          moveTime: 0.2,
          stayDuration: 1.5,
          randomFactor: 0.5,
          color: Color(0xFFFF9800),
          name: 'Hard Fish',
        );
      case FishType.wild:
        return FishConfig(
          size: 8,
          moveTime: 0.15,
          stayDuration: 1.0,
          randomFactor: 0.65,
          color: Color(0xFFFF5722),
          name: 'Wild Fish',
        );
      case FishType.legendary:
        return FishConfig(
          size: 8,
          moveTime: 0.1,
          stayDuration: 0.7,
          randomFactor: 0.8,
          color: Color(0xFF9C27B0),
          name: 'Legendary Fish',
        );
    }
  }

  static FishType randomType() {
    final rand = DateTime.now().millisecondsSinceEpoch % 100;
    if (rand < 35) return FishType.easy;
    if (rand < 60) return FishType.medium;
    if (rand < 80) return FishType.hard;
    if (rand < 95) return FishType.wild;
    return FishType.legendary;
  }
}

class FishingConfig {
  static const double waitMinSeconds = 2.0;
  static const double waitMaxSeconds = 5.0;

  static const double biteWindowSeconds = 2.5;

  static const double powerBlockHeight = 0.18;

  static const double overlapThreshold = 0.3;

  static const double progressPerSecond = 18.0;
  static const double decayPerSecond = 4.0;
  static const double progressFullThreshold = 100.0;

  static const double miniGameDurationSeconds = 15.0;

  static const double targetFrameRate = 60.0;
  static const double logicUpdateFrequency = 1.0 / 60.0;

  static const double progressBarHeight = 20.0;
  static const double progressBarWidth = 0.8;

  static const double bobberShakeAmplitude = 6.0;
  static const Duration bobberShakeDuration = Duration(milliseconds: 80);

  static const double baitX = 0.5;
  static const double baitY = 0.25;
}

class FishingColors {
  static const Color waterSurface = Color(0xFF4FC3F7);
  static const Color waterDeep = Color(0xFF0277BD);
  static const Color waterSurfaceDark = Color(0xFF01579B);
  static const Color waterDeepDark = Color(0xFF0D47A1);

  static const Color bobberNormal = Color(0xFFFF5722);
  static const Color bobberBiting = Color(0xFFFFEB3B);

  static const Color progressBarBg = Color(0xFF455A64);
  static const Color progressBarFill = Color(0xFF4CAF50);
  static const Color progressBarDecay = Color(0xFFFF9800);

  static const Color successGreen = Color(0xFF4CAF50);
  static const Color failRed = Color(0xFFF44336);
  static const Color hintYellow = Color(0xFFFFEB3B);
}