import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/wooden_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../twenty48_provider.dart';
import '../twenty48_screen.dart';
import 'twenty48_load_screen.dart';

/// Start screen for the 2048 game.
class Twenty48StartScreen extends ConsumerStatefulWidget {
  /// Creates the 2048 start screen.
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? WoodenColors.darkBackground
        : WoodenColors.lightBackground;
    final surfaceColor = isDark
        ? WoodenColors.darkSurface
        : WoodenColors.lightSurface;
    final textPrimaryColor = isDark
        ? WoodenColors.darkTextPrimary
        : WoodenColors.lightTextPrimary;
    final textSecondaryColor = isDark
        ? WoodenColors.darkTextSecondary
        : WoodenColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(l10n.game_2048),
        backgroundColor: isDark
            ? WoodenColors.darkPrimary
            : WoodenColors.lightPrimary,
        foregroundColor: isDark
            ? WoodenColors.darkOnPrimary
            : WoodenColors.lightOnPrimary,
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
                      colors: isDark
                          ? [WoodenColors.darkCard, WoodenColors.darkSurface]
                          : [WoodenColors.lightCard, WoodenColors.lightSurface],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? WoodenColors.darkBorder
                          : WoodenColors.lightBorder,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? WoodenColors.darkShadow
                            : WoodenColors.lightShadow,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.grid_4x4,
                    size: 50,
                    color: isDark
                        ? WoodenColors.accentGold
                        : WoodenColors.lightSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Game title
                Text(
                  l10n.game_2048,
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
                  l10n.t48_gameDescription,
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
                    border: Border.all(
                      color: isDark
                          ? WoodenColors.darkBorder
                          : WoodenColors.lightBorder,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? WoodenColors.darkShadow.withAlpha(128)
                            : WoodenColors.lightShadow.withAlpha(128),
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
                        l10n.t48_instructions,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // New Game button
                      WoodenButton(
                        text: l10n.t48_newGame,
                        icon: Icons.play_arrow,
                        size: WoodenButtonSize.large,
                        variant: WoodenButtonVariant.primary,
                        expandWidth: true,
                        onPressed: _startNewGame,
                      ),
                      const SizedBox(height: 16),

                      // Continue button
                      if (!_isLoading) ...[
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
