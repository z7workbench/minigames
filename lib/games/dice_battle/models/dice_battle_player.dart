import 'battle_dice.dart';
import 'dice_set.dart';
import 'dice_type.dart';

/// Player type enumeration.
enum PlayerType { human, ai }

/// AI difficulty levels.
enum AiDifficulty { easy, medium, hard }

/// Represents a player in the dice battle game.
class DiceBattlePlayer {
  final String name;
  final PlayerType type;
  final AiDifficulty? aiDifficulty;
  final int health;
  final int maxHealth;
  final List<BattleDice> dice;
  final String diceSetId;
  final bool hasSelectedDice;

  const DiceBattlePlayer({
    required this.name,
    required this.type,
    this.aiDifficulty,
    required this.health,
    required this.maxHealth,
    required this.dice,
    required this.diceSetId,
    this.hasSelectedDice = false,
  });

  /// Create initial player.
  factory DiceBattlePlayer.initial({
    required String name,
    required PlayerType type,
    AiDifficulty? aiDifficulty,
    required DiceSet diceSet,
  }) {
    return DiceBattlePlayer(
      name: name,
      type: type,
      aiDifficulty: aiDifficulty,
      health: 50,
      maxHealth: 50,
      dice: diceSet.createInitialDice(),
      diceSetId: diceSet.id,
      hasSelectedDice: false,
    );
  }

  /// Check if player is still alive.
  bool get isAlive => health > 0;

  /// Check if player is AI.
  bool get isAi => type == PlayerType.ai;

  /// Get the dice set configuration.
  DiceSet get diceSet => DiceSets.getById(diceSetId) ?? DiceSets.set1;

  /// Get selected dice for attack/defense.
  List<BattleDice> get selectedDice => dice.where((d) => d.isSelected).toList();

  /// Get sum of selected dice values.
  int get selectedDiceSum => selectedDice.fold(0, (sum, d) => sum + d.value);

  /// Get number of selected dice.
  int get selectedDiceCount => selectedDice.length;

  /// Take damage and return new player state.
  DiceBattlePlayer takeDamage(int damage) {
    final newHealth = (health - damage).clamp(0, maxHealth);
    return copyWith(health: newHealth);
  }

  /// Roll all dice.
  DiceBattlePlayer rollAllDice() {
    return copyWith(
      dice: dice.map((d) => d.roll()).toList(),
      hasSelectedDice: false,
    );
  }

  /// Re-roll selected dice.
  DiceBattlePlayer rerollSelected() {
    return copyWith(
      dice: dice.map((d) => d.isSelected ? d.roll() : d).toList(),
    );
  }

  /// Select a dice at index.
  DiceBattlePlayer selectDice(int index) {
    if (index < 0 || index >= dice.length) return this;
    final newDice = List<BattleDice>.from(dice);
    newDice[index] = dice[index].toggleSelection();
    return copyWith(dice: newDice);
  }

  /// Clear all selections.
  DiceBattlePlayer clearSelection() {
    return copyWith(
      dice: dice.map((d) => d.copyWith(isSelected: false)).toList(),
    );
  }

  /// Confirm dice selection.
  DiceBattlePlayer confirmSelection() {
    return copyWith(hasSelectedDice: true);
  }

  /// Upgrade a random dice.
  DiceBattlePlayer upgradeRandomDice() {
    if (dice.isEmpty) return this;
    final upgradableIndices = dice
        .asMap()
        .entries
        .where((e) => e.value.type.upgraded != null)
        .map((e) => e.key)
        .toList();

    if (upgradableIndices.isEmpty) return this;

    final index =
        upgradableIndices[DateTime.now().millisecondsSinceEpoch %
            upgradableIndices.length];
    final newDice = List<BattleDice>.from(dice);
    newDice[index] = dice[index].upgrade();

    return copyWith(dice: newDice);
  }

  /// Swap a dice value with another player.
  /// Returns [this, otherPlayer] after swap.
  List<DiceBattlePlayer> swapDiceWith(
    DiceBattlePlayer other,
    int thisIndex,
    int otherIndex,
  ) {
    if (thisIndex < 0 ||
        thisIndex >= dice.length ||
        otherIndex < 0 ||
        otherIndex >= other.dice.length) {
      return [this, other];
    }

    final thisDice = dice[thisIndex];
    final otherDice = other.dice[otherIndex];

    final newThisDice = List<BattleDice>.from(dice);
    final newOtherDice = List<BattleDice>.from(other.dice);

    // Swap values only, not dice types
    newThisDice[thisIndex] = thisDice.copyWith(value: otherDice.value);
    newOtherDice[otherIndex] = otherDice.copyWith(value: thisDice.value);

    return [copyWith(dice: newThisDice), other.copyWith(dice: newOtherDice)];
  }

  DiceBattlePlayer copyWith({
    String? name,
    PlayerType? type,
    AiDifficulty? aiDifficulty,
    int? health,
    int? maxHealth,
    List<BattleDice>? dice,
    String? diceSetId,
    bool? hasSelectedDice,
  }) {
    return DiceBattlePlayer(
      name: name ?? this.name,
      type: type ?? this.type,
      aiDifficulty: aiDifficulty ?? this.aiDifficulty,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      dice: dice ?? this.dice,
      diceSetId: diceSetId ?? this.diceSetId,
      hasSelectedDice: hasSelectedDice ?? this.hasSelectedDice,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DiceBattlePlayer &&
        name == other.name &&
        type == other.type &&
        health == other.health &&
        diceSetId == other.diceSetId;
  }

  @override
  int get hashCode => Object.hash(name, type, health, diceSetId);
}
