import 'dart:math';

import '../models/dice_battle_state.dart';
import '../models/battle_effect.dart';
import 'dice_battle_ai.dart';

/// Medium AI that uses rule-based strategy.
class MediumAi extends DiceBattleAi {
  final Random _random = Random();

  @override
  Future<AiDecision> decideSelection(DiceBattleState state) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final player = state.currentPlayer;
    final diceSet = player.diceSet;
    final isAttacking = state.status.index == 0;

    final maxDice = isAttacking
        ? diceSet.maxAttackDice
        : diceSet.maxDefenseDice;

    // Sort dice by value (descending)
    final sortedDice = player.dice.asMap().entries.toList()
      ..sort((a, b) => b.value.value.compareTo(a.value.value));

    // Select top dice up to max limit
    final selectedIndices = <int>[];
    for (final entry in sortedDice) {
      if (selectedIndices.length >= maxDice) break;
      if (entry.value.value >= 3) {
        selectedIndices.add(entry.key);
      }
    }

    // If not enough high-value dice, add more
    if (selectedIndices.length < maxDice) {
      for (final entry in sortedDice) {
        if (selectedIndices.length >= maxDice) break;
        if (!selectedIndices.contains(entry.key)) {
          selectedIndices.add(entry.key);
        }
      }
    }

    return AiDecision(selectedDiceIndices: selectedIndices);
  }

  @override
  Future<List<int>> decideReroll(DiceBattleState state) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final player = state.currentPlayer;
    final selectedDice = player.selectedDice;

    if (selectedDice.isEmpty) return [];

    final rerollIndices = <int>[];

    // Re-roll dice with value < 3
    for (final dice in selectedDice) {
      if (dice.value < 3) {
        final index = player.dice.indexOf(dice);
        if (index >= 0) {
          rerollIndices.add(index);
        }
      }
    }

    // Consider current effect
    if (state.currentEffect != null) {
      switch (state.currentEffect!) {
        case BattleEffect.oddBonus:
          // Keep odd dice, re-roll even ones
          for (final dice in selectedDice) {
            if (dice.value % 2 == 0 && dice.value < 5) {
              final index = player.dice.indexOf(dice);
              if (index >= 0 && !rerollIndices.contains(index)) {
                rerollIndices.add(index);
              }
            }
          }
          break;
        default:
          break;
      }
    }

    // Limit re-roll count
    if (rerollIndices.length > 2) {
      rerollIndices.shuffle(_random);
      return rerollIndices.take(2).toList();
    }

    return rerollIndices;
  }
}
