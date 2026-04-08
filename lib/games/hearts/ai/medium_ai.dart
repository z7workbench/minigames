// lib/games/hearts/ai/medium_ai.dart

import 'dart:math';
import '../../guess_arrangement/models/playing_card.dart';
import '../models/hearts_state.dart';
import '../models/hearts_player.dart';
import '../models/trick.dart';
import '../models/enums.dart';
import '../logic/hearts_rules.dart';
import '../utils/card_utils.dart';
import 'hearts_ai.dart';
import 'ai_decision.dart';

/// Medium AI for Hearts - Heuristics with card counting
class MediumHeartsAi extends HeartsAi {
  final Random _random = Random();

  MediumHeartsAi() : super(name: 'Medium AI', difficulty: AiDifficulty.medium);

  @override
  Future<AiPlayDecision> decidePlay(HeartsState state) async {
    final player = state.players[state.currentPlayerIndex];
    final legalCards = HeartsRules.getLegalCards(player, state);

    if (legalCards.isEmpty) {
      throw StateError('No legal cards available');
    }

    if (legalCards.length == 1) {
      return AiPlayDecision(
        card: legalCards.first,
        delayMs: minDelay,
        reasoning: 'Only legal card',
      );
    }

    // Check for moon shooting opportunity
    if (analyzeMoonAttempt(state).shouldAttempt && _random.nextDouble() < 0.3) {
      return _playForMoonShot(legalCards, state);
    }

    // Normal play: minimize danger
    return _playSafely(legalCards, state);
  }

  /// Play to minimize penalty points
  AiPlayDecision _playSafely(List<PlayingCard> legalCards, HeartsState state) {
    final player = state.players[state.currentPlayerIndex];
    // Score each card by danger
    final scoredCards = legalCards.map((card) {
      final danger = _calculateDanger(card, state);
      final voidBonus = _calculateVoidBonus(card, player);
      return _ScoredCard(card: card, score: danger - voidBonus);
    }).toList();

    scoredCards.sort((a, b) => a.score.compareTo(b.score));

    // 80% play safest card, 20% random from top 3
    final selected = _random.nextDouble() < 0.8
        ? scoredCards.first.card
        : scoredCards[_random.nextInt(
                scoredCards.length <= 3 ? scoredCards.length : 3,
              )]
              .card;

    return AiPlayDecision(
      card: selected,
      delayMs: getRandomDelay(),
      reasoning: 'Safest play (danger score: ${scoredCards.first.score})',
    );
  }

  /// Calculate danger score for a card (higher = more dangerous)
  double _calculateDanger(PlayingCard card, HeartsState state) {
    double danger = 0;
    final trick = state.currentTrick;
    final player = state.players[state.currentPlayerIndex];

    // Leading is generally safer (can control the trick)
    if (trick.cards.isEmpty) {
      return _calculateLeadDanger(card, state);
    }

    // Following: consider what might win
    final leadSuit = trick.leadSuit!;
    final mustFollow = CardUtils.hasCardsOfSuit(player.hand, leadSuit);

    if (mustFollow && card.suit == leadSuit) {
      // Following suit - check if we might win
      final currentHighest = _getCurrentHighest(trick);
      if (CardUtils.getHeartsRankValue(card.rank) > CardUtils.getHeartsRankValue(currentHighest.rank)) {
        // We would win - danger increases with trick penalty
        danger += HeartsRules.calculateTrickPenalty(trick) * 2;
      }

      // Playing high cards is risky
      danger += CardUtils.getHeartsRankValue(card.rank) * 0.3;
    } else if (!mustFollow) {
      // Can't follow - this is our chance to dump danger!
      // But don't dump too early if others might win

      // Dumping hearts is good, but only if trick already has penalty
      if (card.suit == CardSuit.hearts) {
        danger -= 5; // Negative danger = good
      }

      // Dumping Q♠ is excellent if we have it
      if (CardUtils.isQueenOfSpades(card)) {
        danger -= 15;
      }
    }

    return danger;
  }

  /// Calculate danger when leading
  double _calculateLeadDanger(PlayingCard card, HeartsState state) {
    double danger = 0;
    final player = state.players[state.currentPlayerIndex];

    // Leading high cards is risky
    danger += CardUtils.getHeartsRankValue(card.rank) * 0.5;

    // Leading penalty cards is very risky (unless hearts already broken)
    if (card.suit == CardSuit.hearts && !state.heartsBroken) {
      danger += 10;
    }

    // Leading Q♠ is extremely dangerous
    if (CardUtils.isQueenOfSpades(card)) {
      danger += 20;
    }

    // Leading from long suits is safer (more control)
    final suitLength = CardUtils.countCardsOfSuit(player.hand, card.suit);
    danger -= suitLength * 0.5;

    return danger;
  }

