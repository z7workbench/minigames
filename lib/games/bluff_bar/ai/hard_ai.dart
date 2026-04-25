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
  
  HardBluffBarAi() : super(name: 'Hard', difficulty: AiDifficulty.hard);
  
  @override
  void recordPlayedCards(PlayedCards play) {
    _playHistory.add(play);
    for (final card in play.cards) {
      _playedCardCounts[card.rank] = (_playedCardCounts[card.rank] ?? 0) + 1;
    }
  }
  
  @override
  void resetForNewRound() {
    _playHistory.clear();
    _playedCardCounts.clear();
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
    
    final challengeProb = _estimateChallengeProbability(state);
    
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
    
    // Strategy 2: Pure bluff when have target cards but low challenge risk
    // CRITICAL: Don't mix target cards with bluff cards!
    if (targetCards.isNotEmpty && challengeProb < 0.3 && bluffCards.isNotEmpty) {
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
      return AiChallengeDecision(shouldChallenge: false);
    }

    final claimedCount = state.lastPlayedCards!.count;
    final targetRank = state.targetCard!;

    // Bayesian probability calculation
    // Total in deck = 5 per rank + 4 jokers
    final alreadyPlayed = _playedCardCounts[targetRank] ?? 0;
    final remaining = 5 - alreadyPlayed + 4; // 5 target cards + 4 jokers
    
    final opponentHand = state.players[state.lastPlayerIndex!].hand.length;
    
    // Probability that claim is valid
    double probValid = _calculateClaimProbability(
      claimedCount: claimedCount,
      remaining: remaining,
      opponentHandSize: opponentHand,
    );
    
    // Challenge if probability < 20%
    if (probValid < 0.2) {
      return AiChallengeDecision(
        shouldChallenge: true,
        reasoning: 'Low probability claim (${(probValid * 100).toStringAsFixed(1)}%)',
      );
    }
    
    // Consider roulette risk
    final myRouletteCards = state.currentPlayer.rouletteDeck.remainingCards;
    if (myRouletteCards <= 2 && probValid < 0.4) {
      // High roulette risk, must challenge
      return AiChallengeDecision(
        shouldChallenge: true,
        reasoning: 'High roulette risk',
      );
    }
    
    return AiChallengeDecision(shouldChallenge: false);
  }
  
  double _calculateClaimProbability({
    required int claimedCount,
    required int remaining,
    required int opponentHandSize,
  }) {
    if (claimedCount <= remaining) return 1.0;
    if (claimedCount > remaining + opponentHandSize) return 0.0;
    
    // Linear interpolation
    final excess = claimedCount - remaining;
    return 1.0 - (excess / opponentHandSize);
  }
  
  double _estimateChallengeProbability(BluffBarState state) {
    // Estimate based on opponent's recent challenges
    final recentChallenges = _playHistory
        .where((p) => p.cards.length > 2) // Large claims more suspicious
        .length;
    return min(0.5, recentChallenges * 0.1);
  }
}