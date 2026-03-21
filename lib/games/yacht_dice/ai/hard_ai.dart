import 'dart:math';

import '../models/scoring_category.dart';
import '../models/yacht_dice_state.dart';
import '../models/scoring.dart';
import 'yacht_ai.dart';

/// Hard difficulty AI using Expectimax algorithm for optimal decision-making.
///
/// The AI uses a depth-limited search (2-ply) to evaluate expected values
/// of different dice-keeping strategies, considering:
/// - Chance nodes (dice roll probabilities)
/// - Max nodes (AI chooses best action)
/// - Upper section bonus potential
/// - Category scoring optimization
class HardAi extends YachtAi {
  final Random _random = Random();

  /// Maximum search depth for expectimax
  static const int _maxDepth = 2;

  @override
  Future<AiDecision> decide(YachtDiceState state) async {
    final currentPlayer = state.players[state.currentPlayerIndex];
    await Future.delayed(const Duration(milliseconds: 400));

    // Check if we can select a category (either in selectingCategory phase or after rolling)
    if (state.phase == GamePhase.selectingCategory ||
        (state.phase == GamePhase.rolling &&
            currentPlayer.rollsRemaining < 3)) {
      // Check if early selection is beneficial
      if (_shouldSelectCategoryNow(player: currentPlayer, state: state)) {
        return _selectBestCategory(currentPlayer, state);
      }
    }

    if (state.phase == GamePhase.selectingCategory) {
      return _selectBestCategory(currentPlayer, state);
    } else {
      return _expectimaxDecision(player: currentPlayer, state: state);
    }
  }

  /// Determine if it's better to select a category now rather than continue rolling
  bool _shouldSelectCategoryNow({
    required PlayerState player,
    required YachtDiceState state,
  }) {
    // If no rolls remaining, must select
    if (player.rollsRemaining == 0) return true;

    // Calculate current best score
    final availableCategories = ScoringCategory.values
        .where((cat) => player.scores[cat] == null)
        .toList();

    if (availableCategories.isEmpty) return true;

    int currentBestScore = 0;
    for (final category in availableCategories) {
      final score = calculateScore(player.dice, category);
      if (score > currentBestScore) {
        currentBestScore = score;
      }
    }

    // If current best score is high (>= 25), consider early selection
    // But also consider if we have a good pattern already
    final counts = _getDiceCounts(player.dice);
    final maxCount = counts.reduce((a, b) => a > b ? a : b);

    // Keep rolling if we have potential for yacht (4+ same)
    if (maxCount >= 4 && currentBestScore < 50) return false;

    // Keep rolling if we have good straight potential
    final uniqueSorted = player.dice.toSet().toList()..sort();
    if (uniqueSorted.length >= 4 && currentBestScore < 30) {
      // Check for straight potential
      int consecutive = 1;
      for (int i = 1; i < uniqueSorted.length; i++) {
        if (uniqueSorted[i] == uniqueSorted[i - 1] + 1) {
          consecutive++;
        } else {
          consecutive = 1;
        }
      }
      if (consecutive >= 4 && currentBestScore < 40) return false;
    }

    // If we have a very good score, take it
    if (currentBestScore >= 40) return true;

    // Otherwise, use expected value calculation
    final expectedValue = _calculateExpectedValueAfterReroll(
      player: player,
      state: state,
      depth: 0,
    );

    // Select now if current best is better than expected value from rerolling
    return currentBestScore >= expectedValue;
  }

  /// Expectimax: Choose action that maximizes expected value
  AiDecision _expectimaxDecision({
    required PlayerState player,
    required YachtDiceState state,
  }) {
    // If last roll, must keep all and select category
    if (player.rollsRemaining <= 1) {
      return const AiDecision(
        diceToKeep: [true, true, true, true, true],
        categoryToSelect: null,
      );
    }

    // Generate all possible keep combinations (32 possibilities)
    final keepCombinations = _generateKeepCombinations();

    double bestValue = double.negativeInfinity;
    List<bool> bestKeep = List.filled(5, true);

    for (final keep in keepCombinations) {
      final numDiceToReroll = keep.where((k) => !k).length;
      if (numDiceToReroll == 0)
        continue; // Skip keeping all (will select category)

      final expectedValue = _calculateExpectedValueForKeep(
        player: player,
        state: state,
        keep: keep,
        depth: 0,
      );

      if (expectedValue > bestValue) {
        bestValue = expectedValue;
        bestKeep = keep;
      }
    }

    // If no good reroll option found, keep all dice
    if (bestValue == double.negativeInfinity) {
      return const AiDecision(
        diceToKeep: [true, true, true, true, true],
        categoryToSelect: null,
      );
    }

    return AiDecision(diceToKeep: bestKeep, categoryToSelect: null);
  }

