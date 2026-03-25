import 'dart:math';

import '../models/dice_battle_state.dart';
import 'dice_battle_ai.dart';

/// Easy AI that makes random decisions.
class EasyAi extends DiceBattleAi {
  final Random _random = Random();

  @override
  Future<AiDecision> decideSelection(DiceBattleState state) async {
    // Add delay for natural feel
    await Future.delayed(const Duration(milliseconds: 500));

    final player = state.currentPlayer;
    final diceSet = player.diceSet;

    // Determine max dice based on phase
    final maxDice =
        state.status.index ==
            0 // attacking
        ? diceSet.maxAttackDice
        : diceSet.maxDefenseDice;

    // Randomly select dice indices
    final allIndices = List.generate(player.dice.length, (i) => i);
    allIndices.shuffle(_random);

    final selectedCount = _random.nextInt(maxDice) + 1;
    final selectedIndices = allIndices.take(selectedCount).toList();

    return AiDecision(selectedDiceIndices: selectedIndices);
  }

  @override
  Future<List<int>> decideReroll(DiceBattleState state) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // 50% chance to not re-roll at all
    if (_random.nextDouble() < 0.5) {
      return [];
    }

    final player = state.currentPlayer;
    final selectedIndices = player.selectedDice
        .asMap()
        .entries
        .map((e) => player.dice.indexOf(e.value))
        .toList();

    if (selectedIndices.isEmpty) return [];

    // Randomly choose dice to re-roll
    final rerollCount = _random.nextInt(selectedIndices.length) + 1;
    selectedIndices.shuffle(_random);

    return selectedIndices.take(rerollCount).toList();
  }
}
