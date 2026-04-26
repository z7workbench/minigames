import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/enums.dart';
import '../hearts_screen.dart';

class HeartsStartScreen extends ConsumerStatefulWidget {
  const HeartsStartScreen({super.key});

  @override
  ConsumerState<HeartsStartScreen> createState() => _HeartsStartScreenState();
}

class _HeartsStartScreenState extends ConsumerState<HeartsStartScreen> {
  AiDifficulty _aiDifficulty = AiDifficulty.medium;
  TimerOption _timerOption = TimerOption.seconds15;
  MoonAnnouncementOption _moonOption = MoonAnnouncementOption.hidden;

  void _startGame() {
    final aiDifficulties = List.filled(3, _aiDifficulty);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HeartsScreen(
          aiDifficulties: aiDifficulties,
          timerOption: _timerOption,
          moonOption: _moonOption,
        ),
      ),
    );
  }

  void _showRules() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    l10n.hearts_howToPlay,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.themeTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRuleItem(l10n.hearts_rule1Title, l10n.hearts_rule1Desc),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.hearts_rule2Title, l10n.hearts_rule2Desc),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.hearts_rule3Title, l10n.hearts_rule3Desc),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.hearts_rule4Title, l10n.hearts_rule4Desc),
              const SizedBox(height: 12),
              _buildRuleItem(l10n.hearts_rule5Title, l10n.hearts_rule5Desc),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.themeAccent,
                    foregroundColor: isDark ? Colors.white : Colors.black,
                  ),
                  child: Text(l10n.ok),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLoadGame() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Load game feature coming soon'),
        duration: Duration(seconds: 2),
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
      child: Center(
        child: Text('♥', style: TextStyle(fontSize: size * 0.6, color: Colors.red)),
      ),
    );
  }

  Widget _buildTitleSection(AppLocalizations l10n, bool isLandscape) {
    return Column(
      crossAxisAlignment: isLandscape ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.hearts_game_hearts,
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
          l10n.hearts_description,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: TextStyle(fontSize: 14, color: context.themeTextSecondary),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.themeBackground,
      appBar: AppBar(
        title: Text(l10n.hearts_game_hearts),
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
                      text: l10n.hearts_howToPlay,
                      icon: Icons.help_outline,
                      variant: WoodenButtonVariant.outlined,
                      expandWidth: true,
                      onPressed: _showRules,
                    ),
                    const SizedBox(height: 12),
                    WoodenButton(
                      text: l10n.hearts_startGame,
                      icon: Icons.play_arrow,
                      variant: WoodenButtonVariant.primary,
                      size: WoodenButtonSize.large,
                      expandWidth: true,
                      onPressed: _startGame,
                    ),
                    const SizedBox(height: 12),
                    WoodenButton(
                      text: l10n.hearts_loadGame,
                      icon: Icons.folder_open,
                      variant: WoodenButtonVariant.secondary,
                      expandWidth: true,
                      onPressed: _showLoadGame,
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
            l10n.hearts_aiDifficulty,
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
              _buildDifficultyChip(
                _getDifficultyLabel(AiDifficulty.easy),
                AiDifficulty.easy,
              ),
              _buildDifficultyChip(
                _getDifficultyLabel(AiDifficulty.medium),
                AiDifficulty.medium,
              ),
              _buildDifficultyChip(
                _getDifficultyLabel(AiDifficulty.hard),
                AiDifficulty.hard,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.hearts_passTimerSetting,
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
              _buildTimerChip(
                l10n.hearts_timerUnlimited,
                TimerOption.unlimited,
              ),
              _buildTimerChip(l10n.hearts_timer15s, TimerOption.seconds15),
              _buildTimerChip(l10n.hearts_timer20s, TimerOption.seconds20),
              _buildTimerChip(l10n.hearts_timer30s, TimerOption.seconds30),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.hearts_announceMoonOption,
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
              _buildMoonChip(
                l10n.hearts_hideMoonOption,
                MoonAnnouncementOption.hidden,
              ),
              _buildMoonChip(
                l10n.hearts_announceMoonOption,
                MoonAnnouncementOption.announced,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDifficultyLabel(AiDifficulty difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return 'Easy';
      case AiDifficulty.medium:
        return 'Medium';
      case AiDifficulty.hard:
        return 'Hard';
    }
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

  Widget _buildTimerChip(String label, TimerOption option) {
    final isSelected = _timerOption == option;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _timerOption = option;
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

  Widget _buildMoonChip(String label, MoonAnnouncementOption option) {
    final isSelected = _moonOption == option;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _moonOption = option;
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