  /// Calculate expected value for a specific keep decision
  double _calculateExpectedValueForKeep({
    required PlayerState player,
    required YachtDiceState state,
    required List<bool> keep,
    required int depth,
  }) {
    if (depth >= _maxDepth) {
      return _evaluateState(player: player, state: state);
    }

    final numDiceToReroll = keep.where((k) => !k).length;
    if (numDiceToReroll == 0) {
      return _evaluateState(player: player, state: state);
    }

    // Sample a subset of possible outcomes for efficiency
    final numSamples = numDiceToReroll <= 2
        ? 36
        : 6; // 6^2 = 36, or just 6 samples
    var totalExpectedValue = 0.0;

    for (var sample = 0; sample < numSamples; sample++) {
      // Generate random outcome for rerolled dice
      final newDice = List<int>.from(player.dice);
      for (var i = 0; i < 5; i++) {
        if (!keep[i]) {
          newDice[i] = _random.nextInt(6) + 1;
        }
      }

      final newPlayer = player.copyWith(
        dice: newDice,
        rollsRemaining: player.rollsRemaining - 1,
      );

      // Recursively evaluate
      double outcomeValue;
      if (newPlayer.rollsRemaining > 0 && depth + 1 < _maxDepth) {
        // Try to find best keep for next roll
        outcomeValue = _findBestKeepValue(
          player: newPlayer,
          state: state,
          depth: depth + 1,
        );
      } else {
        outcomeValue = _evaluateState(player: newPlayer, state: state);
      }

      totalExpectedValue += outcomeValue;
    }

    return totalExpectedValue / numSamples;
  }

  /// Calculate expected value after a reroll (for early selection decision)
  double _calculateExpectedValueAfterReroll({
    required PlayerState player,
    required YachtDiceState state,
    required int depth,
  }) {
    if (depth >= _maxDepth || player.rollsRemaining == 0) {
      return _evaluateState(player: player, state: state);
    }

    // Sample outcomes
    const numSamples = 10;
    var totalExpectedValue = 0.0;

    for (var sample = 0; sample < numSamples; sample++) {
      // Simulate a random reroll of some dice
      final newDice = List<int>.from(player.dice);
      // Reroll dice that are not in a good pattern
      final counts = _getDiceCounts(player.dice);
      for (var i = 0; i < 5; i++) {
        final count = counts[player.dice[i] - 1];
        if (count <= 1 && _random.nextDouble() < 0.5) {
          newDice[i] = _random.nextInt(6) + 1;
        }
      }

      final newPlayer = player.copyWith(
        dice: newDice,
        rollsRemaining: player.rollsRemaining - 1,
      );

      totalExpectedValue += _evaluateState(player: newPlayer, state: state);
    }

    return totalExpectedValue / numSamples;
  }

  /// Find the best keep value for the next roll
  double _findBestKeepValue({
    required PlayerState player,
    required YachtDiceState state,
    required int depth,
  }) {
    final keepCombinations = _generateKeepCombinations();
    double maxValue = double.negativeInfinity;

    for (final keep in keepCombinations) {
      final numDiceToReroll = keep.where((k) => !k).length;
      if (numDiceToReroll == 0) continue;

      final value = _calculateExpectedValueForKeep(
        player: player,
        state: state,
        keep: keep,
        depth: depth,
      );

      if (value > maxValue) {
        maxValue = value;
      }
    }

    return maxValue == double.negativeInfinity
        ? _evaluateState(player: player, state: state)
        : maxValue;
  }

