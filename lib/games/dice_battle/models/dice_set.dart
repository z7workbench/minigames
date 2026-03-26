import 'dice_type.dart';
import 'battle_dice.dart';

/// Represents a dice set configuration for the game.
/// Each set defines attack/defense points and available dice.
class DiceSet {
  final String id;
  final String name;
  final int attackPoints;
  final int defensePoints;
  final List<DiceType> diceTypes;

  const DiceSet({
    required this.id,
    required this.name,
    required this.attackPoints,
    required this.defensePoints,
    required this.diceTypes,
  });

  /// Maximum number of dice that can be used for attack.
  int get maxAttackDice => attackPoints;

  /// Maximum number of dice that can be used for defense.
  int get maxDefenseDice => defensePoints;

  /// Total number of dice in this set.
  int get totalDice => diceTypes.length;

  /// Create initial dice list for this set.
  List<BattleDice> createInitialDice() {
    return diceTypes.map((type) => BattleDice(type: type)).toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DiceSet && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Predefined dice sets available in the game.
class DiceSets {
  /// Set 1: Attack 3, Defense 2
  /// 3 D4 + 2 D6
  static final set1 = DiceSet(
    id: 'set1',
    name: 'Balanced Set',
    attackPoints: 3,
    defensePoints: 2,
    diceTypes: [
      DiceType.d4,
      DiceType.d4,
      DiceType.d4,
      DiceType.d6,
      DiceType.d6,
    ],
  );

  /// Set 2: Attack 4, Defense 3
  /// 4 D4 + 1 D6
  static final set2 = DiceSet(
    id: 'set2',
    name: 'Aggressive Set',
    attackPoints: 4,
    defensePoints: 3,
    diceTypes: [
      DiceType.d4,
      DiceType.d4,
      DiceType.d4,
      DiceType.d4,
      DiceType.d6,
    ],
  );

  /// Set 3: Attack 2, Defense 3
  /// 2 D6 + 2 D8
  static final set3 = DiceSet(
    id: 'set3',
    name: 'Defensive Set',
    attackPoints: 2,
    defensePoints: 3,
    diceTypes: [DiceType.d6, DiceType.d6, DiceType.d8, DiceType.d8],
  );

  /// Set 4: Attack 3, Defense 3
  /// 3 D4 + 2 D6
  static final set4 = DiceSet(
    id: 'set4',
    name: 'Versatile Set',
    attackPoints: 3,
    defensePoints: 3,
    diceTypes: [
      DiceType.d4,
      DiceType.d4,
      DiceType.d4,
      DiceType.d6,
      DiceType.d6,
    ],
  );

  /// Set 5: Attack 3, Defense 3
  /// 3 D4 + 1 D6 + 1 D8
  static final set5 = DiceSet(
    id: 'set5',
    name: 'Mixed Set',
    attackPoints: 3,
    defensePoints: 3,
    diceTypes: [
      DiceType.d4,
      DiceType.d4,
      DiceType.d4,
      DiceType.d6,
      DiceType.d8,
    ],
  );

  /// All available dice sets.
  static List<DiceSet> get all => [set1, set2, set3, set4, set5];

  /// Get a dice set by ID.
  static DiceSet? getById(String id) {
    return all.firstWhere((set) => set.id == id, orElse: () => set1);
  }
}
