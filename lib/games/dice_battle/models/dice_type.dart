/// Dice types with different number of faces.
enum DiceType {
  d4, // 4 faces, values 1-4
  d6, // 6 faces, values 1-6
  d8, // 8 faces, values 1-8
  d12, // 12 faces, values 1-12
  d16, // 16 faces, values 1-16
}

extension DiceTypeExtension on DiceType {
  /// Number of faces for this dice type.
  int get faces {
    switch (this) {
      case DiceType.d4:
        return 4;
      case DiceType.d6:
        return 6;
      case DiceType.d8:
        return 8;
      case DiceType.d12:
        return 12;
      case DiceType.d16:
        return 16;
    }
  }

  /// Display name for the dice type.
  String get displayName {
    switch (this) {
      case DiceType.d4:
        return 'D4';
      case DiceType.d6:
        return 'D6';
      case DiceType.d8:
        return 'D8';
      case DiceType.d12:
        return 'D12';
      case DiceType.d16:
        return 'D16';
    }
  }

  /// Get the next upgraded dice type.
  /// Returns null if already at max level.
  DiceType? get upgraded {
    switch (this) {
      case DiceType.d4:
        return DiceType.d6;
      case DiceType.d6:
        return DiceType.d8;
      case DiceType.d8:
        return DiceType.d12;
      case DiceType.d12:
        return DiceType.d16;
      case DiceType.d16:
        return null;
    }
  }
}