  /// Evaluate the current state (what score can we expect)
  double _evaluateState({
    required PlayerState player,
    required YachtDiceState state,
  }) {
    final availableCategories = ScoringCategory.values
        .where((cat) => player.scores[cat] == null)
        .toList();

    if (availableCategories.isEmpty) return 0;

    double bestValue = 0;

    for (final category in availableCategories) {
      final score = calculateScore(player.dice, category).toDouble();
      final potential = _getCategoryPotential(category).toDouble();

      // Consider upper section bonus progress
      double bonusPotential = 0;
      if (_isUpperSection(category)) {
        bonusPotential = _calculateBonusPotential(
          player: player,
          category: category,
          score: score.toInt(),
        );
      }

      // Weight by category potential and bonus potential
      final totalValue = score + potential * 0.05 + bonusPotential;

      if (totalValue > bestValue) {
        bestValue = totalValue;
      }
    }

    return bestValue;
  }

  /// Select the best category for scoring
  AiDecision _selectBestCategory(PlayerState player, YachtDiceState state) {
    final availableCategories = ScoringCategory.values
        .where((category) => player.scores[category] == null)
        .toList();

    if (availableCategories.isEmpty) {
      return const AiDecision(diceToKeep: [false, false, false, false, false]);
    }

    ScoringCategory bestCategory = availableCategories[0];
    double bestValue = double.negativeInfinity;

    for (final category in availableCategories) {
      final score = calculateScore(player.dice, category).toDouble();
      final potential = _getCategoryPotential(category).toDouble();

      // Consider upper section bonus progress
      double bonusPotential = 0;
      if (_isUpperSection(category)) {
        bonusPotential = _calculateBonusPotential(
          player: player,
          category: category,
          score: score.toInt(),
        );
      }

      // Weighted scoring: actual score + potential consideration + bonus
      final totalValue = score + potential * 0.05 + bonusPotential;

      if (totalValue > bestValue) {
        bestValue = totalValue;
        bestCategory = category;
      }
    }

    return AiDecision(
      diceToKeep: [true, true, true, true, true],
      categoryToSelect: bestCategory,
    );
  }

  /// Calculate how this score contributes to 63-point bonus
  double _calculateBonusPotential({
    required PlayerState player,
    required ScoringCategory category,
    required int score,
  }) {
    final currentUpperSum =
        [
              ScoringCategory.ones,
              ScoringCategory.twos,
              ScoringCategory.threes,
              ScoringCategory.fours,
              ScoringCategory.fives,
              ScoringCategory.sixes,
            ]
            .map((cat) => cat == category ? score : (player.scores[cat] ?? 0))
            .reduce((a, b) => a + b);

    if (currentUpperSum >= 63) return 35; // Already has bonus
    if (currentUpperSum + 63 - currentUpperSum >= 63) {
      return (currentUpperSum / 63) * 35; // Progress toward bonus
    }
    return 0;
  }

  bool _isUpperSection(ScoringCategory category) {
    return category == ScoringCategory.ones ||
        category == ScoringCategory.twos ||
        category == ScoringCategory.threes ||
        category == ScoringCategory.fours ||
        category == ScoringCategory.fives ||
        category == ScoringCategory.sixes;
  }

  /// Generate all 32 keep combinations (2^5)
  List<List<bool>> _generateKeepCombinations() {
    final combinations = <List<bool>>[];
    for (var mask = 0; mask < 32; mask++) {
      final keep = List<bool>.generate(5, (i) => (mask >> i) & 1 == 1);
      combinations.add(keep);
    }
    return combinations;
  }

  /// Count occurrences of each die value
  List<int> _getDiceCounts(List<int> dice) {
    final counts = List.filled(6, 0);
    for (final die in dice) {
      counts[die - 1]++;
    }
    return counts;
  }

  /// Get category potential (maximum possible score)
  int _getCategoryPotential(ScoringCategory category) {
    switch (category) {
      case ScoringCategory.yacht:
        return 50;
      case ScoringCategory.largeStraight:
        return 40;
      case ScoringCategory.smallStraight:
        return 30;
      case ScoringCategory.fourOfAKind:
        return 30; // Max is 30 (6*5=30)
      case ScoringCategory.fullHouse:
        return 25;
      case ScoringCategory.allSelect:
        return 30; // Max is 30 (6*5=30)
      case ScoringCategory.sixes:
        return 30; // 6*5=30
      case ScoringCategory.fives:
        return 25; // 5*5=25
      case ScoringCategory.fours:
        return 20; // 4*5=20
      case ScoringCategory.threes:
        return 15; // 3*5=15
      case ScoringCategory.twos:
        return 10; // 2*5=10
      case ScoringCategory.ones:
        return 5; // 1*5=5
    }
  }
}
