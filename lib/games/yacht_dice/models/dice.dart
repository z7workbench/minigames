class Dice {
  final int value; // 1-6
  final bool isKept;
  final bool isRolling;

  const Dice({
    required this.value,
    this.isKept = false,
    this.isRolling = false,
  });

  Dice copyWith({int? value, bool? isKept, bool? isRolling}) {
    return Dice(
      value: value ?? this.value,
      isKept: isKept ?? this.isKept,
      isRolling: isRolling ?? this.isRolling,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Dice) return false;

    return value == other.value &&
        isKept == other.isKept &&
        isRolling == other.isRolling;
  }

  @override
  int get hashCode => Object.hash(value, isKept, isRolling);
}
