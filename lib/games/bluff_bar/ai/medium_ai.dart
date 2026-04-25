import 'dart:math';
import '../models/bluff_bar_state.dart';
import '../models/enums.dart';
import '../../guess_arrangement/models/playing_card.dart';
import '../logic/bluff_bar_rules.dart';
import 'bluff_bar_ai.dart';
import 'ai_decision.dart';

class MediumBluffBarAi extends BluffBarAi {
  final Random _random = Random();
  final Map<CardRank, int> _playedCardCounts = {}; // Track played cards
  int _playedJokerCount = 0; // Track Joker cards separately
  
  // Deck constants
  static const int _cardsPerRank = 5;
  static const int _jokerCount = 4;
  
  MediumBluffBarAi() : super(
    name: 'Medium',
    difficulty: AiDifficulty.medium,
    aggressionFactor: 0.5, // Balanced - challenges moderately
  );
  
  /// Simplified probability calculation for Medium AI
  /// Uses basic card counting without hypergeometric distribution
  double _calculateSimpleProbability({
    required int claimedCount,
    required int remainingValid,
    required int opponentHandSize,
  }) {
    // If claim ≤ remaining valid cards, definitely valid
    if (claimedCount <= remainingValid) return 1.0;
    
    // If claim > remaining + opponent hand, definitely impossible
    if (claimedCount > remainingValid + opponentHandSize) return 0.0;
    
    // Simple estimation: probability = remaining / opponentHand
    // This is a rough approximation (not hypergeometric)
    final excess = claimedCount - remainingValid;
    final probability = 1.0 - (excess / (opponentHandSize + 1.0));
    
    return max(0.0, min(1.0, probability));
  }
  
  /// Simple expected value calculation for Medium AI
  /// Considers roulette risk but without detailed probability analysis
  double _calculateSimpleExpectedValue({
    required double probBluffing,
    required int myRouletteCards,
  }) {
    // Simple heuristic: higher roulette risk = more cautious
    final myRisk = myRouletteCards > 0 ? 1.0 / myRouletteCards : 0.0;
    
    // Expected value = probability of winning - my risk cost
    return probBluffing - myRisk * 0.5; // Simplified weighting
  }
  
  @override
  void recordPlayedCards(PlayedCards play) {
    for (final card in play.cards) {
      if (isJoker(card)) {
        _playedJokerCount++;
      } else {
        _playedCardCounts[card.rank] = (_playedCardCounts[card.rank] ?? 0) + 1;
      }
    }
  }
  
  @override
  void resetForNewRound() {
    _playedCardCounts.clear();
    _playedJokerCount = 0;
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

    // Strategy 1: Play truth (target cards + jokers)
    // But if aggressive, might bluff instead
    if (targetCards.length + jokers.length >= 2) {
      // Aggressive bluff: if we have target cards, bluff with bluff cards instead
      if (targetCards.isNotEmpty && bluffCards.isNotEmpty && _random.nextDouble() < aggressionFactor * 0.5) {
        final numToPlay = min(2, bluffCards.length);
        return AiPlayDecision(
          cardIndices: bluffCards.take(numToPlay)
              .map((c) => player.hand.indexOf(c))
              .toList(),
          claimedRank: targetRank,
          delayMs: getRandomDelay(),
        );
      }
      
      // Standard truthful play
      final toPlay = <PlayingCard>[];
      toPlay.addAll(targetCards.take(min(3, targetCards.length)));
      toPlay.addAll(jokers.take(min(1, jokers.length)));
      return AiPlayDecision(
        cardIndices: toPlay.map((c) => player.hand.indexOf(c)).toList(),
        claimedRank: targetRank,
        delayMs: getRandomDelay(),
      );
    }
    
    // Strategy 2: Pure bluff (only non-target, non-joker cards)
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
    
    // Fallback: Play available cards truthfully
    final validCards = [...targetCards, ...jokers];
    if (validCards.isNotEmpty) {
      return AiPlayDecision(
        cardIndices: [player.hand.indexOf(validCards.first)],
        claimedRank: targetRank,
        delayMs: getRandomDelay(),
      );
    }
    
    // Last resort: play 1 card
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
    
    // === Step 1: Calculate remaining valid cards ===
    final alreadyPlayedTarget = _playedCardCounts[targetRank] ?? 0;
    final remainingValid = (_cardsPerRank - alreadyPlayedTarget) + (_jokerCount - _playedJokerCount);
    
    final opponentHandSize = state.players[opponentIndex].hand.length;
    
    // === Step 2: Simplified probability calculation ===
    final probValid = _calculateSimpleProbability(
      claimedCount: claimedCount,
      remainingValid: remainingValid,
      opponentHandSize: opponentHandSize,
    );
    
    // === Step 3: Simple expected value ===
    final myRouletteCards = state.currentPlayer.rouletteDeck.remainingCards;
    final expectedValue = _calculateSimpleExpectedValue(
      probBluffing: 1.0 - probValid,
      myRouletteCards: myRouletteCards,
    );
    
    // === Step 4: Aggression-adjusted thresholds ===
    final baseThreshold = 0.25;
    final adjustedThreshold = baseThreshold * (1.0 - aggressionFactor);
    
    final baseEvThreshold = 0.1;
    final adjustedEvThreshold = baseEvThreshold * (1.0 - aggressionFactor);
    
    // === Step 5: Decision logic ===
    
    // Case 1: Very low probability (< adjusted threshold)
    if (probValid < adjustedThreshold) {
      return AiChallengeDecision(
        shouldChallenge: true,
        reasoning: 'Low probability (${(probValid * 100).toStringAsFixed(0)}%)',
      );
    }
    
    // Case 2: High roulette risk (few cards) + moderate suspicion
    if (myRouletteCards <= 2 && probValid < 0.40) {
      return AiChallengeDecision(
        shouldChallenge: true,
        reasoning: 'High risk ($myRouletteCards cards left)',
      );
    }
    
    // Case 3: Positive expected value (challenge favorable)
    if (expectedValue > adjustedEvThreshold) {
      return AiChallengeDecision(
        shouldChallenge: true,
        reasoning: 'Favorable challenge (EV=${expectedValue.toStringAsFixed(1)})',
      );
    }
    
    // Case 4: Opponent low on cards (might bluff desperately)
    if (opponentHandSize <= 2 && _random.nextDouble() < 0.30) {
      return AiChallengeDecision(
        shouldChallenge: true,
        reasoning: 'Opponent desperate ($opponentHandSize cards)',
      );
    }
    
    // Default: Don't challenge
    return AiChallengeDecision(
      shouldChallenge: false,
      reasoning: 'Probability ${(probValid * 100).toStringAsFixed(0)}%',
    );
  }
}