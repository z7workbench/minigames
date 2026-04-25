import '../models/bluff_bar_state.dart';
import '../models/enums.dart';
import 'ai_decision.dart';

abstract class BluffBarAi {
  final String name;
  final AiDifficulty difficulty;
  
  /// Aggression factor (0.0 = very conservative, 1.0 = very aggressive)
  /// Higher values = more likely to challenge and bluff
  final double aggressionFactor;

  BluffBarAi({
    required this.name,
    required this.difficulty,
    this.aggressionFactor = 0.5,
  });

  /// Decide what cards to play and what to claim
  Future<AiPlayDecision> decidePlay(BluffBarState state);

  /// Decide whether to challenge the last player's claim
  Future<AiChallengeDecision> decideChallenge(BluffBarState state);

  /// Record played cards for tracking (used by medium/hard AI)
  void recordPlayedCards(PlayedCards play) {}

  /// Reset for new round (clear tracking data)
  void resetForNewRound() {}

  /// Get delay for AI thinking (fixed 1 second for smooth gameplay)
  int getRandomDelay() => 1000;
}