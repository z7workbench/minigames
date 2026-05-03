import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../fishing_provider.dart';
import '../fishing_screen.dart';

class FishingStartScreen extends ConsumerStatefulWidget {
  const FishingStartScreen({super.key});

  @override
  ConsumerState<FishingStartScreen> createState() => _FishingStartScreenState();
}

class _FishingStartScreenState extends ConsumerState<FishingStartScreen> {
  void _startGame() {
    ref.read(fishingGameProvider.notifier).startGame();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FishingScreen()),
    );
  }

  Widget _buildGameIcon(bool isDark, ThemeColorSet colors, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.card, colors.surface],
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(color: colors.border, width: 2),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withAlpha(128),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.phishing,
        size: size * 0.5,
        color: isDark ? colors.accent : colors.secondary,
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
          l10n.game_fishing,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: textPrimaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.createdByMinimax,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textSecondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.fishing_gameDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions(
    AppLocalizations l10n,
    BuildContext context,
    Color textPrimaryColor,
    Color textSecondaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: textSecondaryColor.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textSecondaryColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InstructionItem(
            icon: Icons.phishing,
            text: l10n.fishing_step1,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 12),
          _InstructionItem(
            icon: Icons.touch_app,
            text: l10n.fishing_step2,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 12),
          _InstructionItem(
            icon: Icons.speed,
            text: l10n.fishing_step3,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 12),
          _InstructionItem(
            icon: Icons.check_circle,
            text: l10n.fishing_step4,
            color: textPrimaryColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);
    final backgroundColor = themeColors.background;
    final surfaceColor = themeColors.surface;
    final textPrimaryColor = themeColors.textPrimary;
    final textSecondaryColor = themeColors.textSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(l10n.game_fishing),
        backgroundColor: themeColors.primary,
        foregroundColor: themeColors.onPrimary,
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
                        _buildGameIcon(isDark, themeColors, 80),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTitleSection(l10n, context, textPrimaryColor, textSecondaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildInstructions(l10n, context, textPrimaryColor, textSecondaryColor),
                    const SizedBox(height: 32),
                    WoodenButton(
                      text: l10n.newGame,
                      icon: Icons.play_arrow,
                      size: WoodenButtonSize.large,
                      variant: WoodenButtonVariant.primary,
                      expandWidth: true,
                      onPressed: _startGame,
                    ),
                    const SizedBox(height: 16),
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

class _InstructionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InstructionItem({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}