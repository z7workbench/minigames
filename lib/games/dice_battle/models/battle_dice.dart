import 'dice_type.dart';

/// Represents a single battle dice with its current state.
class BattleDice {
  final DiceType type;
  final int value;
  final bool isSelected;
  final bool isRolling;

  const BattleDice({
    required this.type,
    this.value = 0,
    this.isSelected = false,
    this.isRolling = false,
  });

  /// Create a dice with random value based on its type.
  factory BattleDice.roll(DiceType type) {
    return BattleDice(type: type, value: _rollDice(type.faces));
  }

  /// Roll the dice and return a new instance with new value.
  BattleDice roll() {
    return copyWith(value: _rollDice(type.faces), isRolling: false);
  }

  /// Start rolling animation.
  BattleDice startRolling() {
    return copyWith(isRolling: true);
  }

  /// Stop rolling animation.
  BattleDice stopRolling() {
    return copyWith(isRolling: false);
  }

  /// Toggle selection state.
  BattleDice toggleSelection() {
    return copyWith(isSelected: !isSelected);
  }

  /// Upgrade the dice to next level.
  BattleDice upgrade() {
    final upgradedType = type.upgraded;
    if (upgradedType == null) return this;
    return BattleDice(type: upgradedType);
  }

  BattleDice copyWith({
    DiceType? type,
    int? value,
    bool? isSelected,
    bool? isRolling,
  }) {
    return BattleDice(
      type: type ?? this.type,
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
      isRolling: isRolling ?? this.isRolling,
    );
  }

  static int _rollDice(int faces) {
    return (DateTime.now().millisecondsSinceEpoch % faces) + 1;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BattleDice &&
        type == other.type &&
        value == other.value &&
        isSelected == other.isSelected &&
        isRolling == other.isRolling;
  }

  @override
  int get hashCode => Object.hash(type, value, isSelected, isRolling);
}
