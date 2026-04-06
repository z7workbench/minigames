import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/yacht_dice_state.dart';
import '../yacht_dice_provider.dart';
import '../yacht_dice_screen.dart';

/// Pre-game start screen for Yacht Dice allowing players to select game mode.
///
/// Provides options for:
/// - 2 Player mode (local multiplayer)
/// - vs AI Easy mode
/// - vs AI Hard mode
class YachtDiceStartScreen extends ConsumerStatefulWidget {
  /// Creates the Yacht Dice start screen.
  const YachtDiceStartScreen({super.key});

  @override
  ConsumerState<YachtDiceStartScreen> createState() =>
      _YachtDiceStartScreenState();
}

class _YachtDiceStartScreenState extends ConsumerState<YachtDiceStartScreen> {
  /// Check for saved game and show resume dialog if exists
  Future<void> _checkForSavedGameAndStart(
    int playerCount,
    AiDifficulty? aiDifficulty,
  ) async {
    try {
      final savedState = await ref
          .read(yachtDiceGameProvider.notifier)
          .checkForSavedGame(aiDifficulty);

      if (!mounted) return;

      if (savedState != null) {
        _showResumeGameDialog(playerCount, aiDifficulty, savedState);
      } else {
        _startGame(playerCount, aiDifficulty, null);
      }
    } catch (e) {
      // If there's an error checking for saves, just start a new game
      debugPrint('Error checking for saved game: $e');
      if (mounted) {
        _startGame(playerCount, aiDifficulty, null);
      }
    }
  }

  /// Show dialog asking user to resume or start new game
  Future<void> _showResumeGameDialog(
    int playerCount,
    AiDifficulty? aiDifficulty,
    YachtDiceState savedState,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.yd_resumeTitle),
        content: Text(l10n.yd_resumeMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.yd_startNewGame),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.themeAccent,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.yd_resumeGame),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (result == true) {
      // Resume saved game
      _startGame(playerCount, aiDifficulty, savedState);
    } else if (result == false) {
      // Delete save and start new game
      await ref
          .read(yachtDiceGameProvider.notifier)
          .deleteSavedGame(aiDifficulty);
      _startGame(playerCount, aiDifficulty, null);
    }
  }

  /// Navigate to the game screen with the selected mode
  void _startGame(
    int playerCount,
    AiDifficulty? aiDifficulty,
    YachtDiceState? restoredState,
  ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => YachtDiceScreen(
          playerCount: playerCount,
          aiDifficulty: aiDifficulty,
          restoredState: restoredState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Theme-aware colors
    final backgroundColor = context.themeBackground;
    final surfaceColor = context.themeSurface;
    final textPrimaryColor = context.themeTextPrimary;
    final textSecondaryColor = context.themeTextSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(l10n.game_yacht_dice),
        backgroundColor: context.themePrimary,
        foregroundColor: context.themeOnPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: l10n.back,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Game icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [context.themeCard, context.themeSurface],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: context.themeBorder, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: context.themeShadow.withAlpha(80),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.casino,
                    size: 50,
                    color: context.themeAccent,
                  ),
                ),
                const SizedBox(height: 32),

                // Game title
                Text(
                  l10n.game_yacht_dice,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: textPrimaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),

                // Game description
                Text(
                  l10n.yd_gameDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: textSecondaryColor),
                ),
                const SizedBox(height: 48),

                // Game mode selection container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.themeBorder, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: context.themeShadow.withAlpha(128),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Section title
                      Text(
                        l10n.yd_selectPlayers,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.yd_instructions,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Game mode buttons with responsive layout
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWidescreen = constraints.maxWidth >= 600;
                          final buttons = <Widget>[
                            WoodenButton(
                              text: l10n.yd_twoPlayers,
                              icon: Icons.people,
                              size: WoodenButtonSize.large,
                              variant: WoodenButtonVariant.primary,
                              expandWidth: true,
                              onPressed: () =>
                                  _checkForSavedGameAndStart(2, null),
                            ),
                            WoodenButton(
                              text: l10n.yd_easyAI,
                              icon: Icons.computer,
                              size: WoodenButtonSize.large,
                              variant: WoodenButtonVariant.secondary,
                              expandWidth: true,
                              onPressed: () => _checkForSavedGameAndStart(
                                1,
                                AiDifficulty.easy,
                              ),
                            ),
                            WoodenButton(
                              text: l10n.yd_mediumAI,
                              icon: Icons.psychology,
                              size: WoodenButtonSize.large,
                              variant: WoodenButtonVariant.secondary,
                              expandWidth: true,
                              onPressed: () => _checkForSavedGameAndStart(
                                1,
                                AiDifficulty.medium,
                              ),
                            ),
                            WoodenButton(
                              text: l10n.yd_hardAI,
                              icon: Icons.smart_toy,
                              size: WoodenButtonSize.large,
                              variant: WoodenButtonVariant.accent,
                              expandWidth: true,
                              onPressed: () => _checkForSavedGameAndStart(
                                1,
                                AiDifficulty.hard,
                              ),
                            ),
                          ];

                          if (isWidescreen) {
                            // Two-column layout for widescreen
                            return GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 3.5,
                              children: buttons,
                            );
                          } else {
                            // Single column layout for mobile
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (int i = 0; i < buttons.length; i++) ...[
                                  buttons[i],
                                  if (i < buttons.length - 1)
                                    const SizedBox(height: 16),
                                ],
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Back button
                WoodenButton(
                  text: l10n.back,
                  icon: Icons.arrow_back,
                  size: WoodenButtonSize.medium,
                  variant: WoodenButtonVariant.ghost,
                  expandWidth: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
