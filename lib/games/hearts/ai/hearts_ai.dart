import '../../guess_arrangement/models/playing_card.dart';
import '../models/hearts_state.dart';
import '../models/enums.dart';
import 'ai_decision.dart';
import '../models/trick.dart';
import 'card_tracker.dart';

/// Abstract base class for Hearts AI
abstract class HeartsAi {
  final String name;
  final AiDifficulty difficulty;
  final CardTracker tracker;

  HeartsAi({required this.name, required this.difficulty})
    : tracker = CardTracker();

  /// Decide which card to play in current trick
  ///
  /// [state] - Current game state
  /// Returns an [AiPlayDecision] with the card to play
  Future<AiPlayDecision> decidePlay(HeartsState state);

  /// Decide which 3 cards to pass before a round
  ///
  /// [hand] - Current hand (before passing)
  /// [direction] - Where cards are being passed
  Future<AiPassDecision> decidePass(
    List<PlayingCard> hand,
    PassDirection direction,
  );

  /// Analyze if AI should attempt to shoot the moon
  ///
  /// [state] - Current game state
  /// Returns a [MoonDecision] with recommendation
  MoonDecision analyzeMoonAttempt(HeartsState state);

  /// Reset tracker for new round
  void resetForNewRound() {
    tracker.reset();
  }

  /// Record cards played in a trick
  void recordTrick(Trick trick) {
    tracker.recordTrick(trick);
  }

  /// Get delay range for this difficulty level
  int get minDelay {
    switch (difficulty) {
      case AiDifficulty.easy:
        return 400;
      case AiDifficulty.medium:
        return 600;
      case AiDifficulty.hard:
        return 800;
    }
  }

  int get maxDelay {
    switch (difficulty) {
      case AiDifficulty.easy:
        return 800;
      case AiDifficulty.medium:
        return 1200;
      case AiDifficulty.hard:
        return 1500;
    }
  }

  /// Get fixed delay for AI thinking (1 second for all difficulties)
  int getRandomDelay() {
    return 1000; // Fixed 1 second delay
  }
}
