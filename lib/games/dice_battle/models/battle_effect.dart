/// Battle effects that can be applied during the game.
/// Effects are drawn every 2 attack+defense rounds (except the first round).
enum BattleEffect {
  /// Attack: If all dice are odd, +5 points.
  oddBonus,

  /// Defense: If all dice are even, +4 points.
  evenBonus,

  /// If damage < 10, deal damage again.
  doubleDamage,

  /// Randomly upgrade one dice for both players.
  diceUpgrade,

  /// Before damage calculation, swap one dice value between players.
  diceSwap,
}

extension BattleEffectExtension on BattleEffect {
  /// Display name for the effect.
  String get displayName {
    switch (this) {
      case BattleEffect.oddBonus:
        return 'Odd Power';
      case BattleEffect.evenBonus:
        return 'Even Shield';
      case BattleEffect.doubleDamage:
        return 'Double Strike';
      case BattleEffect.diceUpgrade:
        return 'Dice Upgrade';
      case BattleEffect.diceSwap:
        return 'Dice Swap';
    }
  }

  /// Description of the effect.
  String get description {
    switch (this) {
      case BattleEffect.oddBonus:
        return 'Attack: If all dice are odd, +5 points';
      case BattleEffect.evenBonus:
        return 'Defense: If all dice are even, +4 points';
      case BattleEffect.doubleDamage:
        return 'If damage < 10, deal damage again';
      case BattleEffect.diceUpgrade:
        return 'Randomly upgrade one dice for both players';
      case BattleEffect.diceSwap:
        return 'Before damage, swap one dice value';
    }
  }

  /// Icon identifier for the effect.
  String get iconName {
    switch (this) {
      case BattleEffect.oddBonus:
        return 'odd';
      case BattleEffect.evenBonus:
        return 'even';
      case BattleEffect.doubleDamage:
        return 'double';
      case BattleEffect.diceUpgrade:
        return 'upgrade';
      case BattleEffect.diceSwap:
        return 'swap';
    }
  }
}

/// Effect processor that applies effects to battle calculations.
class EffectProcessor {
  /// Apply odd bonus effect to attack value.
  /// Returns the bonus amount (0 or 5).
  static int applyOddBonus(List<int> diceValues) {
    if (diceValues.isEmpty) return 0;
    final allOdd = diceValues.every((v) => v % 2 == 1);
    return allOdd ? 5 : 0;
  }

  /// Apply even bonus effect to defense value.
  /// Returns the bonus amount (0 or 4).
  static int applyEvenBonus(List<int> diceValues) {
    if (diceValues.isEmpty) return 0;
    final allEven = diceValues.every((v) => v % 2 == 0);
    return allEven ? 4 : 0;
  }

  /// Check if double damage should be applied.
  static bool shouldDoubleDamage(int damage) {
    return damage > 0 && damage < 10;
  }

  /// Get a random effect for the battle.
  static BattleEffect getRandomEffect() {
    final effects = BattleEffect.values;
    final index = DateTime.now().millisecondsSinceEpoch % effects.length;
    return effects[index];
  }
}
