import '../models/scoring_category.dart';
import '../models/yacht_dice_state.dart';

abstract class YachtAi {
  /// Decide what action to take based on the current game state
  Future<AiDecision> decide(YachtDiceState state);
}

class AiDecision {
  /// Which dice to keep (true = keep, false = re-roll)
  /// Length should be 5 (for 5 dice)
  final List<bool> diceToKeep;

  /// Which scoring category to select (null if still rolling dice)
  final ScoringCategory? categoryToSelect;

  const AiDecision({required this.diceToKeep, this.categoryToSelect});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AiDecision) return false;

    return diceToKeep == other.diceToKeep &&
        categoryToSelect == other.categoryToSelect;
  }

  @override
  int get hashCode => Object.hash(diceToKeep, categoryToSelect);
}
