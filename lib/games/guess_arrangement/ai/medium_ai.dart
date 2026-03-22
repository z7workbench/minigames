import 'dart:math';

import '../models/guess_arrangement_state.dart';

import 'guess_ai.dart';

/// Medium AI that uses logical deduction and pattern recognition.
/// Only guesses rank values, not suits.
class MediumAi extends GuessAi {
  final Random _random = Random();

  @override
  Future<AiDecision> decide(GuessArrangementState state) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final opponent = state.opponentPlayer;
    final hiddenPositions = opponent.hand.hiddenPositions;

    if (hiddenPositions.isEmpty) {
      throw StateError('No hidden positions to guess');
    }

    // Build knowledge of known ranks
    final knownRanks = _getKnownRanks(state);

    // Build wrong guesses for each position (by rank)
    final wrongGuesses = _getWrongGuesses(state);

    // Calculate probability for each possible rank at each hidden position
    final position = _selectBestPosition(hiddenPositions, opponent);

    // Get the most likely rank for this position
    final guessedRankValue = _guessMostLikelyRank(
      position: position,
      totalCards: opponent.hand.length,
      knownRanks: knownRanks,
      wrongGuesses: wrongGuesses[position] ?? {},
    );

    return AiDecision(position: position, guessedRankValue: guessedRankValue);
  }

  /// Get all ranks that are known (revealed) from both hands
  Set<int> _getKnownRanks(GuessArrangementState state) {
    final known = <int>{};

    // Add all revealed cards' ranks from opponent's hand
    for (final card in state.opponentPlayer.hand.cards) {
      if (card.isRevealed) {
        known.add(card.rank.value);
      }
    }

    // Add all revealed cards' ranks from AI's hand
    for (final card in state.currentPlayer.hand.cards) {
      if (card.isRevealed) {
        known.add(card.rank.value);
      }
    }

    return known;
  }

  /// Get wrong guesses grouped by position (only rank values)
  Map<int, Set<int>> _getWrongGuesses(GuessArrangementState state) {
    final wrongGuesses = <int, Set<int>>{};

    for (final record in state.currentPlayer.guessHistory) {
      if (!record.wasCorrect) {
        wrongGuesses.putIfAbsent(record.position, () => {});
        wrongGuesses[record.position]!.add(record.guessedCard.rank.value);
      }
    }

    return wrongGuesses;
  }

  /// Select the best position to guess based on heuristics
  int _selectBestPosition(List<int> hiddenPositions, GuessPlayer opponent) {
    int? bestPosition;
    int bestScore = -1;

    for (final pos in hiddenPositions) {
      int score = 0;

      // Check neighbors for revealed cards
      if (pos > 0 && opponent.hand.isPositionRevealed(pos - 1)) {
        score += 2;
        final neighborCard = opponent.hand.cardAt(pos - 1);
        if (neighborCard != null && neighborCard.rank.value < 10) {
          score += 1;
        }
      }
      if (pos < opponent.hand.length - 1 &&
          opponent.hand.isPositionRevealed(pos + 1)) {
        score += 2;
        final neighborCard = opponent.hand.cardAt(pos + 1);
        if (neighborCard != null && neighborCard.rank.value > 4) {
          score += 1;
        }
      }

      // Slight preference for middle positions
      final middleBias = 7 - (pos - 3.5).abs();
      score += middleBias.toInt();

      if (score > bestScore) {
        bestScore = score;
        bestPosition = pos;
      }
    }

    return bestPosition ?? hiddenPositions.first;
  }

  /// Guess the most likely rank for a position
  int _guessMostLikelyRank({
    required int position,
    required int totalCards,
    required Set<int> knownRanks,
    required Set<int> wrongGuesses,
  }) {
    // Calculate expected rank based on position
    // Cards are sorted low to high, so position hints at rank
    final expectedRankValue = ((position + 1) / totalCards * 13).round().clamp(
      1,
      13,
    );

    // Generate candidates around expected rank
    final candidates = <int>[];

    for (
      var rankValue = max(1, expectedRankValue - 2);
      rankValue <= min(13, expectedRankValue + 2);
      rankValue++
    ) {
      // Skip if already guessed wrong at this position
      if (!wrongGuesses.contains(rankValue)) {
        candidates.add(rankValue);
      }
    }

    if (candidates.isEmpty) {
      // Fallback: any rank not in wrong guesses
      for (var rankValue = 1; rankValue <= 13; rankValue++) {
        if (!wrongGuesses.contains(rankValue)) {
          candidates.add(rankValue);
        }
      }
    }

    if (candidates.isEmpty) {
      // Last resort: any random rank
      return _random.nextInt(13) + 1;
    }

    // Sort by distance to expected rank
    candidates.sort((a, b) {
      final aDiff = (a - expectedRankValue).abs();
      final bDiff = (b - expectedRankValue).abs();
      return aDiff.compareTo(bDiff);
    });

    // 60% chance to pick from top 3 candidates
    if (_random.nextDouble() < 0.6 && candidates.length > 3) {
      return candidates[_random.nextInt(3)];
    }

    return candidates[_random.nextInt(candidates.length)];
  }
}
