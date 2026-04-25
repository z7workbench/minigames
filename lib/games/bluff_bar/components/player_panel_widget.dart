import 'package:flutter/material.dart';

import '../models/bluff_bar_player.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';

/// Displays player panel with name, card count, and roulette shots.
/// Shows position name (东/西/南/北) where 南 is always the human player.
class PlayerPanelWidget extends StatelessWidget {
  final BluffBarPlayer player;
  final bool isCurrentTurn;
  final AppLocalizations l10n;

  const PlayerPanelWidget({
    super.key,
    required this.player,
    required this.isCurrentTurn,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final positionName = _getPositionName(player.index);
    final shotsFired = player.rouletteShots; // Cumulative shots (0-6)
    final isEliminated = player.isEliminated;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isEliminated ? 0.5 : 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isCurrentTurn
              ? context.themeAccent.withAlpha(50)
              : context.themeSurface.withAlpha(100),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCurrentTurn ? context.themeAccent : context.themeBorder,
            width: isCurrentTurn ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Player name (东/西/南/北)
            Text(
              positionName,
              style: TextStyle(
                color: context.themeTextPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Card count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: context.themeCard,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.style,
                    size: 12,
                    color: context.themeTextSecondary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${player.cardCount}张',
                    style: TextStyle(
                      color: context.themeTextPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),

            // Roulette shots X/6
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.gps_fixed,
                  size: 11,
                  color: isEliminated ? context.themeError : context.themeTextSecondary,
                ),
                const SizedBox(width: 2),
                Text(
                  '$shotsFired/6',
                  style: TextStyle(
                    color: isEliminated ? context.themeError : context.themeTextPrimary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),

            // Eliminated badge
            if (isEliminated) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.themeError,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  l10n.bb_eliminated,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getPositionName(int index) {
    switch (index) {
      case 0:
        return '南'; // South - Human
      case 1:
        return '东'; // East - AI 1
      case 2:
        return '西'; // West - AI 2
      case 3:
        return '北'; // North - AI 3
      default:
        return '';
    }
  }
}
