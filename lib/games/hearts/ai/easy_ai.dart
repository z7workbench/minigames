import 'dart:math';
import '../../guess_arrangement/models/playing_card.dart';
import '../models/hearts_state.dart';
import '../models/enums.dart';
import '../models/hearts_player.dart';
import '../utils/card_utils.dart';
import 'hearts_ai.dart';
import 'ai_decision.dart';

/// Easy AI for Hearts - Random with basic preferences
class EasyHeartsAi extends HeartsAi {
  final Random _random = Random();

  EasyHeartsAi() : super(name: 'Easy AI', difficulty: AiDifficulty.easy);

  @override
  Future<AiPlayDecision> decidePlay(HeartsState state) async {
    final player = state.players[state.currentPlayerIndex];
    final legalCards = _getLegalCards(player, state);

    if (legalCards.isEmpty) {
      throw StateError('No legal cards available');
    }

    // Single card available
    if (legalCards.length == 1) {
      return AiPlayDecision(
        card: legalCards.first,
        delayMs: 400,
        reasoning: 'Only legal card',
      );
    }

    // 70% chance to play lowest card, 30% random
    final card = _random.nextDouble() < 0.7
        ? _getLowestCard(legalCards)
        : legalCards[_random.nextInt(legalCards.length)];

    return AiPlayDecision(
      card: card,
      delayMs: 400 + _random.nextInt(400), // 400-800ms
      reasoning: 'Random/low preference',
    );
  }

  @override
  Future<AiPassDecision> decidePass(
    List<PlayingCard> hand,
    PassDirection direction,
  ) async {
    if (hand.length < 3) {
      throw StateError('Not enough cards to pass');
    }

    // Sort by rank (highest first, using Hearts rank values)
    final sorted = CardUtils.sortByRankDescending(hand);

    // Take 3 highest cards with some randomization
    final toPass = <PlayingCard>[];

    // Always try to pass Q♠ if we have it
    final queenOfSpadesIndex = sorted.indexWhere(
      (c) => c.suit == CardSuit.spades && c.rank == CardRank.queen,
    );

    if (queenOfSpadesIndex != -1) {
      final queenOfSpades = sorted[queenOfSpadesIndex];
      toPass.add(queenOfSpades);
      sorted.removeAt(queenOfSpadesIndex);
    }

    // Add more high cards
    while (toPass.length < 3 && sorted.isNotEmpty) {
      // 60% highest remaining, 40% random
      final card = _random.nextDouble() < 0.6
          ? sorted.first
          : sorted[_random.nextInt(sorted.length)];

      toPass.add(card);
      sorted.remove(card);
    }

    return AiPassDecision(
      cardsToPass: toPass,
      delayMs: 500 + _random.nextInt(500), // 500-1000ms
      reasoning: 'Passing high cards (easy)',
    );
  }

  @override
  MoonDecision analyzeMoonAttempt(HeartsState state) {
    // Easy AI never attempts to shoot the moon
    return const MoonDecision(
      shouldAttempt: false,
      probability: 0.0,
      reasoning: 'Easy AI does not attempt moon shooting',
    );
  }

  /// Get legal cards for current player
  List<PlayingCard> _getLegalCards(HeartsPlayer player, HeartsState state) {
    final hand = player.hand;
    final currentTrick = state.currentTrick;

    // If leading the trick
    if (currentTrick.isEmpty) {
      // Round 1, first trick: must play 2 of Clubs if have it
      if (state.roundNumber == 1 && state.trickNumber == 1) {
        final twoOfClubsIndex = hand.indexWhere(
          (c) => c.suit == CardSuit.clubs && c.rank == CardRank.two,
        );
        if (twoOfClubsIndex != -1) {
          return [hand[twoOfClubsIndex]];
        }
        // Shouldn't happen, but return first card if not found
        return [hand.first];
      }

      // Hearts broken or cannot lead with hearts
      if (state.heartsBroken) {
        // Can play any card
        return List<PlayingCard>.from(hand);
      } else {
        // Cannot lead with hearts (unless only hearts left)
        final nonHearts = hand.where((c) => c.suit != CardSuit.hearts).toList();
        if (nonHearts.isEmpty) {
          return List<PlayingCard>.from(hand); // No choice
        }
        return nonHearts;
      }
    }

    // If following, must follow suit if possible
    final leadSuit = currentTrick.leadSuit;
    final cardsOfSuit = hand.where((c) => c.suit == leadSuit).toList();

    if (cardsOfSuit.isNotEmpty) {
      return cardsOfSuit;
    }

    // Cannot follow suit - can play any card (including hearts if broken)
    return List<PlayingCard>.from(hand);
  }

  /// Get lowest rank card (using Hearts rank values)
  PlayingCard _getLowestCard(List<PlayingCard> cards) {
    return cards.reduce(
      (a, b) =>
          CardUtils.getHeartsRankValue(a.rank) <
              CardUtils.getHeartsRankValue(b.rank)
          ? a
          : b,
    );
  }
}
