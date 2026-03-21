import 'dart:math';

import '../models/scoring_category.dart';
import '../models/yacht_dice_state.dart';
import 'yacht_ai.dart';

class EasyAi extends YachtAi {
  final Random _random = Random();

  @override
  Future<AiDecision> decide(YachtDiceState state) async {
    final currentPlayer = state.players[state.currentPlayerIndex];

    // Add a small delay to make AI feel more natural (but still fast)
    await Future.delayed(const Duration(milliseconds: 300));

    if (state.phase == GamePhase.selectingCategory) {
      // Select a category from available ones
      final availableCategories = ScoringCategory.values
          .where((category) => currentPlayer.scores[category] == null)
          .toList();

      if (availableCategories.isEmpty) {
        return const AiDecision(
          diceToKeep: [false, false, false, false, false],
        );
      }

      // Randomly select an available category
      final selectedCategory =
          availableCategories[_random.nextInt(availableCategories.length)];

      return AiDecision(
        diceToKeep: [
          true,
          true,
          true,
          true,
          true,
        ], // Keep all dice when selecting category
        categoryToSelect: selectedCategory,
      );
    } else {
      // Decide which dice to keep during rolling phase
      final diceToKeep = List.generate(5, (_) {
        // 30% chance to keep each die
        return _random.nextDouble() < 0.3;
      });

      return AiDecision(diceToKeep: diceToKeep, categoryToSelect: null);
    }
  }
}
