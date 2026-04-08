import 'dart:math';
import '../../guess_arrangement/models/playing_card.dart';
import '../models/hearts_state.dart';
import '../models/enums.dart';
import '../logic/hearts_rules.dart';
import '../utils/card_utils.dart';
import './hearts_ai.dart';
import './ai_decision.dart';

/// Hard AI for Hearts - Monte Carlo simulation
class HardHeartsAi extends HeartsAi {
  final int simulationCount;
  final Random _random = Random();

  HardHeartsAi({this.simulationCount = 1000})
    : super(name: 'Hard AI', difficulty: AiDifficulty.hard);

  @override
  Future<AiPlayDecision> decidePlay(HeartsState state) async {
    final player = state.currentPlayer;
    final legalCards = HeartsRules.getLegalCards(player, state);

    if (legalCards.isEmpty) {
      throw StateError('No legal cards available');
    }

    if (legalCards.length == 1) {
      return AiPlayDecision(
        card: legalCards.first,
        delayMs: minDelay + _random.nextInt(maxDelay - minDelay),
        reasoning: 'Only legal card',
      );
    }

    // Check for moon shooting opportunity
    final moonDecision = analyzeMoonAttempt(state);
    if (moonDecision.shouldAttempt && moonDecision.probability > 0.6) {
      return _playForMoonShot(legalCards, state);
    }

    // Monte Carlo simulation for each legal card
    final results = <PlayingCard, _SimulationResult>{};

    for (final card in legalCards) {
      results[card] = await _simulateCard(card, state);
    }

    // Select best card
    final bestEntry = results.entries.reduce((a, b) {
      final aScore = a.value.expectedScore;
      final bScore = b.value.expectedScore;
      return aScore < bScore ? a : b; // Lower is better
    });

    return AiPlayDecision(
      card: bestEntry.key,
      delayMs: minDelay + _random.nextInt(maxDelay - minDelay),
      reasoning:
          'MC result: ${bestEntry.value.expectedScore.toStringAsFixed(1)} avg points',
    );
  }

  /// Simulate playing a card and estimate outcome
  Future<_SimulationResult> _simulateCard(
    PlayingCard card,
    HeartsState state,
  ) async {
    final results = <int>[];

    for (int i = 0; i < simulationCount; i++) {
      // Create determinization
      final determinization = _createDeterminization(state);

      // Play the card
      var simState = _playCardInSimulation(determinization, card);

      // Simulate remaining tricks
      final finalScore = _simulateRemainingGame(simState);
      results.add(finalScore);
    }

    // Calculate statistics
    final avgScore = results.reduce((a, b) => a + b) / results.length;
    final worstCase = results.reduce((a, b) => a > b ? a : b);
    final bestCase = results.reduce((a, b) => a < b ? a : b);

    return _SimulationResult(
      expectedScore: avgScore,
      worstCase: worstCase,
      bestCase: bestCase,
      simulations: simulationCount,
    );
  }

  /// Create a determinization (guess at hidden cards)
  HeartsState _createDeterminization(HeartsState state) {
    // For simplicity, return current state
    // A full implementation would assign unknown cards probabilistically
    return state;
  }

  /// Play a card in simulation (simplified)
  HeartsState _playCardInSimulation(HeartsState state, PlayingCard card) {
    // Simplified: just return state with card played
    // Real implementation would update trick, check for completion, etc.
    return state;
  }

  /// Simulate remaining game with heuristic play
  int _simulateRemainingGame(HeartsState state) {
    // Simplified: use current round score as estimate
    // Real implementation would play out remaining tricks
    return state.currentPlayer.roundScore;
  }

  /// Play aggressively for moon shot
  AiPlayDecision _playForMoonShot(
    List<PlayingCard> legalCards,
    HeartsState state,
  ) {
    // Play highest cards to win tricks
    final sorted = List<PlayingCard>.from(legalCards)
      ..sort((a, b) => CardUtils.getHeartsRankValue(b.rank).compareTo(CardUtils.getHeartsRankValue(a.rank)));

    return AiPlayDecision(
      card: sorted.first,
      delayMs: minDelay + _random.nextInt(maxDelay - minDelay),
      reasoning: 'Moon shot attempt',
    );
  }

