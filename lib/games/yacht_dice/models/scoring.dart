import 'dart:math';

import 'scoring_category.dart';

/// Calculates the score for a given [ScoringCategory] based on the provided dice values.
int calculateScore(List<int> dice, ScoringCategory category) {
  switch (category) {
    case ScoringCategory.ones:
      return dice.where((die) => die == 1).length * 1;
    case ScoringCategory.twos:
      return dice.where((die) => die == 2).length * 2;
    case ScoringCategory.threes:
      return dice.where((die) => die == 3).length * 3;
    case ScoringCategory.fours:
      return dice.where((die) => die == 4).length * 4;
    case ScoringCategory.fives:
      return dice.where((die) => die == 5).length * 5;
    case ScoringCategory.sixes:
      return dice.where((die) => die == 6).length * 6;

    case ScoringCategory.allSelect:
      // Chance: sum of all dice
      return dice.reduce((a, b) => a + b);

    case ScoringCategory.fullHouse:
      // Full House: 25 points (3 of a kind + pair)
      final counts = _getDiceCounts(dice);
      final hasThreeOfAKind = counts.contains(3);
      final hasPair = counts.contains(2);
      return (hasThreeOfAKind && hasPair) ? 25 : 0;

    case ScoringCategory.fourOfAKind:
      // Four of a Kind: sum of all dice if at least 4 are the same
      final counts = _getDiceCounts(dice);
      if (counts.contains(4) || counts.contains(5)) {
        return dice.reduce((a, b) => a + b);
      }
      return 0;

    case ScoringCategory.smallStraight:
      // Small Straight: 15 points (4 consecutive: 1-2-3-4 or 2-3-4-5 or 3-4-5-6)
      final uniqueDice = dice.toSet();
      if (uniqueDice.containsAll({1, 2, 3, 4}) ||
          uniqueDice.containsAll({2, 3, 4, 5}) ||
          uniqueDice.containsAll({3, 4, 5, 6})) {
        return 15;
      }
      return 0;

    case ScoringCategory.largeStraight:
      // Large Straight: 30 points (5 consecutive: 1-2-3-4-5 or 2-3-4-5-6)
      final uniqueDice = dice.toSet();
      if (uniqueDice.length == 5) {
        if (uniqueDice.containsAll({1, 2, 3, 4, 5}) ||
            uniqueDice.containsAll({2, 3, 4, 5, 6})) {
          return 30;
        }
      }
      return 0;

    case ScoringCategory.yacht:
      // Yacht: 50 points (5 of a kind, all dice must be 1-6)
      if (dice.every((die) => die >= 1 && die <= 6 && die == dice[0])) {
        return 50;
      }
      return 0;
  }
}

/// Calculates the bonus points (35) if the sum of upper section (1-6) >= 63
int calculateBonus(int upperSectionSum) {
  return upperSectionSum >= 63 ? 35 : 0;
}

/// Detect special combinations for celebration animation
/// Returns the ScoringCategory if a special combination is found, null otherwise
ScoringCategory? detectSpecialCombination(List<int> dice) {
  // Skip if any dice is 0 (not rolled)
  if (dice.any((d) => d == 0)) return null;

  // Check in order of priority (Yacht is most special)
  final yachtScore = calculateScore(dice, ScoringCategory.yacht);
  if (yachtScore > 0) return ScoringCategory.yacht;

  final largeStraightScore = calculateScore(
    dice,
    ScoringCategory.largeStraight,
  );
  if (largeStraightScore > 0) return ScoringCategory.largeStraight;

  final smallStraightScore = calculateScore(
    dice,
    ScoringCategory.smallStraight,
  );
  if (smallStraightScore > 0) return ScoringCategory.smallStraight;

  final fullHouseScore = calculateScore(dice, ScoringCategory.fullHouse);
  if (fullHouseScore > 0) return ScoringCategory.fullHouse;

  final fourOfAKindScore = calculateScore(dice, ScoringCategory.fourOfAKind);
  if (fourOfAKindScore > 0) return ScoringCategory.fourOfAKind;

  return null;
}

/// Returns the maximum possible score for a given category with optimal dice selection
/// This is used by AI to evaluate potential moves
int getMaxPossibleScore(ScoringCategory category) {
  switch (category) {
    case ScoringCategory.ones:
      return 5; // 5 ones
    case ScoringCategory.twos:
      return 10; // 5 twos
    case ScoringCategory.threes:
      return 15; // 5 threes
    case ScoringCategory.fours:
      return 20; // 5 fours
    case ScoringCategory.fives:
      return 25; // 5 fives
    case ScoringCategory.sixes:
      return 30; // 5 sixes
    case ScoringCategory.allSelect:
      return 30; // 5 sixes = 30
    case ScoringCategory.fullHouse:
      return 25; // Fixed score
    case ScoringCategory.fourOfAKind:
      return 30; // 5 sixes = 30
    case ScoringCategory.smallStraight:
      return 15; // Fixed score
    case ScoringCategory.largeStraight:
      return 30; // Fixed score
    case ScoringCategory.yacht:
      return 50; // Fixed score
  }
}

/// Helper function to get counts of each die value (1-6)
/// Ignores dice with value 0 (not rolled yet)
List<int> _getDiceCounts(List<int> dice) {
  final counts = List.filled(7, 0); // index 0 unused, 1-6 used
  for (final die in dice) {
    if (die >= 1 && die <= 6) {
      counts[die]++;
    }
  }
  return counts.sublist(1); // return counts for 1-6
}

/// Gets all possible scores for all categories given the current dice
Map<ScoringCategory, int> getAllPossibleScores(List<int> dice) {
  final scores = <ScoringCategory, int>{};
  for (final category in ScoringCategory.values) {
    scores[category] = calculateScore(dice, category);
  }
  return scores;
}
