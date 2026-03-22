import 'dart:math';

import '../models/guess_arrangement_state.dart';

import 'guess_ai.dart';

/// Hard AI using heuristic search and probability analysis.
/// Only guesses rank values, not suits.
class HardAi extends GuessAi {
  final Random _random = Random();

  @override
  Future<AiDecision> decide(GuessArrangementState state) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final opponent = state.opponentPlayer;
    final hiddenPositions = opponent.hand.hiddenPositions;

    if (hiddenPositions.isEmpty) {
      throw StateError('No hidden positions to guess');
    }

    // Build comprehensive game knowledge
    final knowledge = _buildKnowledge(state);

    // Calculate probability distributions for each hidden position
    final distributions = _calculateDistributions(opponent, knowledge);

    // Select position with highest expected value
    final position = _selectOptimalPosition(
      hiddenPositions,
      distributions,
      opponent,
    );

    // Select the most likely rank for that position
    final guessedRankValue = _selectOptimalRank(
      position,
      distributions[position]!,
      knowledge,
    );

    return AiDecision(position: position, guessedRankValue: guessedRankValue);
  }

  /// Build comprehensive knowledge about the game state
  _GameKnowledge _buildKnowledge(GuessArrangementState state) {
    final knownRanks = <int, int>{}; // rankValue -> count (max 4)
    final wrongGuesses = <int, Set<int>>{}; // position -> wrong rankValues
    final revealedAtPosition = <int, int>{}; // position -> rankValue

    // Track revealed cards from opponent's hand
    for (var i = 0; i < state.opponentPlayer.hand.length; i++) {
      final card = state.opponentPlayer.hand.cardAt(i);
      if (card != null && state.opponentPlayer.hand.isPositionRevealed(i)) {
        revealedAtPosition[i] = card.rank.value;
        knownRanks[card.rank.value] = (knownRanks[card.rank.value] ?? 0) + 1;
      }
    }

    // Track AI's own cards' ranks
    for (final card in state.currentPlayer.hand.cards) {
      knownRanks[card.rank.value] = (knownRanks[card.rank.value] ?? 0) + 1;
    }

    // Track wrong guesses (by rank)
    for (final record in state.currentPlayer.guessHistory) {
      if (!record.wasCorrect) {
        wrongGuesses.putIfAbsent(record.position, () => {});
        wrongGuesses[record.position]!.add(record.guessedCard.rank.value);
      }
    }

    // Calculate remaining counts per rank (max 4 per rank in a deck)
    final remainingCounts = <int, int>{};
    for (var rank = 1; rank <= 13; rank++) {
      remainingCounts[rank] = 4 - (knownRanks[rank] ?? 0);
    }

    return _GameKnowledge(
      knownRanks: knownRanks,
      wrongGuesses: wrongGuesses,
      revealedAtPosition: revealedAtPosition,
      remainingCounts: remainingCounts,
    );
  }

  /// Calculate probability distribution for each hidden position
  Map<int, Map<int, double>> _calculateDistributions(
    GuessPlayer opponent,
    _GameKnowledge knowledge,
  ) {
    final distributions = <int, Map<int, double>>{};

    for (final position in opponent.hand.hiddenPositions) {
      distributions[position] = _calculatePositionDistribution(
        position: position,
        totalCards: opponent.hand.length,
        knowledge: knowledge,
      );
    }

    return distributions;
  }

  /// Calculate probability distribution for a specific position
  Map<int, double> _calculatePositionDistribution({
    required int position,
    required int totalCards,
    required _GameKnowledge knowledge,
  }) {
    final distribution = <int, double>{};

    // Calculate expected rank based on position (cards are sorted)
    final expectedRank = ((position + 0.5) / totalCards * 13).clamp(1.0, 13.0);

    // Get adjacent revealed cards for bounds
    int? minRank, maxRank;

    // Check revealed cards to the left (must be <= this card)
    for (var i = position - 1; i >= 0; i--) {
      final revealed = knowledge.revealedAtPosition[i];
      if (revealed != null) {
        minRank = revealed;
        break;
      }
    }

    // Check revealed cards to the right (must be >= this card)
    for (var i = position + 1; i < totalCards; i++) {
      final revealed = knowledge.revealedAtPosition[i];
      if (revealed != null) {
        maxRank = revealed;
        break;
      }
    }

    // Calculate probabilities
    final wrongSet = knowledge.wrongGuesses[position] ?? {};

    for (
      var rankValue = minRank ?? 1;
      rankValue <= (maxRank ?? 13);
      rankValue++
    ) {
      final remainingCount = knowledge.remainingCounts[rankValue] ?? 0;
      if (remainingCount <= 0) continue;

      // Skip if already guessed wrong at this position
      if (wrongSet.contains(rankValue)) continue;

      // Base probability from remaining count
      var probability = remainingCount / 4.0;

      // Adjust based on expected rank (Gaussian-like distribution)
      final rankDiff = (rankValue - expectedRank).abs();
      final rankBonus = exp(-rankDiff * rankDiff / 8);
      probability *= (0.3 + 0.7 * rankBonus);

      distribution[rankValue] = probability;
    }

    // Normalize probabilities
    final total = distribution.values.fold(0.0, (sum, p) => sum + p);
    if (total > 0) {
      for (final rank in distribution.keys) {
        distribution[rank] = distribution[rank]! / total;
      }
    }

    return distribution;
  }

  /// Select the optimal position to guess
  int _selectOptimalPosition(
    List<int> hiddenPositions,
    Map<int, Map<int, double>> distributions,
    GuessPlayer opponent,
  ) {
    double bestScore = double.negativeInfinity;
    int? bestPosition;

    for (final position in hiddenPositions) {
      final distribution = distributions[position] ?? {};

      if (distribution.isEmpty) continue;

      // Find highest probability in this distribution
      final maxProbability = distribution.values.fold(0.0, max);

      // Score = max probability * position strategic value
      var strategicValue = 1.0;

      if (position > 0 && opponent.hand.isPositionRevealed(position - 1)) {
        strategicValue *= 1.3;
      }
      if (position < opponent.hand.length - 1 &&
          opponent.hand.isPositionRevealed(position + 1)) {
        strategicValue *= 1.3;
      }

      final score = maxProbability * strategicValue;

      if (score > bestScore) {
        bestScore = score;
        bestPosition = position;
      }
    }

    return bestPosition ?? hiddenPositions.first;
  }

  /// Select the optimal rank to guess for a position
  int _selectOptimalRank(
    int position,
    Map<int, double> distribution,
    _GameKnowledge knowledge,
  ) {
    if (distribution.isEmpty) {
      // Fallback to random
      return _random.nextInt(13) + 1;
    }

    // Sort by probability (highest first)
    final sorted = distribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // 80% chance to pick the highest probability rank
    if (_random.nextDouble() < 0.8) {
      return sorted.first.key;
    }

    // 20% chance to pick from top 3
    final topCount = min(3, sorted.length);
    return sorted[_random.nextInt(topCount)].key;
  }
}

/// Internal class to hold game knowledge
class _GameKnowledge {
  final Map<int, int> knownRanks;
  final Map<int, Set<int>> wrongGuesses;
  final Map<int, int> revealedAtPosition;
  final Map<int, int> remainingCounts;

  _GameKnowledge({
    required this.knownRanks,
    required this.wrongGuesses,
    required this.revealedAtPosition,
    required this.remainingCounts,
  });
}
