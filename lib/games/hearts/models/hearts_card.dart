import '../../guess_arrangement/models/playing_card.dart';

/// Hearts-specific card utilities
extension HeartsCardExtension on PlayingCard {
  /// Check if this card is a penalty card (hearts or Q♠)
  bool isPenaltyCard() {
    return suit == CardSuit.hearts ||
        (suit == CardSuit.spades && rank == CardRank.queen);
  }

  /// Get penalty points for this card
  int penaltyPoints() {
    if (suit == CardSuit.hearts) return 1;
    if (suit == CardSuit.spades && rank == CardRank.queen) return 13;
    return 0;
  }

  /// Check if this is the 2 of clubs (first lead card)
  bool isTwoOfClubs() {
    return suit == CardSuit.clubs && rank == CardRank.two;
  }
}
