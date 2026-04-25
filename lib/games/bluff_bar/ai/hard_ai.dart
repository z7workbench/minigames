import 'dart:math';
import '../models/bluff_bar_state.dart';
import '../models/enums.dart';
import '../../guess_arrangement/models/playing_card.dart';
import '../logic/bluff_bar_rules.dart';
import 'bluff_bar_ai.dart';
import 'ai_decision.dart';

class HardBluffBarAi extends BluffBarAi {
  final Random _random = Random();
  final List<PlayedCards> _playHistory = [];
  final Map<CardRank, int> _playedCardCounts = {};
  int _playedJokerCount = 0; // Track Joker cards separately
  
  // Opponent behavior tracking
  final Map<int, List<PlayedCards>> _playerPlayHistory = {}; // Per-player play history
  final Map<int, int> _playerBluffCount = {}; // How many times each player bluffed
  final Map<int, int> _playerTruthfulCount = {}; // How many times each player played truthfully
  final Map<int, int> _playerChallengeCount = {}; // How many times each player challenged
  final Map<int, int> _playerChallengeSuccessCount = {}; // Successful challenges
  
  // Deck constants for Bluff Bar
  static const int _totalDeckSize = 24; // 5×J/Q/K/A + 4 Jokers
  static const int _cardsPerRank = 5; // J/Q/K/A each have 5 cards
  static const int _jokerCount = 4; // 4 Jokers
  
  HardBluffBarAi() : super(
    name: 'Hard',
    difficulty: AiDifficulty.hard,
    aggressionFactor: 0.7, // More aggressive - challenges more often
  );
  
  @override
  void recordPlayedCards(PlayedCards play) {
    _playHistory.add(play);
    for (final card in play.cards) {
      if (isJoker(card)) {
        _playedJokerCount++;
      } else {
        _playedCardCounts[card.rank] = (_playedCardCounts[card.rank] ?? 0) + 1;
      }
    }
    
    // Track per-player behavior
    final playerIndex = play.playerIndex;
    _playerPlayHistory[playerIndex] = (_playerPlayHistory[playerIndex] ?? [])..add(play);
    
    if (play.isLie) {
      _playerBluffCount[playerIndex] = (_playerBluffCount[playerIndex] ?? 0) + 1;
    } else {
      _playerTruthfulCount[playerIndex] = (_playerTruthfulCount[playerIndex] ?? 0) + 1;
    }
  }
  
  /// Record a challenge event (called when a challenge occurs)
  void recordChallenge(int challengerIndex, bool successful) {
    _playerChallengeCount[challengerIndex] = (_playerChallengeCount[challengerIndex] ?? 0) + 1;
    if (successful) {
      _playerChallengeSuccessCount[challengerIndex] = (_playerChallengeSuccessCount[challengerIndex] ?? 0) + 1;
    }
  }
  
  @override
  void resetForNewRound() {
    _playHistory.clear();
    _playedCardCounts.clear();
    _playedJokerCount = 0;
    // Keep player behavior history for multi-round analysis
  }
  
