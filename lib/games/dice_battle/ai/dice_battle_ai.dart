import '../models/dice_battle_state.dart';

/// AI decision for dice battle.
class AiDecision {
  /// Indices of dice to select for attack/defense.
  final List<int> selectedDiceIndices;

  /// Indices of dice to re-roll (attack only).
  final List<int> rerollIndices;

  const AiDecision({
    required this.selectedDiceIndices,
    this.rerollIndices = const [],
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiDecision &&
        _listEquals(selectedDiceIndices, other.selectedDiceIndices) &&
        _listEquals(rerollIndices, other.rerollIndices);
  }

  @override
  int get hashCode =>
      Object.hash(selectedDiceIndices.hashCode, rerollIndices.hashCode);

  static bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Abstract base class for Dice Battle AI.
abstract class DiceBattleAi {
  /// Make a decision based on current game state.
  /// This is called during the dice selection phase.
  Future<AiDecision> decideSelection(DiceBattleState state);

  /// Decide which dice to re-roll (attack phase only).
  /// Returns empty list if no re-roll is needed.
  Future<List<int>> decideReroll(DiceBattleState state);
}
