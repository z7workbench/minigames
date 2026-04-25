import 'package:flutter/material.dart';

/// Card suit enumeration with display properties.
enum CardSuit {
  spades('♠', 'spades', Colors.black),
  hearts('♥', 'hearts', Colors.red),
  diamonds('♦', 'diamonds', Colors.red),
  clubs('♣', 'clubs', Colors.black);

  final String symbol;
  final String name;
  final Color color;

  const CardSuit(this.symbol, this.name, this.color);

  bool get isRed => this == hearts || this == diamonds;
  bool get isBlack => !isRed;
}

/// Card rank enumeration (A=1 smallest, K=13 largest).
enum CardRank {
  ace(1, 'A'),
  two(2, '2'),
  three(3, '3'),
  four(4, '4'),
  five(5, '5'),
  six(6, '6'),
  seven(7, '7'),
  eight(8, '8'),
  nine(9, '9'),
  ten(10, '10'),
  jack(11, 'J'),
  queen(12, 'Q'),
  king(13, 'K');

  final int value;
  final String symbol;

  const CardRank(this.value, this.symbol);

  /// Compare ranks: returns negative if this < other, 0 if equal, positive if this > other
  int compareTo(CardRank other) => value.compareTo(other.value);

  /// Check if this rank is adjacent to another (for straight detection)
  bool isAdjacentTo(CardRank other) => (value - other.value).abs() == 1;
}

/// Represents a playing card with suit and rank.
class PlayingCard {
  final CardSuit suit;
  final CardRank rank;
  final bool isRevealed;
  final bool isJoker;

  const PlayingCard({
    required this.suit,
    required this.rank,
    this.isRevealed = false,
    this.isJoker = false,
  });

  /// Create a card from integer values (suit: 0-3, rank: 1-13)
  factory PlayingCard.fromValues({
    required int suitIndex,
    required int rankValue,
  }) {
    return PlayingCard(
      suit: CardSuit.values[suitIndex],
      rank: CardRank.values.firstWhere((r) => r.value == rankValue),
    );
  }

  /// Unique identifier for this card
  String get id => '${suit.name}_${rank.value}';

  /// Display string (e.g., "♠A", "♥K", "♦7")
  String get displayString => '${suit.symbol}${rank.symbol}';

  /// Full display string with name (e.g., "Ace of Spades")
  String get fullName => '${rank.symbol} of ${suit.name}';

  /// Create a copy with updated revealed state
  PlayingCard copyWith({CardSuit? suit, CardRank? rank, bool? isRevealed, bool? isJoker}) {
    return PlayingCard(
      suit: suit ?? this.suit,
      rank: rank ?? this.rank,
      isRevealed: isRevealed ?? this.isRevealed,
      isJoker: isJoker ?? this.isJoker,
    );
  }

  /// Reveal this card
  PlayingCard revealed() => copyWith(isRevealed: true);

  /// Hide this card
  PlayingCard hidden() => copyWith(isRevealed: false);

  /// Compare cards by rank
  int compareTo(PlayingCard other) => rank.compareTo(other.rank);

  /// Check if cards are equal (same suit and rank)
  bool hasSameValue(PlayingCard other) =>
      suit == other.suit && rank == other.rank;

  /// Serialize to JSON
  Map<String, dynamic> toJson() => {
    'suit': suit.index,
    'rank': rank.value,
    'isRevealed': isRevealed,
    'isJoker': isJoker,
  };

  /// Deserialize from JSON
  factory PlayingCard.fromJson(Map<String, dynamic> json) {
    return PlayingCard(
      suit: CardSuit.values[json['suit'] as int],
      rank: CardRank.values.firstWhere((r) => r.value == json['rank']),
      isRevealed: json['isRevealed'] as bool? ?? false,
      isJoker: json['isJoker'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayingCard &&
        suit == other.suit &&
        rank == other.rank &&
        isRevealed == other.isRevealed &&
        isJoker == other.isJoker;
  }

  @override
  int get hashCode => Object.hash(suit, rank, isRevealed, isJoker);

  @override
  String toString() => isRevealed ? displayString : '?';
}

/// Represents a player's hand of cards with position tracking.
class CardHand {
  final List<PlayingCard> cards;
  final List<bool> revealedPositions;

  const CardHand({required this.cards, required this.revealedPositions});

  /// Create an initial hand with all cards hidden
  factory CardHand.initial(List<PlayingCard> cards) {
    return CardHand(
      cards: cards,
      revealedPositions: List.filled(cards.length, false),
    );
  }

  /// Number of cards in hand
  int get length => cards.length;

  /// Number of revealed cards
  int get revealedCount => revealedPositions.where((r) => r).length;

  /// Number of remaining hidden cards
  int get hiddenCount => length - revealedCount;

  /// Check if all cards are revealed
  bool get isFullyRevealed => revealedCount == length;

  /// Get card at position (returns null if out of bounds)
  PlayingCard? cardAt(int position) {
    if (position < 0 || position >= cards.length) return null;
    return cards[position];
  }

  /// Check if position is revealed
  bool isPositionRevealed(int position) {
    if (position < 0 || position >= revealedPositions.length) return false;
    return revealedPositions[position];
  }

  /// Reveal card at position
  CardHand revealPosition(int position) {
    if (position < 0 || position >= revealedPositions.length) return this;
    final newRevealed = List<bool>.from(revealedPositions);
    newRevealed[position] = true;
    return CardHand(cards: cards, revealedPositions: newRevealed);
  }

  /// Get list of hidden positions
  List<int> get hiddenPositions {
    return [
      for (var i = 0; i < revealedPositions.length; i++)
        if (!revealedPositions[i]) i,
    ];
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() => {
    'cards': cards.map((c) => c.toJson()).toList(),
    'revealedPositions': revealedPositions,
  };

  /// Deserialize from JSON
  factory CardHand.fromJson(Map<String, dynamic> json) {
    return CardHand(
      cards: (json['cards'] as List)
          .map((c) => PlayingCard.fromJson(c as Map<String, dynamic>))
          .toList(),
      revealedPositions: (json['revealedPositions'] as List).cast<bool>(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CardHand &&
        _listEquals(cards, other.cards) &&
        _listEqualsBool(revealedPositions, other.revealedPositions);
  }

  @override
  int get hashCode => Object.hash(cards, revealedPositions);

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _listEqualsBool(List<bool> a, List<bool> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
