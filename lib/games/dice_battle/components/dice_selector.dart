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

  /// Current number of selected dice.
  int get selectedCount => player.selectedDiceCount;

  /// Sum of selected dice values.
  int get selectedSum => player.selectedDiceSum;

  const DiceSelector({
    super.key,
    required this.player,
    required this.isAttackPhase,
    required this.onDiceToggled,
    required this.maxSelectable,
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
      child: Column(
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
                  '$selectedCount / $maxSelectable',
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
            'Select up to $maxSelectable dice',
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
                      selectedCount < maxSelectable || dice.isSelected;

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
          const SizedBox(height: 12),
          // Sum display
          if (selectedCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      ),
    );
  }

  Color _getCountColor(BuildContext context) {
    if (selectedCount == 0) {
      return Colors.grey;
    } else if (selectedCount < maxSelectable) {
      return WoodenColors.accentAmber;
    } else {
      return Colors.green;
    }
  }
}
