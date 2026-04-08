import '../../guess_arrangement/models/playing_card.dart';

/// Card utilities for Hearts
class CardUtils {
  /// Get the effective rank value for Hearts game
  /// In Hearts: 2=2, 3=3, ..., 10=10, J=11, Q=12, K=13, A=14 (highest)
  static int getHeartsRankValue(CardRank rank) {
    if (rank == CardRank.ace) {
      return 14; // Ace is highest in Hearts
    }
    return rank.value;
  }

  /// Sort hand by suit (♠♥♦♣ order) then by rank (low to high within suit)
  /// Hearts convention: Spades first, then Hearts, Diamonds, Clubs
  static List<PlayingCard> sortHand(List<PlayingCard> hand) {
    final sorted = List<PlayingCard>.from(hand);

    // Define suit order for Hearts: Spades, Hearts, Diamonds, Clubs
    final suitOrder = {
      CardSuit.spades: 0,
      CardSuit.hearts: 1,
      CardSuit.diamonds: 2,
      CardSuit.clubs: 3,
    };

    sorted.sort((a, b) {
      // First by suit
      final suitCompare = suitOrder[a.suit]! - suitOrder[b.suit]!;
      if (suitCompare != 0) return suitCompare;

      // Then by rank (ascending, using Hearts rank values)
      return getHeartsRankValue(a.rank) - getHeartsRankValue(b.rank);
    });

    return sorted;
  }

  /// Get cards of a specific suit from hand
  static List<PlayingCard> getCardsOfSuit(
    List<PlayingCard> hand,
    CardSuit suit,
  ) {
    return hand.where((c) => c.suit == suit).toList();
  }

  /// Check if hand contains cards of a specific suit
  static bool hasCardsOfSuit(List<PlayingCard> hand, CardSuit suit) {
    return hand.any((c) => c.suit == suit);
  }

  /// Count cards of a specific suit in hand
  static int countCardsOfSuit(List<PlayingCard> hand, CardSuit suit) {
    return hand.where((c) => c.suit == suit).length;
  }

  /// Check if a card is a penalty card
  static bool isPenaltyCard(PlayingCard card) {
    return card.suit == CardSuit.hearts ||
        (card.suit == CardSuit.spades && card.rank == CardRank.queen);
  }

  /// Get penalty points for a card
  static int getPenaltyPoints(PlayingCard card) {
    if (card.suit == CardSuit.hearts) return 1;
    if (card.suit == CardSuit.spades && card.rank == CardRank.queen) return 13;
    return 0;
  }

  /// Check if a card is the Queen of Spades
  static bool isQueenOfSpades(PlayingCard card) {
    return card.suit == CardSuit.spades && card.rank == CardRank.queen;
  }

  /// Check if a card is the 2 of Clubs
  static bool isTwoOfClubs(PlayingCard card) {
    return card.suit == CardSuit.clubs && card.rank == CardRank.two;
  }

  /// Calculate total penalty points in a list of cards
  static int calculateTotalPenalty(List<PlayingCard> cards) {
    return cards.fold(0, (sum, card) => sum + getPenaltyPoints(card));
  }

  /// Get highest card of a specific suit (using Hearts rank values)
  static PlayingCard? getHighestOfSuit(List<PlayingCard> hand, CardSuit suit) {
    final suitCards = getCardsOfSuit(hand, suit);
    if (suitCards.isEmpty) return null;

    return suitCards.reduce(
      (a, b) => getHeartsRankValue(a.rank) > getHeartsRankValue(b.rank) ? a : b,
    );
  }

  /// Get lowest card of a specific suit (using Hearts rank values)
  static PlayingCard? getLowestOfSuit(List<PlayingCard> hand, CardSuit suit) {
    final suitCards = getCardsOfSuit(hand, suit);
    if (suitCards.isEmpty) return null;

    return suitCards.reduce(
      (a, b) => getHeartsRankValue(a.rank) < getHeartsRankValue(b.rank) ? a : b,
    );
  }

  /// Remove cards from hand
  static List<PlayingCard> removeCards(
    List<PlayingCard> hand,
    List<PlayingCard> toRemove,
  ) {
    return hand.where((c) => !toRemove.contains(c)).toList();
  }

  /// Add cards to hand and sort
  static List<PlayingCard> addCards(
    List<PlayingCard> hand,
    List<PlayingCard> toAdd,
  ) {
    return sortHand([...hand, ...toAdd]);
  }

  /// Compare two cards by rank for trick winner determination
  /// Uses Hearts rank values where A=14 (highest)
  static int compareByRank(PlayingCard a, PlayingCard b) {
    return getHeartsRankValue(a.rank) - getHeartsRankValue(b.rank);
  }

  /// Sort cards by rank (highest first) for passing decisions
  static List<PlayingCard> sortByRankDescending(List<PlayingCard> cards) {
    final sorted = List<PlayingCard>.from(cards);
    sorted.sort(
      (a, b) => getHeartsRankValue(b.rank) - getHeartsRankValue(a.rank),
    );
    return sorted;
  }

  /// Sort cards by rank (lowest first)
  static List<PlayingCard> sortByRankAscending(List<PlayingCard> cards) {
    final sorted = List<PlayingCard>.from(cards);
    sorted.sort(
      (a, b) => getHeartsRankValue(a.rank) - getHeartsRankValue(b.rank),
    );
    return sorted;
  }
}
