import 'package:flutter/material.dart';

import '../models/bluff_bar_player.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';

/// Displays player information (name, card count, status) at a table position.
/// Responsive design supporting both portrait and landscape orientations.
class PlayerInfoWidget extends StatelessWidget {
  final BluffBarPlayer player;
  final bool isCurrentTurn;
  final bool isEliminated;
  final String positionLabel;
  final AppLocalizations? l10n;

  const PlayerInfoWidget({
    super.key,
    required this.player,
    required this.positionLabel,
    this.isCurrentTurn = false,
    this.isEliminated = false,
    this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final eliminatedOpacity = isEliminated || player.isEliminated ? 0.5 : 1.0;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: eliminatedOpacity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isCurrentTurn
              ? context.themeAccent.withAlpha(50)
              : context.themeSurface.withAlpha(100),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrentTurn
                ? context.themeAccent
                : context.themeBorder,
            width: isCurrentTurn ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Player name and icon
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  player.isHuman ? Icons.person : Icons.smart_toy,
                  color: isCurrentTurn
                      ? context.themeAccent
                      : context.themeTextSecondary,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    player.name,
                    style: TextStyle(
                      color: context.themeTextPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Card count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: context.themeCard,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: context.themeBorder),
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
                    '${player.cardCount}',
                    style: TextStyle(
                      color: context.themeTextPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Eliminated badge
            if (isEliminated || player.isEliminated) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.themeError,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'ELIMINATED', // This will be replaced with localization
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
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
}