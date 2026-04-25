import 'package:equatable/equatable.dart';

import '../../guess_arrangement/models/playing_card.dart';
import 'enums.dart';
import 'roulette_deck.dart';

/// Player state in Bluff Bar game
class BluffBarPlayer extends Equatable {
  final int index; // 0-n (player position)
  final String name; // Display name
  final bool isHuman; // Is this a human player?
  final AiDifficulty? aiDifficulty; // AI difficulty (null for human)
  final List<PlayingCard> hand; // Cards in player's hand
  final RouletteDeck rouletteDeck; // Personal roulette deck (reshuffled each round)
  final bool isEliminated; // Player eliminated by roulette
  final int roundsSurvived; // Number of rounds survived
  final int bulletHits; // Number of bullet hits taken (should be 0-1)
  final int rouletteShots; // Cumulative roulette shots fired (0-6, persists across rounds)

  const BluffBarPlayer({
    required this.index,
    required this.name,
    required this.isHuman,
    this.aiDifficulty,
    this.hand = const [],
    required this.rouletteDeck,
    this.isEliminated = false,
    this.roundsSurvived = 0,
    this.bulletHits = 0,
    this.rouletteShots = 0,
  });

  /// Factory for creating a new player
  factory BluffBarPlayer.create({
    required int index,
    required bool isHuman,
    AiDifficulty? aiDifficulty,
  }) {
    return BluffBarPlayer(
      index: index,
      name: isHuman ? 'You' : 'AI ${index + 1}',
      isHuman: isHuman,
      aiDifficulty: aiDifficulty,
      rouletteDeck: RouletteDeck.create(),
      rouletteShots: 0,
    );
  }

  BluffBarPlayer copyWith({
    int? index,
    String? name,
    bool? isHuman,
    AiDifficulty? aiDifficulty,
    List<PlayingCard>? hand,
    RouletteDeck? rouletteDeck,
    bool? isEliminated,
    int? roundsSurvived,
    int? bulletHits,
    int? rouletteShots,
  }) {
    return BluffBarPlayer(
      index: index ?? this.index,
      name: name ?? this.name,
      isHuman: isHuman ?? this.isHuman,
      aiDifficulty: aiDifficulty ?? this.aiDifficulty,
      hand: hand ?? this.hand,
      rouletteDeck: rouletteDeck ?? this.rouletteDeck,
      isEliminated: isEliminated ?? this.isEliminated,
      roundsSurvived: roundsSurvived ?? this.roundsSurvived,
      bulletHits: bulletHits ?? this.bulletHits,
      rouletteShots: rouletteShots ?? this.rouletteShots,
    );
  }

  /// Remove cards from hand
  BluffBarPlayer removeCards(List<PlayingCard> cardsToRemove) {
    final newHand = hand.where((c) => !cardsToRemove.contains(c)).toList();
    return copyWith(hand: newHand);
  }

  /// Add cards to hand
  BluffBarPlayer addCards(List<PlayingCard> cardsToAdd) {
    return copyWith(hand: [...hand, ...cardsToAdd]);
  }

  /// Mark player as eliminated (hit by bullet)
  BluffBarPlayer eliminate() {
    return copyWith(
      isEliminated: true,
      bulletHits: bulletHits + 1,
    );
  }

  /// Survive a round (survived roulette or won challenge)
  BluffBarPlayer surviveRound() {
    return copyWith(roundsSurvived: roundsSurvived + 1);
  }

  /// Advance roulette deck after a draw
  BluffBarPlayer advanceRoulette() {
    return copyWith(rouletteDeck: rouletteDeck.withDraw());
  }

  /// Reset roulette deck for a new round
  BluffBarPlayer resetRouletteDeck() {
    return copyWith(rouletteDeck: RouletteDeck.create());
  }

  Map<String, dynamic> toJson() => {
    'index': index,
    'name': name,
    'isHuman': isHuman,
    'aiDifficulty': aiDifficulty?.name,
    'hand': hand.map((c) => c.toJson()).toList(),
    'rouletteDeck': rouletteDeck.toJson(),
    'isEliminated': isEliminated,
    'roundsSurvived': roundsSurvived,
    'bulletHits': bulletHits,
    'rouletteShots': rouletteShots,
  };

  factory BluffBarPlayer.fromJson(Map<String, dynamic> json) {
    return BluffBarPlayer(
      index: json['index'] as int,
      name: json['name'] as String,
      isHuman: json['isHuman'] as bool,
      aiDifficulty: json['aiDifficulty'] != null
          ? AiDifficulty.values.byName(json['aiDifficulty'] as String)
          : null,
      hand: (json['hand'] as List)
          .map((c) => PlayingCard.fromJson(c as Map<String, dynamic>))
          .toList(),
      rouletteDeck: RouletteDeck.fromJson(
        json['rouletteDeck'] as Map<String, dynamic>,
      ),
      isEliminated: json['isEliminated'] as bool,
      roundsSurvived: json['roundsSurvived'] as int,
      bulletHits: json['bulletHits'] as int,
      rouletteShots: (json['rouletteShots'] as int?) ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    index,
    name,
    isHuman,
    aiDifficulty,
    hand,
    rouletteDeck,
    isEliminated,
    roundsSurvived,
    bulletHits,
    rouletteShots,
  ];

  // Computed properties
  int get cardCount => hand.length;
  bool get isActive => !isEliminated;
  int get rouletteChances => rouletteDeck.remainingCards;
}