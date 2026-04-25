import 'dart:math';

import 'package:equatable/equatable.dart';

/// Represents a single roulette card (bullet or blank)
class RouletteCard extends Equatable {
  final bool isBullet;

  const RouletteCard({required this.isBullet});

  /// Create a bullet card
  factory RouletteCard.bullet() => const RouletteCard(isBullet: true);

  /// Create a blank card
  factory RouletteCard.blank() => const RouletteCard(isBullet: false);

  /// Deserialize from JSON
  factory RouletteCard.fromJson(Map<String, dynamic> json) {
    return RouletteCard(isBullet: json['isBullet'] as bool);
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() => {'isBullet': isBullet};

  @override
  List<Object?> get props => [isBullet];

  @override
  String toString() => isBullet ? 'BULLET' : 'BLANK';
}

/// Represents a Russian roulette deck (1 bullet + 5 blanks, shuffled)
class RouletteDeck extends Equatable {
  final List<RouletteCard> cards;
  final int currentIndex; // Position in deck for drawing

  const RouletteDeck({
    required this.cards,
    this.currentIndex = 0,
  });

  /// Create a new shuffled roulette deck (1 bullet + 5 blanks)
  factory RouletteDeck.create() {
    final random = Random();
    final cards = [
      RouletteCard.bullet(),
      RouletteCard.blank(),
      RouletteCard.blank(),
      RouletteCard.blank(),
      RouletteCard.blank(),
      RouletteCard.blank(),
    ];
    cards.shuffle(random);
    return RouletteDeck(cards: cards, currentIndex: 0);
  }

  /// Deserialize from JSON
  factory RouletteDeck.fromJson(Map<String, dynamic> json) {
    return RouletteDeck(
      cards: (json['cards'] as List)
          .map((c) => RouletteCard.fromJson(c as Map<String, dynamic>))
          .toList(),
      currentIndex: json['currentIndex'] as int,
    );
  }

  /// Number of remaining cards in the deck
  int get remainingCards => cards.length - currentIndex;

  /// Check if deck is empty
  bool get isEmpty => remainingCards == 0;

  /// Check if deck still has cards
  bool get hasCards => remainingCards > 0;

  /// Draw the next card from the deck
  /// Returns null if deck is empty
  RouletteCard? draw() {
    if (isEmpty) return null;
    final card = cards[currentIndex];
    return card;
  }

  /// Create a new deck with the next card drawn (advances index)
  RouletteDeck withDraw() {
    if (isEmpty) return this;
    return copyWith(currentIndex: currentIndex + 1);
  }

  /// Shuffle remaining cards (for a new roulette round)
  RouletteDeck shuffled() {
    final random = Random();
    final remaining = cards.sublist(currentIndex);
    remaining.shuffle(random);
    return RouletteDeck(
      cards: [...cards.sublist(0, currentIndex), ...remaining],
      currentIndex: currentIndex,
    );
  }

  /// Reset deck to initial state with fresh shuffle
  RouletteDeck reset() => RouletteDeck.create();

  RouletteDeck copyWith({
    List<RouletteCard>? cards,
    int? currentIndex,
  }) {
    return RouletteDeck(
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() => {
    'cards': cards.map((c) => c.toJson()).toList(),
    'currentIndex': currentIndex,
  };

  @override
  List<Object?> get props => [cards, currentIndex];
}