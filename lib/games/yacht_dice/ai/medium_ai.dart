import 'dart:math';

import '../models/scoring_category.dart';
import '../models/yacht_dice_state.dart';
import '../models/scoring.dart';
import 'yacht_ai.dart';

/// Medium difficulty AI that uses rule-based strategy.
///
/// Priority order for category selection:
/// 1. Yacht (5 of a kind) - 50 pts
/// 2. Large Straight - 40 pts
/// 3. Small Straight - 30 pts
/// 4. Full House - 25 pts
/// 5. Four of a Kind
/// 6. Upper section (descending from sixes to ones)
/// 7. All Select (chance)
class MediumAi extends YachtAi {
  final Random _random = Random();

  // Priority order for category selection (highest priority first)
  static const List<ScoringCategory> _categoryPriority = [
    ScoringCategory.yacht, // 1. Yacht
    ScoringCategory.largeStraight, // 2. Large Straight
    ScoringCategory.smallStraight, // 3. Small Straight
    ScoringCategory.fullHouse, // 4. Full House
    ScoringCategory.fourOfAKind, // 5. Four of a Kind
    ScoringCategory.sixes, // 6. Upper section (descending)
    ScoringCategory.fives,
    ScoringCategory.fours,
    ScoringCategory.threes,
    ScoringCategory.twos,
    ScoringCategory.ones,
    ScoringCategory.allSelect, // 12. All Select (chance)
  ];

  @override
  Future<AiDecision> decide(YachtDiceState state) async {
    final currentPlayer = state.players[state.currentPlayerIndex];
    await Future.delayed(const Duration(milliseconds: 350));

    if (state.phase == GamePhase.selectingCategory) {
      return _selectCategory(currentPlayer);
    } else {
      return _decideDiceToKeep(currentPlayer, state);
    }
  }

  AiDecision _selectCategory(PlayerState player) {
    final availableCategories = ScoringCategory.values
        .where((category) => player.scores[category] == null)
        .toSet();

    // Find best category based on priority + actual score
    ScoringCategory? bestCategory;
    int bestWeightedScore = -1;

    for (final category in _categoryPriority) {
      if (!availableCategories.contains(category)) continue;

      final score = calculateScore(player.dice, category);

      // Weight by category priority (higher priority = higher weight)
      final categoryPriority = _categoryPriority.indexOf(category);
      final weightedScore = (12 - categoryPriority) * 1000 + score;

      if (weightedScore > bestWeightedScore) {
        bestWeightedScore = weightedScore;
        bestCategory = category;
      }
    }

    if (bestCategory == null) {
      return const AiDecision(diceToKeep: [true, true, true, true, true]);
    }

    return AiDecision(
      diceToKeep: [true, true, true, true, true],
      categoryToSelect: bestCategory,
    );
  }

  AiDecision _decideDiceToKeep(PlayerState player, YachtDiceState state) {
    // If last roll, keep all and let category selection handle it
    if (player.rollsRemaining <= 1) {
      return const AiDecision(
        diceToKeep: [true, true, true, true, true],
        categoryToSelect: null,
      );
    }

    final dice = player.dice;
    final availableCategories = ScoringCategory.values
        .where((category) => player.scores[category] == null)
        .toSet();

    // Count occurrences of each die value
    final counts = _getDiceCounts(dice);
    final diceToKeep = List<bool>.filled(5, false);

    // Strategy 1: Going for Yacht (5 of a kind)
    final maxCount = counts.reduce((a, b) => a > b ? a : b);
    if (maxCount >= 3 && availableCategories.contains(ScoringCategory.yacht)) {
      final targetValue = counts.indexOf(maxCount) + 1;
      for (var i = 0; i < 5; i++) {
        diceToKeep[i] = dice[i] == targetValue;
      }
      return AiDecision(diceToKeep: diceToKeep, categoryToSelect: null);
    }

    // Strategy 2: Going for Four of a Kind
    if (maxCount >= 2 &&
        availableCategories.contains(ScoringCategory.fourOfAKind)) {
      final targetValue = counts.indexOf(maxCount) + 1;
      for (var i = 0; i < 5; i++) {
        diceToKeep[i] = dice[i] == targetValue;
      }
      return AiDecision(diceToKeep: diceToKeep, categoryToSelect: null);
    }

    // Strategy 3: Going for Full House
    if (availableCategories.contains(ScoringCategory.fullHouse)) {
      final pairValue = _findValueWithCount(counts, 2);
      final tripleValue = _findValueWithCount(counts, 3);

      if (pairValue != null || tripleValue != null) {
        for (var i = 0; i < 5; i++) {
          if (tripleValue != null && dice[i] == tripleValue + 1) {
            diceToKeep[i] = true;
          } else if (pairValue != null && dice[i] == pairValue + 1) {
            diceToKeep[i] = true;
          }
        }
        if (diceToKeep.any((k) => k)) {
          return AiDecision(diceToKeep: diceToKeep, categoryToSelect: null);
        }
      }
    }

    // Strategy 4: Going for straights
    if (availableCategories.contains(ScoringCategory.largeStraight) ||
        availableCategories.contains(ScoringCategory.smallStraight)) {
      final straightDice = _findStraightDice(dice);
      for (var i = 0; i < 5; i++) {
        diceToKeep[i] = straightDice.contains(dice[i]);
      }
      if (diceToKeep.any((k) => k)) {
        return AiDecision(diceToKeep: diceToKeep, categoryToSelect: null);
      }
    }

    // Strategy 5: Keep high-value dice for upper section
    for (var value = 6; value >= 1; value--) {
      final category = _getCategoryForValue(value);
      if (availableCategories.contains(category) && counts[value - 1] >= 2) {
        for (var i = 0; i < 5; i++) {
          diceToKeep[i] = dice[i] == value;
        }
        return AiDecision(diceToKeep: diceToKeep, categoryToSelect: null);
      }
    }

    // Default: Keep highest dice
    final maxDie = dice.reduce((a, b) => a > b ? a : b);
    for (var i = 0; i < 5; i++) {
      diceToKeep[i] = dice[i] == maxDie;
    }

    return AiDecision(diceToKeep: diceToKeep, categoryToSelect: null);
  }

  List<int> _getDiceCounts(List<int> dice) {
    final counts = List.filled(6, 0);
    for (final die in dice) {
      counts[die - 1]++;
    }
    return counts;
  }

  int? _findValueWithCount(List<int> counts, int targetCount) {
    for (var i = 0; i < 6; i++) {
      if (counts[i] == targetCount) return i;
    }
    return null;
  }

  Set<int> _findStraightDice(List<int> dice) {
    final uniqueSorted = dice.toSet().toList()..sort();
    final straightDice = <int>{};

    // Look for sequences of 3 or more consecutive values
    for (var i = 0; i < uniqueSorted.length; i++) {
      var seqLength = 1;
      var j = i;
      while (j + 1 < uniqueSorted.length &&
          uniqueSorted[j + 1] == uniqueSorted[j] + 1) {
        seqLength++;
        j++;
      }

      // Keep sequences of 3 or more
      if (seqLength >= 3) {
        for (var k = i; k <= j; k++) {
          straightDice.add(uniqueSorted[k]);
        }
      }
    }

    return straightDice;
  }

  ScoringCategory _getCategoryForValue(int value) {
    return ScoringCategory.values[value - 1]; // ones=0, twos=1, etc.
  }
}
