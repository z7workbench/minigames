import '../models/hearts_state.dart';
import '../models/hearts_player.dart';
import '../models/trick.dart';
import '../../guess_arrangement/models/playing_card.dart';
import '../utils/card_utils.dart';

/// Hearts game rules validator and logic
class HeartsRules {
  /// Check if a card play is legal
  static bool isLegalPlay(
    PlayingCard card,
    HeartsPlayer player,
    HeartsState state,
  ) {
    // Get all legal cards
    final legalCards = getLegalCards(player, state);
    return legalCards.contains(card);
  }

  /// Get all cards a player can legally play
  static List<PlayingCard> getLegalCards(
    HeartsPlayer player,
    HeartsState state,
  ) {
    final hand = player.hand;
    final trick = state.currentTrick;

    // Case 1: Leading the trick
    if (trick.cards.isEmpty) {
      return _getLegalLeadCards(hand, state);
    }

    // Case 2: Following in a trick
    return _getLegalFollowCards(hand, trick, state);
  }

  /// Get legal cards when leading a trick
  static List<PlayingCard> _getLegalLeadCards(
    List<PlayingCard> hand,
    HeartsState state,
  ) {
    // First trick of round: must lead 2♣
    if (state.completedTricks.isEmpty) {
      final twoOfClubs = hand
          .where((c) => c.suit == CardSuit.clubs && c.rank == CardRank.two)
          .toList();
      return twoOfClubs.isNotEmpty ? twoOfClubs : hand;
    }

    // Hearts not broken: can't lead hearts (unless only hearts)
    if (!state.heartsBroken) {
      final nonHearts = hand.where((c) => c.suit != CardSuit.hearts).toList();
      if (nonHearts.isNotEmpty) return nonHearts;
    }

    // Otherwise, can lead anything
    return hand;
  }

  /// Get legal cards when following suit
  static List<PlayingCard> _getLegalFollowCards(
    List<PlayingCard> hand,
    Trick trick,
    HeartsState state,
  ) {
    final leadSuit = trick.leadSuit!;

    // Must follow suit if possible
    final matchingSuit = hand.where((c) => c.suit == leadSuit).toList();
    if (matchingSuit.isNotEmpty) return matchingSuit;

    // Can't follow suit: check first trick restriction
    if (state.completedTricks.isEmpty) {
      // First trick: can't play penalty cards if possible
      final nonPenalty = hand
          .where(
            (c) =>
                c.suit != CardSuit.hearts &&
                !(c.suit == CardSuit.spades && c.rank == CardRank.queen),
          )
          .toList();

      if (nonPenalty.isNotEmpty) return nonPenalty;
    }

    // Otherwise, can play anything
    return hand;
  }

  /// Determine winner of a complete trick
  static int determineTrickWinner(Trick trick) {
    return trick.winnerIndex;
  }

  /// Calculate penalty points in a trick
  static int calculateTrickPenalty(Trick trick) {
    return trick.cards.fold(
      0,
      (sum, card) => sum + CardUtils.getPenaltyPoints(card),
    );
  }

  /// Check if playing a card would break hearts
  static bool wouldBreakHearts(PlayingCard card, HeartsState state) {
    // Hearts already broken
    if (state.heartsBroken) return false;

    // Playing a heart when not following suit
    if (card.suit == CardSuit.hearts) {
      final trick = state.currentTrick;
      if (trick.cards.isEmpty) return false; // Leading doesn't break hearts

      // Playing hearts always breaks hearts when not leading
      return true;
    }

    return false;
  }

  /// Check if game is over (someone reached 100 points)
  static bool isGameOver(HeartsState state) {
    return state.players.any((p) => p.totalScore >= 100);
  }

  /// Find the winner of the game (lowest score)
  static int findWinner(HeartsState state) {
    if (!isGameOver(state)) return -1;

    int winnerIndex = 0;
    int lowestScore = state.players[0].totalScore;

    for (int i = 1; i < state.players.length; i++) {
      if (state.players[i].totalScore < lowestScore) {
        lowestScore = state.players[i].totalScore;
        winnerIndex = i;
      }
    }

    return winnerIndex;
  }

  /// Check if a round is complete (all 13 tricks played)
  static bool isRoundComplete(HeartsState state) {
    return state.completedTricks.length == 13;
  }

  /// Get next player index (clockwise by visual position)
  ///
  /// Visual positions: 0=South, 1=West, 2=North, 3=East
  /// Clockwise order: South(0) → West(1) → North(2) → East(3) → South(0)
  ///
  /// We need to find which player has the next position in clockwise order.
  static int getNextPlayer(int currentIndex, List<HeartsPlayer> players) {
    // Find current player's position
    final currentPosition = players[currentIndex].position;

    // Calculate next position (clockwise: 0→1→2→3→0)
    final nextPosition = (currentPosition + 1) % 4;

    // Find the player at the next position
    for (int i = 0; i < players.length; i++) {
      if (players[i].position == nextPosition) {
        return i;
      }
    }

    // Fallback to simple increment (should never reach here)
    return (currentIndex + 1) % 4;
  }

  /// Find who has the 2 of clubs (leads first trick)
  static int findTwoOfClubsOwner(HeartsState state) {
    for (int i = 0; i < state.players.length; i++) {
      if (state.players[i].hasTwoOfClubs) {
        return i;
      }
    }
    return 0; // Default to player 0
  }

  /// Validate game state (for debugging/testing)
  static bool isValidState(HeartsState state) {
    // Check correct number of cards
    var totalCards = state.players.fold(0, (sum, p) => sum + p.hand.length);
    totalCards += state.completedTricks.fold(
      0,
      (sum, t) => sum + t.cards.length,
    );
    totalCards += state.currentTrick.cards.length;

    // Should be 52 total
    return totalCards == 52;
  }
}
