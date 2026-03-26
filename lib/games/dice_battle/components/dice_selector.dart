import 'package:flutter/material.dart';

import '../../../ui/theme/wooden_colors.dart';
import '../models/dice_battle_player.dart';
import 'battle_dice_widget.dart';

/// A panel for selecting dice during attack or defense phase.
class DiceSelector extends StatelessWidget {
  /// Current player.
  final DiceBattlePlayer player;

  /// Whether this is the attack phase.
  final bool isAttackPhase;

  /// Callback when a dice is selected/deselected.
  final Function(int index) onDiceToggled;

  /// Maximum number of dice that can be selected.
  final int maxSelectable;

  /// Whether to allow unlimited selection (for reroll phase).
  final bool allowUnlimitedSelection;

  /// Maximum dice limit for validation (different from selection limit).
  /// Used in attack phase to show the attack dice limit.
  final int? validationLimit;

  int get selectedCount => player.selectedDiceCount;

  int get selectedSum => player.selectedDiceSum;

  const DiceSelector({
    super.key,
    required this.player,
    required this.isAttackPhase,
    required this.onDiceToggled,
    required this.maxSelectable,
    this.allowUnlimitedSelection = false,
    this.validationLimit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? WoodenColors.darkCard : WoodenColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder,
          width: 2,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isAttackPhase ? 'Attack Dice' : 'Defense Dice',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? WoodenColors.darkTextPrimary
                        : WoodenColors.lightTextPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCountColor(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    // Show selected count vs validation limit if set
                    validationLimit != null
                        ? '$selectedCount / $validationLimit'
                        : '$selectedCount / $maxSelectable',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              // Show different hint based on mode
              allowUnlimitedSelection && validationLimit != null
                  ? '选择骰子重投 (进攻上限: $validationLimit)'
                  : 'Select up to $maxSelectable dice',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? WoodenColors.darkTextSecondary
                    : WoodenColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 12),
            // Dice grid
            LayoutBuilder(
              builder: (context, constraints) {
                final diceSize = ((constraints.maxWidth - 48) / 5).clamp(
                  50.0,
                  70.0,
                );
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(player.dice.length, (index) {
                    final dice = player.dice[index];
                    final canSelect =
                        allowUnlimitedSelection ||
                        selectedCount < maxSelectable ||
                        dice.isSelected;

                    return BattleDiceWidget(
                      value: dice.value,
                      type: dice.type,
                      isSelected: dice.isSelected,
                      isRolling: dice.isRolling,
                      isSelectable: canSelect && dice.value > 0,
                      size: diceSize,
                      onTap: () => onDiceToggled(index),
                    );
                  }),
                );
              },
            ),
            // Sum display - only show if there's space
            if (selectedCount > 0) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: WoodenColors.accentAmber.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: WoodenColors.accentAmber),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAttackPhase ? Icons.sports_mma : Icons.shield,
                      size: 20,
                      color: WoodenColors.accentAmber,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Total: $selectedSum',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: WoodenColors.accentAmber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCountColor(BuildContext context) {
    // Check against validation limit if set
    final limit = validationLimit ?? maxSelectable;

    if (selectedCount == 0) {
      return Colors.grey;
    } else if (selectedCount > limit) {
      // Over limit - show red warning
      return Colors.red;
    } else if (selectedCount == limit) {
      return Colors.green;
    } else {
      return WoodenColors.accentAmber;
    }
  }
}
