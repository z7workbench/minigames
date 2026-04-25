import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';

/// Full-screen overlay widget for Russian roulette in Bluff Bar.
/// Displays player name, shots fired, remaining chances, and draw button.
/// Only human players see the draw button - AI auto-draws.
class RouletteOverlayWidget extends StatelessWidget {
  final String playerName;
  final int shotsFired;
  final int remainingChances;
  final bool isHuman;
  final bool showResult;
  final bool survived;
  final VoidCallback? onDraw;

  const RouletteOverlayWidget({
    super.key,
    required this.playerName,
    required this.shotsFired,
    required this.remainingChances,
    required this.isHuman,
    this.showResult = false,
    this.survived = false,
    this.onDraw,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: context.themeBackground.withAlpha(200),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.themeSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: showResult
                  ? (survived ? context.themeSuccess : context.themeError)
                  : context.themeWarning,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: context.themeShadow.withAlpha(100),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Roulette icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.themeWarning.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.gps_fixed,
                  size: 48,
                  color: context.themeWarning,
                ),
              ),
              const SizedBox(height: 16),

              // Player name
              Text(
                playerName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.themeTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

// Shots fired
              Text(
                '已开 $shotsFired/6 枪',
                style: TextStyle(
                  fontSize: 16,
                  color: context.themeTextSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Draw button (only for human, before result)
              if (!showResult && isHuman && onDraw != null)
                ElevatedButton(
                  onPressed: onDraw,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.themeError,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    l10n.bb_draw_card,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // Result display
              if (showResult) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: survived ? context.themeSuccess : context.themeError,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (survived
                                ? context.themeSuccess
                                : context.themeError)
                            .withAlpha(100),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        survived ? Icons.check_circle : Icons.dangerous,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        survived ? l10n.bb_survived : l10n.bb_eliminated,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
