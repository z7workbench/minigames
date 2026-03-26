import 'keyword.dart';

/// Battle effects that can be applied during the game.
/// Effects are drawn every 2 attack+defense rounds (except the first round).
enum BattleEffect {
  /// 1. Attack: If all dice are odd, +5 points.
  oddBonus,

  /// 2. Defense: If all dice are even, +4 points.
  evenBonus,

  /// 3. If damage < 10, combo (deal half damage again).
  comboOnLowDamage,

  /// 4. At turn start, upgrade one dice for both players.
  diceUpgrade,

  /// 5. When perfect block (defense >= attack), instant(5) damage to attacker.
  perfectBlockInstant,

  /// 6. If attack > 20 points, combo (deal half damage again).
  comboOnHighAttack,

  /// 7. At turn end, if both players' life sum = 42, defender +10.
  lifeSyncBonus,

  // Legacy effects for backward compatibility

  /// Legacy: If damage < 10, deal damage again.
  doubleDamage,

  /// Legacy: Before damage calculation, swap one dice value between players.
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
      case BattleEffect.comboOnLowDamage:
        return 'Low Strike Combo';
      case BattleEffect.diceUpgrade:
        return 'Dice Upgrade';
      case BattleEffect.perfectBlockInstant:
        return 'Perfect Counter';
      case BattleEffect.comboOnHighAttack:
        return 'High Power Combo';
      case BattleEffect.lifeSyncBonus:
        return 'Life Harmony';
      // Legacy effects
      case BattleEffect.doubleDamage:
        return 'Double Strike';
      case BattleEffect.diceSwap:
        return 'Dice Swap';
    }
  }

  /// Description of the effect with bold keyword markers.
  /// Keywords in descriptions are wrapped with ** for emphasis.
  String get description {
    switch (this) {
      case BattleEffect.oddBonus:
        return 'Attack: If all dice are odd, +5 points';
      case BattleEffect.evenBonus:
        return 'Defense: If all dice are even, +4 points';
      case BattleEffect.comboOnLowDamage:
        return 'If damage < 10, **Combo**: deal half damage again';
      case BattleEffect.diceUpgrade:
        return 'At turn start, **Upgrade**: both players upgrade one dice';
      case BattleEffect.perfectBlockInstant:
        return 'When **Perfect Block**, **Instant(5)**: deal 5 damage to attacker';
      case BattleEffect.comboOnHighAttack:
        return 'If attack > 20 points, **Combo**: deal half damage again';
      case BattleEffect.lifeSyncBonus:
        return 'At turn end, if life sum = 42, defender +10 HP';
      // Legacy effects
      case BattleEffect.doubleDamage:
        return 'If damage < 10, deal damage again';
      case BattleEffect.diceSwap:
        return 'Before damage, swap one dice value';
    }
  }

  /// Keywords associated with this effect.
  List<Keyword> get keywords {
    switch (this) {
      case BattleEffect.oddBonus:
        return [];
      case BattleEffect.evenBonus:
        return [];
      case BattleEffect.comboOnLowDamage:
        return [Keyword.combo];
      case BattleEffect.diceUpgrade:
        return [Keyword.upgrade];
      case BattleEffect.perfectBlockInstant:
        return [Keyword.perfectBlock, Keyword.instant];
      case BattleEffect.comboOnHighAttack:
        return [Keyword.combo];
      case BattleEffect.lifeSyncBonus:
        return [];
      // Legacy effects
      case BattleEffect.doubleDamage:
        return [Keyword.combo];
      case BattleEffect.diceSwap:
        return [];
    }
  }

  /// Icon identifier for the effect.
  String get iconName {
    switch (this) {
      case BattleEffect.oddBonus:
        return 'odd';
      case BattleEffect.evenBonus:
        return 'even';
      case BattleEffect.comboOnLowDamage:
        return 'combo_low';
      case BattleEffect.diceUpgrade:
        return 'upgrade';
      case BattleEffect.perfectBlockInstant:
        return 'perfect_counter';
      case BattleEffect.comboOnHighAttack:
        return 'combo_high';
      case BattleEffect.lifeSyncBonus:
        return 'life_sync';
      // Legacy effects
      case BattleEffect.doubleDamage:
        return 'double';
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

  /// Check if combo should be applied for low damage (< 10).
  static bool shouldComboOnLowDamage(int damage) {
    return damage > 0 && damage < 10;
  }

  /// Check if combo should be applied for high attack (> 20).
  static bool shouldComboOnHighAttack(int attackValue) {
    return attackValue > 20;
  }

  /// Calculate combo damage (half of original damage, rounded down).
  static int calculateComboDamage(int originalDamage) {
    return originalDamage ~/ 2;
  }

  /// Check if perfect block condition is met (defense >= attack).
  static bool isPerfectBlock(int defenseValue, int attackValue) {
    return defenseValue >= attackValue;
  }

  /// Get instant damage for perfect block counter (always 5).
  static int getPerfectBlockInstantDamage() {
    return 5;
  }

  /// Check if life sync bonus applies (sum = 42).
  static bool shouldApplyLifeSyncBonus(int player1Life, int player2Life) {
    return player1Life + player2Life == 42;
  }

  /// Get life sync bonus amount.
  static int getLifeSyncBonus() {
    return 10;
  }

  /// Check if double damage should be applied (legacy effect).
  static bool shouldDoubleDamage(int damage) {
    return damage > 0 && damage < 10;
  }

  /// Get a random effect for the battle.
  /// Excludes legacy effects from random selection.
  static BattleEffect getRandomEffect() {
    // Use only new effects, not legacy ones
    final newEffects = [
      BattleEffect.oddBonus,
      BattleEffect.evenBonus,
      BattleEffect.comboOnLowDamage,
      BattleEffect.diceUpgrade,
      BattleEffect.perfectBlockInstant,
      BattleEffect.comboOnHighAttack,
      BattleEffect.lifeSyncBonus,
    ];
    final index = DateTime.now().millisecondsSinceEpoch % newEffects.length;
    return newEffects[index];
  }
}
