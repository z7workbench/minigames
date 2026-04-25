import 'dart:math';
import '../models/bluff_bar_state.dart';
import '../models/enums.dart';
import 'bluff_bar_ai.dart';
import 'ai_decision.dart';

class EasyBluffBarAi extends BluffBarAi {
  final Random _random = Random();
  
  EasyBluffBarAi() : super(
    name: 'Easy',
    difficulty: AiDifficulty.easy,
    aggressionFactor: 0.3, // Conservative - rarely challenges
  );
  
  @override
  Future<AiPlayDecision> decidePlay(BluffBarState state) async {
    final player = state.currentPlayer;
    final targetRank = state.targetCard!;
    final handSize = player.hand.length;
    
    // In Bluff Bar, you MUST claim the target card rank!
    // There's no option to claim a different rank.
    
    // Random number of cards (1 to min(4, handSize))
    final numCards = _random.nextInt(min(4, handSize)) + 1;
    
    // Random card indices
    final indices = <int>[];
    while (indices.length < numCards) {
      final idx = _random.nextInt(handSize);
      if (!indices.contains(idx)) indices.add(idx);
    }
    
    // ALWAYS claim the target card rank (this is the game rule!)
    return AiPlayDecision(
      cardIndices: indices,
      claimedRank: targetRank,
      delayMs: getRandomDelay(),
    );
  }
  
  @override
  Future<AiChallengeDecision> decideChallenge(BluffBarState state) async {
    // Challenge probability = aggressionFactor
    // Easy AI (0.3) → 30% chance to challenge
    final shouldChallenge = _random.nextDouble() < aggressionFactor;
    
    return AiChallengeDecision(
      shouldChallenge: shouldChallenge,
      reasoning: 'Random challenge ($aggressionFactor probability)',
    );
  }
}