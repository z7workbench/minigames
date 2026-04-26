import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../twenty48_provider.dart';
import '../twenty48_screen.dart';
import 'twenty48_load_screen.dart';

class Twenty48StartScreen extends ConsumerStatefulWidget {
  const Twenty48StartScreen({super.key});

  @override
  ConsumerState<Twenty48StartScreen> createState() =>
      _Twenty48StartScreenState();
}

class _Twenty48StartScreenState extends ConsumerState<Twenty48StartScreen> {
  bool _hasSaves = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkForSaves();
  }

  Future<void> _checkForSaves() async {
    final hasSaves = await ref.read(twenty48GameProvider.notifier).hasSaves();
    if (mounted) {
      setState(() {
        _hasSaves = hasSaves;
        _isLoading = false;
      });
    }
  }

  void _startNewGame() {
    ref.read(twenty48GameProvider.notifier).startNewGame();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Twenty48Screen()),
    );
  }

  void _showLoadScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Twenty48LoadScreen()),
    ).then((_) => _checkForSaves());
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
        Icons.grid_4x4,
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
          l10n.game_2048,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: textPrimaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.t48_gameDescription,
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
        title: Text(l10n.game_2048),
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
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: themeColors.border, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: themeColors.shadow.withAlpha(128),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.t48_instructions,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          WoodenButton(
                            text: l10n.t48_newGame,
                            icon: Icons.play_arrow,
                            size: WoodenButtonSize.large,
                            variant: WoodenButtonVariant.primary,
                            expandWidth: true,
                            onPressed: _startNewGame,
                          ),
                          if (!_isLoading) ...[
                            const SizedBox(height: 16),
                            WoodenButton(
                              text: l10n.t48_loadGame,
                              icon: Icons.folder_open,
                              size: WoodenButtonSize.large,
                              variant: _hasSaves
                                  ? WoodenButtonVariant.secondary
                                  : WoodenButtonVariant.ghost,
                              expandWidth: true,
                              onPressed: _hasSaves ? _showLoadScreen : null,
                            ),
                          ],
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