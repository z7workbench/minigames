import '../../guess_arrangement/models/playing_card.dart';

/// AI decision for card play
class AiPlayDecision {
  final PlayingCard card; // Card to play
  final int delayMs; // Delay before showing (for realism)
  final String? reasoning; // Debug info (why this card)

  const AiPlayDecision({
    required this.card,
    this.delayMs = 500,
    this.reasoning,
  });
}

/// AI decision for card passing
class AiPassDecision {
  final List<PlayingCard> cardsToPass; // 3 cards to pass
  final int delayMs;
  final String? reasoning;

  const AiPassDecision({
    required this.cardsToPass,
    this.delayMs = 500,
    this.reasoning,
  });

  bool get isValid => cardsToPass.length == 3;
}

/// AI decision for moon shooting
class MoonDecision {
  final bool shouldAttempt; // Should try to shoot moon?
  final double probability; // Estimated success chance
  final String? reasoning;

  const MoonDecision({
    required this.shouldAttempt,
    this.probability = 0.0,
    this.reasoning,
  });
}
