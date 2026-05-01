import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../aim_test_provider.dart';
import '../aim_test_screen.dart';
import 'aim_test_settings_page.dart';

class AimTestStartScreen extends ConsumerStatefulWidget {
  const AimTestStartScreen({super.key});

  @override
  ConsumerState<AimTestStartScreen> createState() =>
      _AimTestStartScreenState();
}

class _AimTestStartScreenState extends ConsumerState<AimTestStartScreen> {
  void _startGame() {
    ref.read(aimTestGameProvider.notifier).startGame();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AimTestScreen()),
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
        Icons.gps_fixed,
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
    bool isLandscape,
  ) {
    return Column(
      crossAxisAlignment: isLandscape ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.game_aim_test,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: textPrimaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.createdByMinimax,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textSecondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.at_gameDescription,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);
    final backgroundColor = themeColors.background;
    final surfaceColor = themeColors.surface;
    final textPrimaryColor = themeColors.textPrimary;
    final textSecondaryColor = themeColors.textSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(l10n.game_aim_test),
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
                        Expanded(child: _buildTitleSection(l10n, context, textPrimaryColor, textSecondaryColor, true)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    WoodenButton(
                      text: l10n.settings,
                      icon: Icons.settings,
                      size: WoodenButtonSize.medium,
                      variant: WoodenButtonVariant.secondary,
                      expandWidth: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AimTestSettingsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    WoodenButton(
                      text: l10n.at_startGame,
                      icon: Icons.play_arrow,
                      size: WoodenButtonSize.large,
                      variant: WoodenButtonVariant.primary,
                      expandWidth: true,
                      onPressed: _startGame,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: themeColors.border, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.at_instructions,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: textPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.at_instructions,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: textSecondaryColor,
                            ),
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
