import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/guess_arrangement_state.dart';
import '../guess_arrangement_screen.dart';

/// Pre-game start screen for Guess Arrangement with mode selection and rules.
class GuessArrangementStartScreen extends ConsumerStatefulWidget {
  const GuessArrangementStartScreen({super.key});

  @override
  ConsumerState<GuessArrangementStartScreen> createState() =>
      _GuessArrangementStartScreenState();
}

class _GuessArrangementStartScreenState
    extends ConsumerState<GuessArrangementStartScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark
          ? context.themeBackground
          : context.themeBackground,
      appBar: AppBar(
        title: Text(l10n.game_guess_arrangement),
        backgroundColor: isDark ? context.themePrimary : context.themePrimary,
        foregroundColor: isDark
            ? context.themeOnPrimary
            : context.themeOnPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Game icon
                _buildGameIcon(isDark),
                const SizedBox(height: 32),

                // Game title and description
                _buildTitleSection(context, isDark, l10n),
                const SizedBox(height: 48),

                // Mode selection
                _buildModeSelection(context, isDark, l10n),
                const SizedBox(height: 24),

                // Rules button
                WoodenButton(
                  text: l10n.ga_howToPlay,
                  icon: Icons.help_outline,
                  variant: WoodenButtonVariant.outlined,
                  expandWidth: true,
                  onPressed: () => _showRulesDialog(context, isDark, l10n),
                ),
                const SizedBox(height: 16),

                // Back button
                WoodenButton(
                  text: l10n.back,
                  icon: Icons.arrow_back,
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

  Widget _buildGameIcon(bool isDark) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [context.themeCard, context.themeSurface]
                : [context.themeCard, context.themeSurface],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? context.themeBorder : context.themeBorder,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? context.themeShadow : context.themeShadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(child: Text('🃏', style: TextStyle(fontSize: 50))),
      ),
    );
  }

  Widget _buildTitleSection(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        Text(
          l10n.game_guess_arrangement,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? context.themeTextPrimary : context.themeTextPrimary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Guess Arrangement',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: isDark
                ? context.themeTextSecondary
                : context.themeTextSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.ga_gameDescription,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: isDark
                ? context.themeTextSecondary
                : context.themeTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildModeSelection(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? context.themeSurface : context.themeSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? context.themeBorder : context.themeBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? context.themeShadow : context.themeShadow)
                .withAlpha(128),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.ga_selectGameMode,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? context.themeTextPrimary
                  : context.themeTextPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // 2 Player mode
          WoodenButton(
            text: l10n.ga_twoPlayers,
            icon: Icons.people,
            size: WoodenButtonSize.large,
            variant: WoodenButtonVariant.primary,
            expandWidth: true,
            onPressed: () => _startGame(null),
          ),
          const SizedBox(height: 12),

          // AI modes
          WoodenButton(
            text: l10n.ga_easyAI,
            icon: Icons.computer,
            size: WoodenButtonSize.medium,
            variant: WoodenButtonVariant.secondary,
            expandWidth: true,
            onPressed: () => _startGame(AiDifficulty.easy),
          ),
          const SizedBox(height: 8),
          WoodenButton(
            text: l10n.ga_mediumAI,
            icon: Icons.psychology,
            size: WoodenButtonSize.medium,
            variant: WoodenButtonVariant.secondary,
            expandWidth: true,
            onPressed: () => _startGame(AiDifficulty.medium),
          ),
          const SizedBox(height: 8),
          WoodenButton(
            text: l10n.ga_hardAI,
            icon: Icons.smart_toy,
            size: WoodenButtonSize.medium,
            variant: WoodenButtonVariant.accent,
            expandWidth: true,
            onPressed: () => _startGame(AiDifficulty.hard),
          ),
        ],
      ),
    );
  }

  void _startGame(AiDifficulty? aiDifficulty) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GuessArrangementScreen(aiDifficulty: aiDifficulty),
      ),
    );
  }

  void _showRulesDialog(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDark ? context.themeSurface : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.ga_howToPlay,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? context.themeTextPrimary
                          : context.themeTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRuleItem(l10n.ga_rule1Title, l10n.ga_rule1Desc, isDark),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.ga_rule2Title, l10n.ga_rule2Desc, isDark),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.ga_rule3Title, l10n.ga_rule3Desc, isDark),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.ga_rule4Title, l10n.ga_rule4Desc, isDark),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.ga_rule5Title, l10n.ga_rule5Desc, isDark),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.themeAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(l10n.ga_gotIt),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleItem(String title, String description, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: context.themeAccent,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 13,
            color: isDark
                ? context.themeTextSecondary
                : context.themeTextSecondary,
          ),
        ),
      ],
    );
  }
}
