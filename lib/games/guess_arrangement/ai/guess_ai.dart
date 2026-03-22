import '../models/guess_arrangement_state.dart';

/// AI decision containing position and guessed rank value (1-13).
class AiDecision {
  final int position;
  final int guessedRankValue;

  const AiDecision({required this.position, required this.guessedRankValue});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiDecision &&
        position == other.position &&
        guessedRankValue == other.guessedRankValue;
  }

  @override
  int get hashCode => Object.hash(position, guessedRankValue);
}

/// Abstract base class for Guess Arrangement AI.
abstract class GuessAi {
  /// Decide what to guess based on current game state.
  /// Returns an [AiDecision] with position and guessed rank value (1-13).
  Future<AiDecision> decide(GuessArrangementState state);
}
