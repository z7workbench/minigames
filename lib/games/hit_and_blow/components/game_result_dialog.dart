import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';

/// A dialog that shows the game result (win or lose)
class GameResultDialog extends StatelessWidget {
  const GameResultDialog({
    super.key,
    required this.isWin,
    required this.attempts,
    required this.duration,
    required this.onPlayAgain,
    required this.onGoHome,
    this.targetNumber,
  });

  final bool isWin;
  final int attempts;
  final Duration duration;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoHome;
  final List<int>? targetNumber;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: context.themeSurface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Result icon
            Icon(
              isWin ? Icons.check_circle : Icons.cancel,
              size: 64,
              color: isWin ? context.themeSuccess : context.themeError,
            ),
            const SizedBox(height: 16),
            // Result text
            Text(
              isWin ? l10n.hnb_gameWon : l10n.hnb_gameLost,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (!isWin && targetNumber != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: context.themeCard,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.themeBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${l10n.hnb_targetNumber}: ',
                      style: TextStyle(
                        color: context.themeTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ...targetNumber!.map((digit) => Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: context.themeAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          digit.toString(),
                          style: TextStyle(
                            color: context.themeOnAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            // Stats
            Text(
              '${l10n.hnb_attemptsUsed}: $attempts',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${l10n.duration}: ${_formatDuration(duration)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: onGoHome, child: Text(l10n.back)),
                ElevatedButton(
                  onPressed: onPlayAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.themeAccent,
                    foregroundColor: context.themeOnAccent,
                  ),
                  child: Text(l10n.newGame),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
