import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/reaction_test_state.dart';
import '../reaction_test_provider.dart';
import '../reaction_test_screen.dart';
import '../widgets/reaction_test_leaderboard.dart';

class ReactionTestStartScreen extends ConsumerStatefulWidget {
  const ReactionTestStartScreen({super.key});

  @override
  ConsumerState<ReactionTestStartScreen> createState() =>
      _ReactionTestStartScreenState();
}

class _ReactionTestStartScreenState
    extends ConsumerState<ReactionTestStartScreen> {
  Color? _customBeforeColor;
  Color? _customAfterColor;

  void _startGame() {
    ref.read(reactionTestGameProvider.notifier).startGame();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ReactionTestScreen()),
    );
  }

  void _onCustomBeforeColorSelected(Color color) {
    setState(() => _customBeforeColor = color);
    if (_customAfterColor != null) {
      ref.read(reactionTestGameProvider.notifier).setCustomColors(color, _customAfterColor!);
    }
  }

  void _onCustomAfterColorSelected(Color color) {
    setState(() => _customAfterColor = color);
    if (_customBeforeColor != null) {
      ref.read(reactionTestGameProvider.notifier).setCustomColors(_customBeforeColor!, color);
    }
  }

  String _getPresetName(AppLocalizations l10n, int index) {
    return switch (index) {
      0 => l10n.rt_redGreenColorblind,
      1 => l10n.rt_blueYellowColorblind,
      2 => l10n.rt_monochromacy,
      3 => l10n.rt_custom,
      _ => '',
    };
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
        Icons.touch_app,
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
          l10n.game_reaction_test,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: textPrimaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.createdByMinimax,
          style: TextStyle(fontSize: 12, color: context.themeAccent),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.rt_gameDescription,
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

    final gameState = ref.watch(reactionTestGameProvider);
    final selectedPreset = gameState.selectedPresetIndex;
    final isCustom = selectedPreset == 3;

    final allPresets = [
      ...ReactionTestState.colorPresets,
      const ColorPreset(name: '', beforeColor: Colors.grey, afterColor: Colors.grey),
    ];

    final colorsSame = isCustom &&
        _customBeforeColor != null &&
        _customAfterColor != null &&
        _customBeforeColor == _customAfterColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(l10n.game_reaction_test),
        backgroundColor: themeColors.primary,
        foregroundColor: themeColors.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: l10n.back,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () => ReactionTestLeaderboard.show(context),
            tooltip: l10n.leaderboard,
          ),
        ],
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
                    Container(
                      padding: isLandscape
                          ? const EdgeInsets.all(16)
                          : const EdgeInsets.all(24),
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
                            l10n.rt_selectPreset,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: textPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: isLandscape ? 4 : 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: isLandscape ? 3.0 : 2.5,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(allPresets.length, (index) {
                              final preset = allPresets[index];
                              final isSelected = selectedPreset == index;
                              return _PresetCard(
                                preset: preset,
                                presetName: _getPresetName(l10n, index),
                                isSelected: isSelected,
                                isLandscape: isLandscape,
                                onTap: () {
                                  if (index == allPresets.length - 1) {
                                    ref
                                        .read(reactionTestGameProvider.notifier)
                                        .setCustomColors(
                                          _customBeforeColor ?? Colors.red,
                                          _customAfterColor ?? Colors.green,
                                        );
                                    setState(() {
                                      _customBeforeColor = null;
                                      _customAfterColor = null;
                                    });
                                  } else {
                                    ref
                                        .read(reactionTestGameProvider.notifier)
                                        .setColorPreset(index);
                                  }
                                },
                              );
                            }),
                          ),
                          if (isCustom) ...[
                            SizedBox(height: isLandscape ? 12 : 24),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _CustomColorPicker(
                                    title: l10n.rt_beforeColor,
                                    selectedColor: _customBeforeColor,
                                    otherColor: _customAfterColor,
                                    onColorSelected: _onCustomBeforeColorSelected,
                                    isLandscape: isLandscape,
                                  ),
                                ),
                                SizedBox(width: isLandscape ? 12 : 16),
                                Expanded(
                                  child: _CustomColorPicker(
                                    title: l10n.rt_afterColor,
                                    selectedColor: _customAfterColor,
                                    otherColor: _customBeforeColor,
                                    onColorSelected: _onCustomAfterColorSelected,
                                    isLandscape: isLandscape,
                                  ),
                                ),
                              ],
                            ),
                            if (_customBeforeColor != null &&
                                _customAfterColor != null &&
                                _customBeforeColor == _customAfterColor)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  l10n.rt_sameColorWarning,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: themeColors.warning,
                                  ),
                                ),
                              ),
                          ],
                          if (!isCustom) ...[
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _ColorSwatch(
                                  color: gameState.beforeColor,
                                  label: l10n.rt_beforeColor,
                                ),
                                const SizedBox(width: 24),
                                Icon(
                                  Icons.arrow_forward,
                                  color: textSecondaryColor,
                                ),
                                const SizedBox(width: 24),
                                _ColorSwatch(
                                  color: gameState.afterColor,
                                  label: l10n.rt_afterColor,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    WoodenButton(
                      text: l10n.newGame,
                      icon: Icons.play_arrow,
                      size: WoodenButtonSize.large,
                      variant: WoodenButtonVariant.primary,
                      expandWidth: true,
                      onPressed: colorsSame ? null : _startGame,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.rt_instructions,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: textSecondaryColor),
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

class _PresetCard extends StatelessWidget {
  final ColorPreset preset;
  final String presetName;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLandscape;

  const _PresetCard({
    required this.preset,
    required this.presetName,
    required this.isSelected,
    required this.onTap,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? themeColors.accent.withAlpha(50) : themeColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? themeColors.accent : themeColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: themeColors.accent.withAlpha(128),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isLandscape ? 10 : 16,
          vertical: isLandscape ? 4 : 8,
        ),
        child: Row(
          children: [
            Container(
              width: isLandscape ? 18 : 24,
              height: isLandscape ? 18 : 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: themeColors.border, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: preset.beforeColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(3),
                          bottomLeft: Radius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: preset.afterColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(3),
                          bottomRight: Radius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                presetName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? themeColors.textPrimary
                      : themeColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorSwatch({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: themeColors.border, width: 2),
            boxShadow: [
              BoxShadow(
                color: themeColors.shadow.withAlpha(128),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: themeColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _CustomColorPicker extends StatelessWidget {
  final String title;
  final Color? selectedColor;
  final Color? otherColor;
  final ValueChanged<Color> onColorSelected;
  final bool isLandscape;

  const _CustomColorPicker({
    required this.title,
    required this.selectedColor,
    required this.otherColor,
    required this.onColorSelected,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);

    final colors = ReactionTestState.customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: themeColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isLandscape ? 4 : 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: List.generate(colors.length, (index) {
            final color = colors[index];
            final isSelected = selectedColor == color;
            final isOther = otherColor == color;
            return GestureDetector(
              onTap: () => onColorSelected(color),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: isLandscape ? 32 : 40,
                height: isLandscape ? 32 : 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? themeColors.accent
                        : isOther
                            ? themeColors.warning
                            : themeColors.border,
                    width: isSelected || isOther ? 3 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeColors.shadow.withAlpha(64),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}