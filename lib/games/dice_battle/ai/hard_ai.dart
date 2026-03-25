import 'dart:math';

import '../models/dice_battle_state.dart';
import '../models/dice_battle_player.dart';
import '../models/battle_dice.dart';
import '../models/battle_effect.dart';
import '../models/dice_type.dart';
import 'dice_battle_ai.dart';

/// Hard AI using heuristic evaluation and strategic planning.
class HardAi extends DiceBattleAi {
  final Random _random = Random();

  @override
  Future<AiDecision> decideSelection(DiceBattleState state) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final player = state.currentPlayer;
    final opponent = state.opponentPlayer;
    final diceSet = player.diceSet;
    final isAttacking = state.status.index == 0;

    final maxDice = isAttacking
        ? diceSet.maxAttackDice
        : diceSet.maxDefenseDice;

    // Calculate expected value for each combination
    final combinations = _generateCombinations(player.dice.length, maxDice);

    double bestValue = double.negativeInfinity;
    List<int> bestSelection = [];

    for (final combo in combinations) {
      final value = _evaluateCombination(
        combo,
        player.dice,
        opponent,
        isAttacking,
        state.currentEffect,
      );
      if (value > bestValue) {
        bestValue = value;
        bestSelection = combo;
      }
    }

    return AiDecision(selectedDiceIndices: bestSelection);
  }

  @override
  Future<List<int>> decideReroll(DiceBattleState state) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final player = state.currentPlayer;
    final selectedDice = player.selectedDice;

    if (selectedDice.isEmpty) return [];

    final rerollIndices = <int>[];

    // Evaluate each selected dice for re-roll potential
    for (final dice in selectedDice) {
      final expectedValue = (dice.type.faces + 1) / 2; // Expected value of dice
      final currentValue = dice.value;

      // Re-roll if expected value is significantly higher
      if (expectedValue - currentValue > 1.5) {
        final index = player.dice.indexOf(dice);
        if (index >= 0) {
          rerollIndices.add(index);
        }
      }
    }

    // Consider current effect in re-roll decision
    if (state.currentEffect != null) {
      switch (state.currentEffect!) {
        case BattleEffect.oddBonus:
          // Strategic: aim for all odd
          final oddCount = selectedDice.where((d) => d.value % 2 == 1).length;
          if (oddCount < selectedDice.length) {
            for (final dice in selectedDice) {
              if (dice.value % 2 == 0) {
                final index = player.dice.indexOf(dice);
                if (index >= 0 && !rerollIndices.contains(index)) {
                  // 50% chance to re-roll even dice for odd bonus
                  if (_random.nextDouble() < 0.5) {
                    rerollIndices.add(index);
                  }
                }
              }
            }
          }
          break;
        case BattleEffect.evenBonus:
          // This is defense effect, AI doesn't need to optimize for it
          break;
        default:
          break;
      }
    }

    // Don't re-roll too many dice
    if (rerollIndices.length > 2) {
      // Prioritize by potential gain
      rerollIndices.sort((a, b) {
        final diceA = player.dice[a];
        final diceB = player.dice[b];
        return diceA.value.compareTo(diceB.value);
      });
      return rerollIndices.take(2).toList();
    }

    return rerollIndices;
  }

  /// Generate all possible combinations of dice indices.
  List<List<int>> _generateCombinations(int totalDice, int maxSelect) {
    final combinations = <List<int>>[];

    void generate(List<int> current, int start) {
      if (current.isNotEmpty) {
        combinations.add(List.from(current));
      }
      if (current.length >= maxSelect) return;

      for (int i = start; i < totalDice; i++) {
        current.add(i);
        generate(current, i + 1);
        current.removeLast();
      }
    }

    generate([], 0);
    return combinations;
  }

  /// Evaluate a combination of dice.
  double _evaluateCombination(
    List<int> indices,
    List<BattleDice> allDice,
    DiceBattlePlayer opponent,
    bool isAttacking,
    BattleEffect? effect,
  ) {
    final selectedDice = indices.map((i) => allDice[i]).toList();
    final sum = selectedDice.fold(0, (s, d) => s + d.value);

    double value = sum.toDouble();

    // Factor in effect bonuses
    if (effect != null) {
      switch (effect) {
        case BattleEffect.oddBonus:
          if (isAttacking) {
            final allOdd = selectedDice.every((d) => d.value % 2 == 1);
            if (allOdd) value += 5;
            // Bonus for having mostly odd dice
            final oddCount = selectedDice.where((d) => d.value % 2 == 1).length;
            value += oddCount * 0.5;
          }
          break;
        case BattleEffect.evenBonus:
          if (!isAttacking) {
            final allEven = selectedDice.every((d) => d.value % 2 == 0);
            if (allEven) value += 4;
          }
          break;
        case BattleEffect.doubleDamage:
          if (isAttacking) {
            // Prefer higher damage potential
            value *= 1.2;
          }
          break;
        default:
          break;
      }
    }

    // Defense strategy: try to match expected opponent attack
    if (!isAttacking) {
      final opponentExpectedDamage = _estimateOpponentDamage(opponent);
      if (sum >= opponentExpectedDamage * 0.8) {
        value += 5; // Bonus for adequate defense
      }
    }

    // Prefer using more dice for flexibility
    value += indices.length * 0.3;

    return value;
  }

  /// Estimate opponent's potential damage.
  int _estimateOpponentDamage(DiceBattlePlayer opponent) {
    final diceSet = opponent.diceSet;
    final maxAttack = diceSet.maxAttackDice;

    // Estimate based on dice types
    int estimatedSum = 0;
    final sortedDice = opponent.dice.toList()
      ..sort((a, b) => b.type.faces.compareTo(a.type.faces));

    for (int i = 0; i < maxAttack && i < sortedDice.length; i++) {
      estimatedSum += (sortedDice[i].type.faces ~/ 2) + 1;
    }

    return estimatedSum;
  }
}
