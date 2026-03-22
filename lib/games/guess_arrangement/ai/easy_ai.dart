import 'dart:math';

import '../models/guess_arrangement_state.dart';

import 'guess_ai.dart';

/// Easy AI that makes random guesses.
class EasyAi extends GuessAi {
  final Random _random = Random();

  @override
  Future<AiDecision> decide(GuessArrangementState state) async {
    // Add small delay for natural feel
    await Future.delayed(const Duration(milliseconds: 500));

    // Get opponent's hidden positions
    final opponent = state.opponentPlayer;
    final hiddenPositions = opponent.hand.hiddenPositions;

    if (hiddenPositions.isEmpty) {
      throw StateError('No hidden positions to guess');
    }

    // Random position
    final position = hiddenPositions[_random.nextInt(hiddenPositions.length)];

    // Random rank (1-13)
    final rankValue = _random.nextInt(13) + 1;

    return AiDecision(position: position, guessedRankValue: rankValue);
  }
}