  @override
  Future<AiPlayDecision> decidePlay(BluffBarState state) async {
    final player = state.currentPlayer;
    final targetRank = state.targetCard!;

    // Separate cards into categories
    final targetCards = player.hand.where((c) => c.rank == targetRank).toList();
    final jokers = player.hand.where((c) => isJoker(c)).toList();
    final bluffCards = player.hand.where((c) => 
        c.rank != targetRank && !isJoker(c)).toList();
    
    // Valid cards for truthful play: target + jokers
    final validCards = [...targetCards, ...jokers];
    
    // Strategy 1: Strong truthful play (have many valid cards)
    if (validCards.length >= 3) {
      final numToPlay = min(validCards.length, 3 + _random.nextInt(2));
      return AiPlayDecision(
        cardIndices: validCards.take(numToPlay)
            .map((c) => player.hand.indexOf(c))
            .toList(),
        claimedRank: targetRank,
        delayMs: getRandomDelay(),
      );
    }
    
    // Strategy 2: Pure bluff when have target cards but moderate hand
    // Higher aggression = more likely to bluff
    // CRITICAL: Don't mix target cards with bluff cards!
    if (targetCards.isNotEmpty && bluffCards.isNotEmpty && _random.nextDouble() < aggressionFactor) {
      final numToPlay = min(2, bluffCards.length);
      return AiPlayDecision(
        cardIndices: bluffCards.take(numToPlay)
            .map((c) => player.hand.indexOf(c))
            .toList(),
        claimedRank: targetRank,
        delayMs: getRandomDelay(),
      );
    }
    
    // Strategy 3: Play truthfully when have target/joker cards
    if (validCards.isNotEmpty) {
      final numToPlay = min(2, validCards.length);
      return AiPlayDecision(
        cardIndices: validCards.take(numToPlay)
            .map((c) => player.hand.indexOf(c))
            .toList(),
        claimedRank: targetRank,
        delayMs: getRandomDelay(),
      );
    }
    
    // Strategy 4: Pure bluff (no target/joker cards in hand)
    if (bluffCards.isNotEmpty) {
      final numToPlay = min(2, bluffCards.length);
      return AiPlayDecision(
        cardIndices: bluffCards.take(numToPlay)
            .map((c) => player.hand.indexOf(c))
            .toList(),
        claimedRank: targetRank,
        delayMs: getRandomDelay(),
      );
    }
    
    // Fallback: play 1 card
    if (player.hand.isNotEmpty) {
      return AiPlayDecision(
        cardIndices: [0],
        claimedRank: targetRank,
        delayMs: getRandomDelay(),
      );
    }
    
    return AiPlayDecision(cardIndices: [], claimedRank: targetRank);
  }
  
@override
  Future<AiChallengeDecision> decideChallenge(BluffBarState state) async {
    if (state.lastPlayedCards == null || state.lastPlayerIndex == null) {
      return const AiChallengeDecision(shouldChallenge: false);
    }

    final claimedCount = state.lastPlayedCards!.count;
    final targetRank = state.targetCard!;
    final opponentIndex = state.lastPlayerIndex!;
    
    // === Step 1: Calculate remaining cards in deck ===
    final alreadyPlayedTarget = _playedCardCounts[targetRank] ?? 0;
    final remainingValid = (_cardsPerRank - alreadyPlayedTarget) + (_jokerCount - _playedJokerCount);
    
    // Calculate total cards remaining in deck
    final totalPlayed = _playedCardCounts.values.fold(0, (sum, count) => sum + count) + _playedJokerCount;
    final cardsInHands = state.players.fold(0, (sum, p) => sum + p.hand.length);
    final totalCardsRemaining = _totalDeckSize - totalPlayed - cardsInHands + state.players[opponentIndex].hand.length;
    
    final opponentHandSize = state.players[opponentIndex].hand.length;
    
    // === Step 2: Hypergeometric probability calculation ===
    final probValid = _calculateClaimProbabilityHypergeometric(
      claimedCount: claimedCount,
      remainingValidCards: remainingValid,
      opponentHandSize: opponentHandSize,
      totalCardsRemaining: totalCardsRemaining,
    );
    
    // === Step 3: Expected value calculation ===
    final myRouletteCards = state.currentPlayer.rouletteDeck.remainingCards;
    final opponentRouletteCards = state.players[opponentIndex].rouletteDeck.remainingCards;
    
    final expectedValue = _calculateChallengeExpectedValue(
      probBluffing: 1.0 - probValid,
      myRouletteCards: myRouletteCards,
      opponentRouletteCards: opponentRouletteCards,
    );
    
    // === Step 4: Behavior analysis adjustment ===
    final behaviorModifier = _analyzeOpponentBehavior(opponentIndex);
    
    // === Step 5: Aggression-adjusted thresholds ===
    // Higher aggression = lower thresholds = more challenges
    final baseThreshold = 0.15;
    final adjustedThreshold = baseThreshold * (1.0 - aggressionFactor);
    final behaviorAdjustedThreshold = adjustedThreshold - behaviorModifier * 0.1;
    
    final baseEvThreshold = 0.05;
    final adjustedEvThreshold = baseEvThreshold * (1.0 - aggressionFactor);
    
    // === Step 6: Decision logic ===
    
    // Case 1: Very low probability of valid claim
    if (probValid < behaviorAdjustedThreshold) {
      return AiChallengeDecision(
        shouldChallenge: true,
        reasoning: 'Low validity (${(probValid * 100).toStringAsFixed(1)}%), bluff rate ${(getPlayerBluffRate(opponentIndex) * 100).toStringAsFixed(0)}%',
      );
    }
    
    // Case 2: High roulette risk + moderate suspicion
    if (myRouletteCards <= 2 && probValid < 0.35) {
      return AiChallengeDecision(
        shouldChallenge: true,
        reasoning: 'High roulette risk ($myRouletteCards cards), suspicion ${(probValid * 100).toStringAsFixed(1)}%',
      );
    }
    
    // Case 3: Positive expected value
    if (expectedValue > adjustedEvThreshold + behaviorModifier * 0.02) {
      return AiChallengeDecision(
        shouldChallenge: true,
        reasoning: 'Positive EV (${expectedValue.toStringAsFixed(2)}), adjusted for behavior',
      );
    }
    
    // Case 4: Opponent under pressure (likely truthful)
    if (opponentRouletteCards <= 2 && probValid > 0.5) {
      return AiChallengeDecision(
        shouldChallenge: false,
        reasoning: 'Opponent pressured ($opponentRouletteCards cards), likely truthful',
      );
    }
    
    // Default: Don't challenge
    return AiChallengeDecision(
      shouldChallenge: false,
      reasoning: 'Insufficient evidence: ${(probValid * 100).toStringAsFixed(1)}% valid',
    );
  }
  
