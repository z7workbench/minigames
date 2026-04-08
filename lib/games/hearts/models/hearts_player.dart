import 'package:equatable/equatable.dart';

import '../../guess_arrangement/models/playing_card.dart';
import 'enums.dart';
import 'hearts_card.dart';

/// Player state in Hearts game
class HeartsPlayer extends Equatable {
  final int index; // 0-3
  final String name; // Display name
  final bool isHuman; // Is this a human player?
  final AiDifficulty? aiDifficulty; // AI difficulty (null for human)
  final int position; // Visual position (0=South, 1=West, 2=North, 3=East)
  final List<PlayingCard> hand; // Cards in hand
  final List<PlayingCard> tricksWon; // Cards won this round
  final int roundScore; // Points taken this round
  final int totalScore; // Cumulative game score
  final List<PlayingCard>? selectedPassCards; // Cards selected for passing
  final List<PlayingCard>?
  receivedPassCards; // Cards received from passing (for display)

  const HeartsPlayer({
    required this.index,
    required this.name,
    required this.isHuman,
    this.aiDifficulty,
    required this.position,
    this.hand = const [],
    this.tricksWon = const [],
    this.roundScore = 0,
    this.totalScore = 0,
    this.selectedPassCards,
    this.receivedPassCards,
  });

  /// Factory for creating a new player
  factory HeartsPlayer.create({
    required int index,
    required bool isHuman,
    AiDifficulty? aiDifficulty,
    required int position,
  }) {
    return HeartsPlayer(
      index: index,
      name: isHuman ? 'You' : 'AI ${index + 1}',
      isHuman: isHuman,
      aiDifficulty: aiDifficulty,
      position: position,
    );
  }

  /// Sentinel value to distinguish "not provided" from "null"
  static const _notProvided = Object();

  HeartsPlayer copyWith({
    int? index,
    String? name,
    bool? isHuman,
    AiDifficulty? aiDifficulty,
    int? position,
    List<PlayingCard>? hand,
    List<PlayingCard>? tricksWon,
    int? roundScore,
    int? totalScore,
    Object? selectedPassCards = _notProvided,
    Object? receivedPassCards = _notProvided,
  }) {
    return HeartsPlayer(
      index: index ?? this.index,
      name: name ?? this.name,
      isHuman: isHuman ?? this.isHuman,
      aiDifficulty: aiDifficulty ?? this.aiDifficulty,
      position: position ?? this.position,
      hand: hand ?? this.hand,
      tricksWon: tricksWon ?? this.tricksWon,
      roundScore: roundScore ?? this.roundScore,
      totalScore: totalScore ?? this.totalScore,
      selectedPassCards: selectedPassCards == _notProvided
          ? this.selectedPassCards
          : selectedPassCards as List<PlayingCard>?,
      receivedPassCards: receivedPassCards == _notProvided
          ? this.receivedPassCards
          : receivedPassCards as List<PlayingCard>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'index': index,
    'name': name,
    'isHuman': isHuman,
    'aiDifficulty': aiDifficulty?.name,
    'position': position,
    'hand': hand.map((c) => c.toJson()).toList(),
    'tricksWon': tricksWon.map((c) => c.toJson()).toList(),
    'roundScore': roundScore,
    'totalScore': totalScore,
    'selectedPassCards': selectedPassCards?.map((c) => c.toJson()).toList(),
    'receivedPassCards': receivedPassCards?.map((c) => c.toJson()).toList(),
  };

  factory HeartsPlayer.fromJson(Map<String, dynamic> json) {
    return HeartsPlayer(
      index: json['index'] as int,
      name: json['name'] as String,
      isHuman: json['isHuman'] as bool,
      aiDifficulty: json['aiDifficulty'] != null
          ? AiDifficulty.values.byName(json['aiDifficulty'] as String)
          : null,
      position: json['position'] as int,
      hand: (json['hand'] as List)
          .map((c) => PlayingCard.fromJson(c as Map<String, dynamic>))
          .toList(),
      tricksWon: (json['tricksWon'] as List)
          .map((c) => PlayingCard.fromJson(c as Map<String, dynamic>))
          .toList(),
      roundScore: json['roundScore'] as int,
      totalScore: json['totalScore'] as int,
      selectedPassCards: json['selectedPassCards'] != null
          ? (json['selectedPassCards'] as List)
                .map((c) => PlayingCard.fromJson(c as Map<String, dynamic>))
                .toList()
          : null,
      receivedPassCards: json['receivedPassCards'] != null
          ? (json['receivedPassCards'] as List)
                .map((c) => PlayingCard.fromJson(c as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  @override
  List<Object?> get props => [
    index,
    name,
    isHuman,
    aiDifficulty,
    position,
    hand,
    tricksWon,
    roundScore,
    totalScore,
    selectedPassCards,
    receivedPassCards,
  ];

  // Computed properties
  int get cardCount => hand.length;
  bool get hasTwoOfClubs => hand.any((c) => c.isTwoOfClubs());
  int get heartsInTricks =>
      tricksWon.where((c) => c.suit == CardSuit.hearts).length;
  bool get hasQueenOfSpades =>
      hand.any((c) => c.suit == CardSuit.spades && c.rank == CardRank.queen);
}
