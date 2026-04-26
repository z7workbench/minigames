import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/yacht_dice_state.dart';
import '../yacht_dice_provider.dart';
import '../yacht_dice_screen.dart';

class YachtDiceStartScreen extends ConsumerStatefulWidget {
  const YachtDiceStartScreen({super.key});

  @override
  ConsumerState<YachtDiceStartScreen> createState() =>
      _YachtDiceStartScreenState();
}

class _YachtDiceStartScreenState extends ConsumerState<YachtDiceStartScreen> {
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
      debugPrint('Error checking for saved game: $e');
      if (mounted) {
        _startGame(playerCount, aiDifficulty, null);
      }
    }
  }

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
      _startGame(playerCount, aiDifficulty, savedState);
    } else if (result == false) {
      await ref
          .read(yachtDiceGameProvider.notifier)
          .deleteSavedGame(aiDifficulty);
      _startGame(playerCount, aiDifficulty, null);
    }
  }

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

  Widget _buildGameIcon(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.themeCard, context.themeSurface],
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
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
        size: size * 0.5,
        color: context.themeAccent,
      ),
    );
  }

  Widget _buildTitleSection(
    AppLocalizations l10n,
    BuildContext context,
    Color textPrimaryColor,
    Color textSecondaryColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.game_yacht_dice,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: textPrimaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.yd_gameDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textSecondaryColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            final padding = isLandscape
                ? const EdgeInsets.symmetric(horizontal: 24, vertical: 8)
                : const EdgeInsets.all(24.0);

            return Center(
              child: SingleChildScrollView(
                padding: padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGameIcon(80),
                        const SizedBox(width: 16),
                        _buildTitleSection(l10n, context, textPrimaryColor, textSecondaryColor),
                      ],
                    ),
                    const SizedBox(height: 24),
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
                          const SizedBox(height: 24),
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
                                  onPressed: () => _checkForSavedGameAndStart(2, null),
                                ),
                                WoodenButton(
                                  text: l10n.yd_easyAI,
                                  icon: Icons.computer,
                                  size: WoodenButtonSize.large,
                                  variant: WoodenButtonVariant.secondary,
                                  expandWidth: true,
                                  onPressed: () => _checkForSavedGameAndStart(1, AiDifficulty.easy),
                                ),
                                WoodenButton(
                                  text: l10n.yd_mediumAI,
                                  icon: Icons.psychology,
                                  size: WoodenButtonSize.large,
                                  variant: WoodenButtonVariant.secondary,
                                  expandWidth: true,
                                  onPressed: () => _checkForSavedGameAndStart(1, AiDifficulty.medium),
                                ),
                                WoodenButton(
                                  text: l10n.yd_hardAI,
                                  icon: Icons.smart_toy,
                                  size: WoodenButtonSize.large,
                                  variant: WoodenButtonVariant.accent,
                                  expandWidth: true,
                                  onPressed: () => _checkForSavedGameAndStart(1, AiDifficulty.hard),
                                ),
                              ];

                              if (isWidescreen) {
                                return GridView.count(
                                  crossAxisCount: 4,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 3.0,
                                  children: buttons,
                                );
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    for (int i = 0; i < buttons.length; i++) ...[
                                      buttons[i],
                                      if (i < buttons.length - 1) const SizedBox(height: 16),
                                    ],
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
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
            );
          },
        ),
      ),
    );
  }
}