  /// Calculate binomial coefficient C(n, k)
  /// Used for hypergeometric distribution probability
  /// Returns double to handle large numbers without overflow
  double _binomialCoefficient(int n, int k) {
    if (k < 0 || k > n) return 0;
    if (k == 0 || k == n) return 1;
    
    // Optimize: C(n, k) = C(n, n-k)
    if (k > n - k) k = n - k;
    
    // Use multiplicative formula for better precision
    double result = 1.0;
    for (int i = 0; i < k; i++) {
      result *= (n - i) / (i + 1);
    }
    return result;
  }
  
  /// Hypergeometric distribution probability
  /// P(X=k) = C(K,k) * C(N-K, n-k) / C(N, n)
  /// 
  /// Parameters:
  /// - N: Total population size (total cards remaining)
  /// - K: Number of success states in population (target cards + jokers remaining)
  /// - n: Number of draws (opponent hand size)
  /// - k: Number of observed successes (claimed cards)
  double _hypergeometricProbability(int N, int K, int n, int k) {
    if (N <= 0 || K <= 0 || n <= 0 || k < 0) return 0.0;
    if (k > n || k > K || n > N) return 0.0;
    
    final cKk = _binomialCoefficient(K, k);
    final cNKnk = _binomialCoefficient(N - K, n - k);
    final cNn = _binomialCoefficient(N, n);
    
    return cKk * cNKnk / cNn;
  }
  
  /// Cumulative hypergeometric distribution (at least k successes)
  /// P(X ≥ k) = sum from i=k to min(K,n) of P(X=i)
  double _hypergeometricCumulativeAtLeast(int N, int K, int n, int k) {
    double probability = 0.0;
    final maxSuccesses = min(K, n);
    
    for (int i = k; i <= maxSuccesses; i++) {
      probability += _hypergeometricProbability(N, K, n, i);
    }
    
    return probability;
  }
  
