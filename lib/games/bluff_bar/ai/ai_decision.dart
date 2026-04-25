import '../../guess_arrangement/models/playing_card.dart';

class AiPlayDecision {
  final List<int> cardIndices; // Indices in player's hand
  final CardRank claimedRank; // Rank claimed (not full card)
  final int delayMs;
  final bool shouldChallenge; // Whether AI should challenge after playing

  const AiPlayDecision({
    required this.cardIndices,
    required this.claimedRank,
    this.delayMs = 800,
    this.shouldChallenge = false,
  });
}

class AiChallengeDecision {
  final bool shouldChallenge;
  final int delayMs;
  final String reasoning;
  
  const AiChallengeDecision({
    required this.shouldChallenge,
    this.delayMs = 800,
    this.reasoning = '',
  });
}