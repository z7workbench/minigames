import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/enums.dart';
import '../bluff_bar_screen.dart';

class BluffBarStartScreen extends ConsumerStatefulWidget {
  const BluffBarStartScreen({super.key});

  @override
  ConsumerState<BluffBarStartScreen> createState() =>
      _BluffBarStartScreenState();
}

class _BluffBarStartScreenState extends ConsumerState<BluffBarStartScreen> {
  AiDifficulty _aiDifficulty = AiDifficulty.medium;

  void _startGame() {
    final aiDifficulties = List.filled(3, _aiDifficulty);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BluffBarScreen(
          aiDifficulties: aiDifficulties,
        ),
      ),
    );
  }

  void _showRules() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: context.themeSurface,
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
                    l10n.bb_how_to_play,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.themeTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: context.themeTextSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRuleItem(l10n.bb_rule1_title, l10n.bb_rule1_desc),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.bb_rule2_title, l10n.bb_rule2_desc),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.bb_rule3_title, l10n.bb_rule3_desc),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.bb_rule4_title, l10n.bb_rule4_desc),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.bb_rule5_title, l10n.bb_rule5_desc),
              const SizedBox(height: 24),
              Center(
                child: WoodenButton(
                  text: l10n.ok,
                  variant: WoodenButtonVariant.primary,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleItem(String title, String description) {
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
          style: TextStyle(fontSize: 13, color: context.themeTextSecondary),
        ),
      ],
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
            color: context.themeShadow.withAlpha(128),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.local_bar,
        size: size * 0.6,
        color: isDark ? context.themeAccent : context.themeSecondary,
      ),
    );
  }

  Widget _buildTitleSection(AppLocalizations l10n, bool isLandscape) {
    return Column(
      crossAxisAlignment: isLandscape ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.bb_game_title,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.themeTextPrimary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.bb_game_subtitle,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: context.themeTextSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.createdByGlm,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: TextStyle(fontSize: 12, color: context.themeAccent),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.bb_gameDescription,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: TextStyle(fontSize: 14, color: context.themeTextSecondary),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.themeBackground,
      appBar: AppBar(
        title: Text(l10n.bb_game_title),
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
                        Expanded(child: _buildTitleSection(l10n, true)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsPanel(context, l10n),
                    const SizedBox(height: 24),
                    WoodenButton(
                      text: l10n.bb_how_to_play,
                      icon: Icons.help_outline,
                      variant: WoodenButtonVariant.outlined,
                      expandWidth: true,
                      onPressed: _showRules,
                    ),
                    const SizedBox(height: 12),
                    WoodenButton(
                      text: l10n.bb_start_game,
                      icon: Icons.play_arrow,
                      variant: WoodenButtonVariant.primary,
                      size: WoodenButtonSize.large,
                      expandWidth: true,
                      onPressed: _startGame,
                    ),
                    const SizedBox(height: 12),
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

  Widget _buildSettingsPanel(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.themeBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: context.themeShadow.withAlpha(77),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.bb_ai_difficulty,
            style: TextStyle(
              color: context.themeTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildDifficultyChip(l10n.easy, AiDifficulty.easy),
              _buildDifficultyChip(l10n.normal, AiDifficulty.medium),
              _buildDifficultyChip(l10n.hard, AiDifficulty.hard),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.people, size: 20, color: context.themeTextSecondary),
              const SizedBox(width: 8),
              Text(
                l10n.bb_one_player_three_ai,
                style: TextStyle(
                  color: context.themeTextSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String label, AiDifficulty difficulty) {
    final isSelected = _aiDifficulty == difficulty;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _aiDifficulty = difficulty;
          });
        }
      },
      selectedColor: context.themeSelectionColor,
      checkmarkColor: context.themeOnAccent,
      backgroundColor: context.themeCard,
      labelStyle: TextStyle(
        color: isSelected ? context.themeOnAccent : context.themeTextPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}