  @override
  Future<AiPassDecision> decidePass(
    List<PlayingCard> hand,
    PassDirection direction,
  ) async {
    // Use simulation to find best pass combination
    final combinations = _generatePassCombinations(hand);

    _PassCombination? bestCombo;
    double bestScore = double.infinity;

    for (final combo in combinations) {
      final score = _evaluatePassCombination(combo, hand);
      if (score < bestScore) {
        bestScore = score;
        bestCombo = combo;
      }
    }

    return AiPassDecision(
      cardsToPass: bestCombo?.cards ?? hand.take(3).toList(),
      delayMs: minDelay + _random.nextInt(maxDelay - minDelay),
      reasoning: 'Optimal pass (score: ${bestScore.toStringAsFixed(1)})',
    );
  }

  /// Generate all 3-card combinations
  List<_PassCombination> _generatePassCombinations(List<PlayingCard> hand) {
    final combinations = <_PassCombination>[];

    for (int i = 0; i < hand.length; i++) {
      for (int j = i + 1; j < hand.length; j++) {
        for (int k = j + 1; k < hand.length; k++) {
          combinations.add(
            _PassCombination(cards: [hand[i], hand[j], hand[k]]),
          );
        }
      }
    }

    return combinations;
  }

  /// Evaluate a pass combination
  double _evaluatePassCombination(
    _PassCombination combo,
    List<PlayingCard> fullHand,
  ) {
    double score = 0;

    // Passing Q♠ is excellent
    if (combo.cards.any((c) => CardUtils.isQueenOfSpades(c))) {
      score -= 50;
    }

    // Passing high hearts is good
    for (final card in combo.cards) {
      if (card.suit == CardSuit.hearts) {
        score -= CardUtils.getHeartsRankValue(card.rank) * 2;
      }
    }

    // Passing high spades (danger of Q♠) is good
    for (final card in combo.cards) {
      if (card.suit == CardSuit.spades && CardUtils.getHeartsRankValue(card.rank) >= 12) {
        score -= 10;
      }
    }

    // Voids are valuable
    final remaining = List<PlayingCard>.from(fullHand)
      ..removeWhere((c) => combo.cards.contains(c));

    for (final suit in CardSuit.values) {
      if (CardUtils.countCardsOfSuit(remaining, suit) == 0) {
        score -= 15;
      }
    }

    return score;
  }

  @override
  MoonDecision analyzeMoonAttempt(HeartsState state) {
    final player = state.currentPlayer;
    final roundScore = player.roundScore;

    // More aggressive moon detection
    if (roundScore >= 10) {
      // Calculate probability based on remaining cards
      final probability = _calculateMoonProbability(state);

      return MoonDecision(
        shouldAttempt: probability > 0.4,
        probability: probability,
        reasoning:
            'Moon probability: ${(probability * 100).toStringAsFixed(0)}%',
      );
    }

    return const MoonDecision(
      shouldAttempt: false,
      probability: 0.0,
      reasoning: 'Not viable for moon shot',
    );
  }

  /// Calculate probability of successful moon shot
  double _calculateMoonProbability(HeartsState state) {
    final player = state.currentPlayer;

    // Factors:
    // 1. Current penalty cards taken
    // 2. Remaining penalty cards in hand
    // 3. Number of tricks remaining

    final heartsTaken = player.tricksWon
        .where((c) => c.suit == CardSuit.hearts)
        .length;
    final hasQSpades = player.tricksWon.any(
      (c) => CardUtils.isQueenOfSpades(c),
    );

    final heartsInHand = player.hand
        .where((c) => c.suit == CardSuit.hearts)
        .length;
    final hasQSpadesInHand = player.hand.any(
      (c) => CardUtils.isQueenOfSpades(c),
    );

    // Base probability
    double probability = 0;

    if (heartsTaken + heartsInHand >= 13) {
      probability += 0.3;
    }

    if (hasQSpades || hasQSpadesInHand) {
      probability += 0.3;
    }

    // Bonus for having control (high cards in multiple suits)
    final highCards = player.hand.where((c) => CardUtils.getHeartsRankValue(c.rank) >= 12).length;
    probability += highCards * 0.05;

    return probability.clamp(0.0, 1.0);
  }
}

/// Simulation result
class _SimulationResult {
  final double expectedScore;
  final int worstCase;
  final int bestCase;
  final int simulations;

  _SimulationResult({
    required this.expectedScore,
    required this.worstCase,
    required this.bestCase,
    required this.simulations,
  });
}

/// Pass combination
class _PassCombination {
  final List<PlayingCard> cards;

  _PassCombination({required this.cards});
}
