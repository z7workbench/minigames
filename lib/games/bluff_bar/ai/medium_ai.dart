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
  
  MediumBluffBarAi() : super(name: 'Medium', difficulty: AiDifficulty.medium);
  
  @override
  void recordPlayedCards(PlayedCards play) {
    for (final card in play.cards) {
      _playedCardCounts[card.rank] = (_playedCardCounts[card.rank] ?? 0) + 1;
    }
  }
  
  @override
  void resetForNewRound() {
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

    // Strategy 1: Play truth (target cards + jokers)
    if (targetCards.length + jokers.length >= 2) {
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
      return AiChallengeDecision(shouldChallenge: false);
    }

    // Get claim count from last played cards
    final claimedCount = state.lastPlayedCards!.count;
    final targetRank = state.targetCard!;

    // Total in deck = 5 per rank + 4 jokers
    final alreadyPlayed = _playedCardCounts[targetRank] ?? 0;
    final remaining = 5 - alreadyPlayed + 4; // 5 target cards + 4 jokers
    
    // Challenge if claim exceeds probability
    if (claimedCount > remaining + 2) {
      return AiChallengeDecision(
        shouldChallenge: true,
        reasoning: 'Claim exceeds available cards',
      );
    }
    
    // 25% chance if opponent has few cards (might be desperate bluff)
    if (state.players[state.lastPlayerIndex!].hand.length <= 2) {
      return AiChallengeDecision(
        shouldChallenge: _random.nextDouble() < 0.25,
        reasoning: 'Opponent low on cards',
      );
    }

    return AiChallengeDecision(shouldChallenge: false);
  }
}