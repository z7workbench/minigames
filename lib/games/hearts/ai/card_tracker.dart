import '../../guess_arrangement/models/playing_card.dart';
import '../models/trick.dart';
import '../utils/card_utils.dart';

/// Tracks played cards for AI analysis
class CardTracker {
  final Set<PlayingCard> _playedCards = {};
  final Map<CardSuit, int> _suitCounts = {
    CardSuit.spades: 13,
    CardSuit.hearts: 13,
    CardSuit.diamonds: 13,
    CardSuit.clubs: 13,
  };

  /// Record a card as played
  void recordPlayed(PlayingCard card) {
    _playedCards.add(card);
    _suitCounts[card.suit] = (_suitCounts[card.suit] ?? 13) - 1;
  }

  /// Record all cards from a trick
  void recordTrick(Trick trick) {
    for (final card in trick.cards) {
      recordPlayed(card);
    }
  }

  /// Check if a card has been played
  bool hasBeenPlayed(PlayingCard card) {
    return _playedCards.contains(card);
  }

  /// Count remaining cards of a suit
  int remainingInSuit(CardSuit suit) {
    return _suitCounts[suit] ?? 0;
  }

  /// Count remaining cards higher than given card (same suit)
  int remainingHigher(PlayingCard card) {
    int count = 0;
    for (final rank in CardRank.values) {
      if (rank.value > CardUtils.getHeartsRankValue(card.rank)) {
        final higherCard = PlayingCard(suit: card.suit, rank: rank);
        if (!_playedCards.contains(higherCard)) {
          count++;
        }
      }
    }
    return count;
  }

  /// Count remaining cards lower than given card (same suit)
  int remainingLower(PlayingCard card) {
    int count = 0;
    for (final rank in CardRank.values) {
      if (rank.value < CardUtils.getHeartsRankValue(card.rank)) {
        final lowerCard = PlayingCard(suit: card.suit, rank: rank);
        if (!_playedCards.contains(lowerCard)) {
          count++;
        }
      }
    }
    return count;
  }

  /// Check if Queen of Spades has been played
  bool queenOfSpadesPlayed() {
    return _playedCards.any(
      (c) => c.suit == CardSuit.spades && c.rank == CardRank.queen,
    );
  }

  /// Count remaining hearts
  int remainingHearts() {
    return remainingInSuit(CardSuit.hearts);
  }

  /// Get all played cards of a suit
  List<PlayingCard> playedOfSuit(CardSuit suit) {
    return _playedCards.where((c) => c.suit == suit).toList();
  }

  /// Reset tracker for new round
  void reset() {
    _playedCards.clear();
    for (final suit in CardSuit.values) {
      _suitCounts[suit] = 13;
    }
  }

  /// Get total cards played
  int totalPlayed() => _playedCards.length;

  /// Check if a suit is exhausted (all 13 played)
  bool isSuitExhausted(CardSuit suit) {
    return remainingInSuit(suit) == 0;
  }
}
