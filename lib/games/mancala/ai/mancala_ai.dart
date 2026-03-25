import '../models/mancala_state.dart';

/// Decision returned by AI after analyzing the game state.
class AiDecision {
  /// The pit index to sow from (0-5 for Player 1's side, 7-12 for Player 2's side).
  final int pitIndex;

  /// Optional delay in milliseconds before executing the move.
  /// Used to make AI feel more natural.
  final int delayMs;

  const AiDecision({required this.pitIndex, this.delayMs = 500});
}

/// Abstract base class for Mancala AI implementations.
///
/// Implementations must provide a [decide] method that analyzes
/// the current game state and returns the best pit to sow from.
abstract class MancalaAi {
  /// Analyze the game state and return the best move.
  ///
  /// The [state] parameter contains the current board position.
  /// Returns an [AiDecision] with the selected pit index.
  ///
  /// The implementation should:
  /// 1. Only consider valid pits (non-empty pits on AI's side)
  /// 2. Return a decision within reasonable time (hard AI has depth limit)
  /// 3. Include an appropriate delay for natural feel
  Future<AiDecision> decide(MancalaState state);
}
