import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/bluff_bar_player.dart';

/// Full-screen overlay widget displayed at game end showing results and rankings.
///
/// This overlay shows:
/// - Game result (胜利/失败) with appropriate styling
/// - Player rankings sorted by survival status then rounds survived
/// - Individual player details (position, elimination status, rounds survived)
/// - Action buttons (play again, exit)
class GameEndOverlayWidget extends StatelessWidget {
  /// Whether the human player won (true = victory, false = eliminated/defeated)
  final bool humanWon;

  /// All 4 players sorted by:
  /// 1. Survivors first (isEliminated = false)
  /// 2. Then by rounds survived (descending)
  final List<BluffBarPlayer> rankings;

  /// Callback when "Play Again" button is pressed
  final VoidCallback? onPlayAgain;

  /// Callback when "Exit" button is pressed
  final VoidCallback? onExit;

  const GameEndOverlayWidget({
    super.key,
    required this.humanWon,
    required this.rankings,
    this.onPlayAgain,
    this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      // Semi-transparent overlay background
      color: context.themeBackground.withAlpha(220),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.themeSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: humanWon ? context.themeAccent : context.themeError,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: context.themeShadow,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Result icon and text
              _buildResultSection(context, l10n),
              const SizedBox(height: 24),

              // Rankings section
              _buildRankingsSection(context, l10n),
              const SizedBox(height: 24),

              // Action buttons
              _buildButtonsSection(context, l10n),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the result section with icon and text
  Widget _buildResultSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // Large result icon
        Icon(
          humanWon ? Icons.emoji_events : Icons.close,
          size: 64,
          color: humanWon ? context.themeAccent : context.themeError,
        ),
        const SizedBox(height: 16),

        // Result text (Victory/Defeat)
        Text(
          humanWon ? l10n.bb_victory : l10n.bb_defeat,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: humanWon ? context.themeAccent : context.themeError,
          ),
        ),
      ],
    );
  }

  /// Build the rankings section with all players
  Widget _buildRankingsSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // Section title
        Text(
          l10n.bb_ranking,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: context.themeTextPrimary,
          ),
        ),
        const SizedBox(height: 12),

        // Player ranking list
        ...rankings.asMap().entries.map((entry) {
          final rank = entry.key + 1;
          final player = entry.value;
          final positionName = _getPositionName(player.index);

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              // Eliminated players have faded background
              color: player.isEliminated
                  ? context.themeCard.withAlpha(100)
                  : context.themeAccent.withAlpha(50),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: player.isEliminated
                    ? context.themeBorder
                    : context.themeAccent.withAlpha(100),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Rank + Position + Status
                Row(
                  children: [
                    // Rank number
                    Text(
                      '$rank.',
                      style: TextStyle(
                        color: context.themeTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Position name (东/西/南/北)
                    Text(
                      positionName,
                      style: TextStyle(
                        color: context.themeTextPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    // Elimination badge
                    if (player.isEliminated) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.themeError.withAlpha(50),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: context.themeError,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          l10n.bb_eliminated,
                          style: TextStyle(
                            color: context.themeError,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Right side: Rounds survived
                Text(
                  l10n.bb_rounds_survived(player.roundsSurvived),
                  style: TextStyle(
                    color: context.themeTextSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  /// Build the action buttons section
  Widget _buildButtonsSection(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Play Again button
        WoodenButton(
          text: l10n.bb_play_again,
          icon: Icons.refresh,
          variant: WoodenButtonVariant.primary,
          size: WoodenButtonSize.medium,
          onPressed: onPlayAgain,
        ),
        // Exit button
        WoodenButton(
          text: l10n.bb_exit,
          icon: Icons.exit_to_app,
          variant: WoodenButtonVariant.secondary,
          size: WoodenButtonSize.medium,
          onPressed: onExit,
        ),
      ],
    );
  }

  /// Convert player index to position name (Chinese wind directions)
  ///
  /// Index mapping:
  /// - 0 → 南 (South) - Human player typically
  /// - 1 → 东 (East)
  /// - 2 → 西 (West)
  /// - 3 → 北 (North)
  String _getPositionName(int index) {
    switch (index) {
      case 0:
        return '南';
      case 1:
        return '东';
      case 2:
        return '西';
      case 3:
        return '北';
      default:
        return 'P${index + 1}';
    }
  }
}
