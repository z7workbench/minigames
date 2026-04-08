import '../../guess_arrangement/models/playing_card.dart';
import 'card_utils.dart';
import 'dart:math';

/// Hearts deck utilities
class HeartsDeck {
  /// Create a standard 52-card deck
  static List<PlayingCard> createDeck() {
    final deck = <PlayingCard>[];

    for (final suit in CardSuit.values) {
      for (final rank in CardRank.values) {
        deck.add(PlayingCard(suit: suit, rank: rank));
      }
    }

    return deck;
  }

  /// Shuffle deck using Fisher-Yates algorithm
  static List<PlayingCard> shuffle(List<PlayingCard> deck) {
    final shuffled = List<PlayingCard>.from(deck);

    for (int i = shuffled.length - 1; i > 0; i--) {
      final j = Random().nextInt(i + 1);
      final temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }

    return shuffled;
  }

  /// Deal cards to 4 players (13 cards each)
  static List<List<PlayingCard>> deal(List<PlayingCard> deck) {
    final hands = List.generate(4, (_) => <PlayingCard>[]);

    for (int i = 0; i < 52; i++) {
      hands[i % 4].add(deck[i]);
    }

    // Sort each hand by suit then rank
    return hands.map((hand) => CardUtils.sortHand(hand)).toList();
  }

  /// Find which player has the 2 of clubs
  static int findTwoOfClubsOwner(List<List<PlayingCard>> hands) {
    for (int i = 0; i < hands.length; i++) {
      if (hands[i].any(
        (c) => c.suit == CardSuit.clubs && c.rank == CardRank.two,
      )) {
        return i;
      }
    }
    return 0; // Default to player 0 if not found (shouldn't happen)
  }
}
