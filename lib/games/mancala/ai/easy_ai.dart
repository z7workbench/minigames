import 'dart:math';

import '../models/mancala_state.dart';
import 'mancala_ai.dart';

/// Easy AI that selects a random valid pit.
///
/// Strategy: Pure random selection from available non-empty pits.
/// Good for beginners to learn the game mechanics.
class EasyAi extends MancalaAi {
  final Random _random = Random();

  @override
  Future<AiDecision> decide(MancalaState state) async {
    // Get all valid pits (non-empty pits on AI's side)
    final validPits = state.validPits;

    if (validPits.isEmpty) {
      // No valid moves (shouldn't happen in a normal game)
      throw StateError('No valid pits available for AI');
    }

    // Select a random pit
    final selectedIndex = validPits[_random.nextInt(validPits.length)];

    return AiDecision(
      pitIndex: selectedIndex,
      delayMs: 500 + _random.nextInt(300), // 500-800ms delay
    );
  }
}