  /// Calculate bonus for voiding suits
  double _calculateVoidBonus(PlayingCard card, HeartsPlayer player) {
    final hand = player.hand;
    final suitCount = CardUtils.countCardsOfSuit(hand, card.suit);

    // Voiding a suit is valuable
    if (suitCount == 1) {
      return 10; // Last card in suit = void bonus
    }

    // Reducing short suits
    if (suitCount <= 3) {
      return 3;
    }

    return 0;
  }

  /// Get current highest card in trick
  PlayingCard _getCurrentHighest(Trick trick) {
    final leadSuit = trick.leadSuit!;
    return trick.cards
        .where((c) => c.suit == leadSuit)
        .reduce((a, b) => CardUtils.getHeartsRankValue(a.rank) > CardUtils.getHeartsRankValue(b.rank) ? a : b);
  }

  /// Play aggressively to shoot the moon
  AiPlayDecision _playForMoonShot(
    List<PlayingCard> legalCards,
    HeartsState state,
  ) {
    // Sort by rank (highest first) within legal cards
    final sorted = List<PlayingCard>.from(legalCards)
      ..sort((a, b) => CardUtils.getHeartsRankValue(b.rank).compareTo(CardUtils.getHeartsRankValue(a.rank)));

    // Play highest card to win tricks
    final selected = sorted.first;

    return AiPlayDecision(
      card: selected,
      delayMs: getRandomDelay(),
      reasoning: 'Attempting moon shot',
    );
  }

  @override
  Future<AiPassDecision> decidePass(
    List<PlayingCard> hand,
    PassDirection direction,
  ) async {
    final toPass = <PlayingCard>[];
    final remaining = List<PlayingCard>.from(hand);

    // Priority 1: Pass Q♠ if we have it
    final queenOfSpadesIndex = remaining.indexWhere(CardUtils.isQueenOfSpades);
    if (queenOfSpadesIndex != -1) {
      final queenOfSpades = remaining[queenOfSpadesIndex];
      toPass.add(queenOfSpades);
      remaining.removeAt(queenOfSpadesIndex);
    }

    // Priority 2: Pass high hearts (A, K, Q)
    final highHearts =
        remaining
            .where((c) => c.suit == CardSuit.hearts && CardUtils.getHeartsRankValue(c.rank) >= 12)
            .toList()
          ..sort((a, b) => CardUtils.getHeartsRankValue(b.rank).compareTo(CardUtils.getHeartsRankValue(a.rank)));

    for (final heart in highHearts) {
      if (toPass.length >= 3) break;
      toPass.add(heart);
      remaining.remove(heart);
    }

    // Priority 3: Void short suits (pass highest from suits with 1-2 cards)
    final suitCounts = <CardSuit, int>{};
    for (final suit in CardSuit.values) {
      suitCounts[suit] = CardUtils.countCardsOfSuit(remaining, suit);
    }

    final shortSuits = suitCounts.entries
        .where((e) => e.value > 0 && e.value <= 2)
        .map((e) => e.key)
        .toList();

    for (final suit in shortSuits) {
      if (toPass.length >= 3) break;
      final highest = CardUtils.getHighestOfSuit(remaining, suit);
      if (highest != null) {
        toPass.add(highest);
        remaining.remove(highest);
      }
    }

    // Fill remaining with highest cards
    remaining.sort((a, b) => CardUtils.getHeartsRankValue(b.rank).compareTo(CardUtils.getHeartsRankValue(a.rank)));
    while (toPass.length < 3 && remaining.isNotEmpty) {
      toPass.add(remaining.removeAt(0));
    }

    return AiPassDecision(
      cardsToPass: toPass.take(3).toList(),
      delayMs: 500 + _random.nextInt(700), // 500-1200ms
      reasoning: 'Strategic pass (Q♠, high hearts, void)',
    );
  }

  @override
  MoonDecision analyzeMoonAttempt(HeartsState state) {
    final player = state.players[state.currentPlayerIndex];
    final roundScore = player.roundScore;

    // Check if we're in a good position
    if (roundScore >= 15) {
      // Have most penalties - might be able to shoot
      final othersTotal = state.players
          .where((p) => p.index != player.index)
          .fold(0, (sum, p) => sum + p.roundScore);

      if (othersTotal <= 10) {
        // Others have few penalties - go for it!
        final probability = (roundScore / 26.0).clamp(0.0, 1.0);
        return MoonDecision(
          shouldAttempt: probability > 0.5,
          probability: probability,
          reasoning: 'Moon shot viable: $roundScore/26 points',
        );
      }
    }

    return const MoonDecision(
      shouldAttempt: false,
      probability: 0.0,
      reasoning: 'Not in position for moon shot',
    );
  }
}

/// Internal class for scoring cards
class _ScoredCard {
  final PlayingCard card;
  final double score;

  _ScoredCard({required this.card, required this.score});
}
