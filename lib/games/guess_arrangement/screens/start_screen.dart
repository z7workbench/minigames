import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/guess_arrangement_state.dart';
import '../guess_arrangement_screen.dart';

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
      backgroundColor: context.themeBackground,
      appBar: AppBar(
        title: Text(l10n.game_guess_arrangement),
        backgroundColor: context.themePrimary,
        foregroundColor: context.themeOnPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            final padding = isLandscape
                ? const EdgeInsets.symmetric(horizontal: 24, vertical: 8)
                : const EdgeInsets.all(24);

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
                        _buildGameIcon(isDark, 80),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTitleSection(context, isDark, l10n, true)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildModeSelection(context, isDark, l10n),
                    const SizedBox(height: 24),
                    WoodenButton(
                      text: l10n.ga_howToPlay,
                      icon: Icons.help_outline,
                      variant: WoodenButtonVariant.outlined,
                      expandWidth: true,
                      onPressed: () => _showRulesDialog(context, isDark, l10n),
                    ),
                    const SizedBox(height: 16),
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameIcon(bool isDark, double size) {
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
      child: Center(child: Text('🃏', style: TextStyle(fontSize: size * 0.5))),
    );
  }

  Widget _buildTitleSection(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    bool isLandscape,
  ) {
    return Column(
      crossAxisAlignment: isLandscape ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          l10n.game_guess_arrangement,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.themeTextPrimary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Guess Arrangement',
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: context.themeTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.ga_gameDescription,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: context.themeTextSecondary,
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
        color: context.themeSurface,
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
            l10n.ga_selectGameMode,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.themeTextPrimary,
            ),
          ),
          const SizedBox(height: 24),
          WoodenButton(
            text: l10n.ga_twoPlayers,
            icon: Icons.people,
            size: WoodenButtonSize.large,
            variant: WoodenButtonVariant.primary,
            expandWidth: true,
            onPressed: () => _startGame(null),
          ),
          const SizedBox(height: 12),
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