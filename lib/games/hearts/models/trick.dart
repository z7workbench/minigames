import 'package:equatable/equatable.dart';

import '../../guess_arrangement/models/playing_card.dart';
import '../utils/card_utils.dart';
import 'hearts_card.dart';

/// Current trick state
class Trick extends Equatable {
  final List<PlayingCard> cards; // Cards played (in order)
  final List<int> playerIndices; // Who played each card
  final int leadPlayerIndex; // Who led this trick

  const Trick({
    this.cards = const [],
    this.playerIndices = const [],
    this.leadPlayerIndex = 0,
  });

  /// Number of cards played in this trick
  int get length => cards.length;

  /// Check if the trick is complete (4 cards played)
  bool get isComplete => cards.length == 4;

  /// Check if the trick is empty
  bool get isEmpty => cards.isEmpty;

  /// The first card played (lead card)
  PlayingCard? get leadCard => cards.isNotEmpty ? cards.first : null;

  /// The suit of the first card played (the "lead suit")
  /// Only cards of this suit can win the trick
  CardSuit? get leadSuit => cards.isEmpty ? null : cards.first.suit;

  /// Calculate points in this trick using Hearts-specific extension
  int get points => cards.fold(0, (sum, card) => sum + card.penaltyPoints());

  /// Check if this trick contains the queen of spades
  bool get hasQueenOfSpades => cards.any(
    (card) => card.suit == CardSuit.spades && card.rank == CardRank.queen,
  );

  /// Check if this trick contains any hearts
  bool get hasHearts => cards.any((card) => card.suit == CardSuit.hearts);

  /// Determine the winner of this trick.
  ///
  /// Rules:
  /// - Only cards matching the lead suit (first card's suit) can win
  /// - Highest card of the lead suit wins
  /// - Other suits (even with higher rank) cannot win
  ///
  /// Example:
  /// - Player 1: ♦6 (lead) → leadSuit = diamonds
  /// - Player 2: ♥7 (cannot follow) → not counted for winning
  /// - Player 3: ♦3 (follows) → compared, but 3 < 6
  /// - Player 4: ♣K (cannot follow) → not counted for winning
  /// → Winner: Player 1 (♦6 is highest diamond)
  ///
  /// Returns the player index of the winner, or -1 if trick not complete
  int get winnerIndex {
    if (!isComplete) return -1;

    // The lead suit is determined by the first card played
    final leadSuit = cards.first.suit;

    // Start with first player as current winner
    // (first card is always the lead suit by definition)
    PlayingCard highestOfLeadSuit = cards.first;
    int winner = playerIndices.first;

    // Check remaining cards
    for (int i = 1; i < cards.length; i++) {
      final card = cards[i];

      // CRITICAL: Only cards of lead suit can win
      // Other suits are "discards" and cannot win the trick
      if (card.suit == leadSuit) {
        final cardValue = CardUtils.getHeartsRankValue(card.rank);
        final highestValue = CardUtils.getHeartsRankValue(
          highestOfLeadSuit.rank,
        );

        if (cardValue > highestValue) {
          highestOfLeadSuit = card;
          winner = playerIndices[i];
        }
      }
      // If card.suit != leadSuit, it's a discard and cannot win
    }

    return winner;
  }

  /// Add a card to the trick
  Trick addCard(PlayingCard card, int playerIndex) {
    return Trick(
      cards: [...cards, card],
      playerIndices: [...playerIndices, playerIndex],
      leadPlayerIndex: leadPlayerIndex,
    );
  }

  /// Create an empty trick
  factory Trick.empty() => const Trick();

  Trick copyWith({
    List<PlayingCard>? cards,
    List<int>? playerIndices,
    int? leadPlayerIndex,
  }) {
    return Trick(
      cards: cards ?? this.cards,
      playerIndices: playerIndices ?? this.playerIndices,
      leadPlayerIndex: leadPlayerIndex ?? this.leadPlayerIndex,
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() => {
    'cards': cards.map((c) => c.toJson()).toList(),
    'playerIndices': playerIndices,
    'leadPlayerIndex': leadPlayerIndex,
  };

  /// Deserialize from JSON
  factory Trick.fromJson(Map<String, dynamic> json) {
    return Trick(
      cards: (json['cards'] as List)
          .map((c) => PlayingCard.fromJson(c as Map<String, dynamic>))
          .toList(),
      playerIndices: (json['playerIndices'] as List).cast<int>(),
      leadPlayerIndex: json['leadPlayerIndex'] as int,
    );
  }

  @override
  List<Object?> get props => [cards, playerIndices, leadPlayerIndex];
}