  /// Calculate the probability that opponent has enough valid cards
  /// for their claim using hypergeometric distribution
  double _calculateClaimProbabilityHypergeometric({
    required int claimedCount,
    required int remainingValidCards,
    required int opponentHandSize,
    required int totalCardsRemaining,
  }) {
    // Claim is guaranteed valid if claimed ≤ remaining valid cards in deck
    if (claimedCount <= 0) return 1.0;
    if (claimedCount <= remainingValidCards) return 1.0;
    
    // Claim is impossible if opponent can't possibly have enough cards
    if (claimedCount > opponentHandSize) return 0.0;
    if (remainingValidCards == 0) return 0.0;
    
    // Use hypergeometric distribution:
    // P(opponent has at least claimedCount valid cards)
    return _hypergeometricCumulativeAtLeast(
      totalCardsRemaining,
      remainingValidCards,
      opponentHandSize,
      claimedCount,
    );
  }
  
  /// Calculate expected value of challenging
  /// EV = P(win) * (benefit) + P(lose) * (-cost)
  /// 
  /// Returns positive value if challenge is favorable
  double _calculateChallengeExpectedValue({
    required double probBluffing, // Probability opponent is bluffing
    required int myRouletteCards, // My remaining roulette cards
    required int opponentRouletteCards, // Opponent remaining roulette cards
  }) {
    // Probability of winning challenge = probability opponent is bluffing
    final probWin = probBluffing;
    final probLose = 1.0 - probWin;
    
    // Cost/Benefit weights
    // - Winning: opponent faces roulette (cost to them = 1/remainingCards)
    // - Losing: I face roulette (cost to me = 1/myRemainingCards)
    
    // Higher roulette risk = higher stakes
    final myRisk = myRouletteCards > 0 ? 1.0 / myRouletteCards : 0.0;
    final opponentRisk = opponentRouletteCards > 0 ? 1.0 / opponentRouletteCards : 0.0;
    
    // Expected value: positive = challenge is favorable
    final expectedValue = probWin * opponentRisk - probLose * myRisk;
    
    return expectedValue;
  }
  
  /// Get a player's bluff rate (how often they bluff vs. play truthfully)
  /// Returns 0.0 if no history, otherwise 0.0-1.0
  double getPlayerBluffRate(int playerIndex) {
    final bluffCount = _playerBluffCount[playerIndex] ?? 0;
    final truthfulCount = _playerTruthfulCount[playerIndex] ?? 0;
    final total = bluffCount + truthfulCount;
    
    if (total == 0) return 0.0; // No history
    return bluffCount / total;
  }
  
  /// Get a player's challenge success rate
  /// Returns 0.0 if no challenges, otherwise 0.0-1.0
  double getPlayerChallengeSuccessRate(int playerIndex) {
    final challengeCount = _playerChallengeCount[playerIndex] ?? 0;
    final successCount = _playerChallengeSuccessCount[playerIndex] ?? 0;
    
    if (challengeCount == 0) return 0.0; // No challenges
    return successCount / challengeCount;
  }
  
  /// Analyze opponent's recent behavior pattern
  /// Returns a behavior modifier to adjust challenge probability threshold
  double _analyzeOpponentBehavior(int opponentIndex) {
    final bluffRate = getPlayerBluffRate(opponentIndex);
    final challengeSuccessRate = getPlayerChallengeSuccessRate(opponentIndex);
    
    // High bluff rate opponent (> 40%) = more likely to bluff
    // Lower threshold for challenging (increase challenge probability)
    double bluffModifier = 0.0;
    if (bluffRate > 0.4) {
      bluffModifier = bluffRate - 0.4; // Positive modifier = more suspicion
    }
    
    // Low challenge success rate (< 30%) = player challenges impulsively
    // If they challenged me recently and failed, they're over-challenging
    // I should be more cautious about bluffing to them
    double challengeModifier = 0.0;
    if (challengeSuccessRate > 0 && challengeSuccessRate < 0.3) {
      challengeModifier = -(challengeSuccessRate - 0.3); // Negative = less suspicion
    }
    
    return bluffModifier + challengeModifier;
  }
}