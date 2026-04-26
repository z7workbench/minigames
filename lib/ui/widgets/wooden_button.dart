import 'package:flutter/material.dart';
import '../theme/theme_colors.dart';
import '../theme/theme_provider.dart';
import '../theme/wooden_colors.dart' as wooden;
import '../theme/starlight_colors.dart' as starlight;

/// A reusable wooden-styled button with customizable appearance.
///
/// This button follows the wooden board game aesthetic with warm wood tones,
/// subtle borders, and shadow effects that evoke traditional wooden game pieces.
class WoodenButton extends StatelessWidget {
  /// The text to display on the button.
  final String? text;

  /// The icon to display on the button.
  final IconData? icon;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// The size of the button.
  final WoodenButtonSize size;

  /// The variant/style of the button.
  final WoodenButtonVariant variant;

  /// Whether the button should expand to fill available width.
  final bool expandWidth;

  /// Custom padding override.
  final EdgeInsets? padding;

  /// Border radius for the button.
  final double borderRadius;

  const WoodenButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.size = WoodenButtonSize.medium,
    this.variant = WoodenButtonVariant.primary,
    this.expandWidth = false,
    this.padding,
    this.borderRadius = 8.0,
  }) : assert(
         text != null || icon != null,
         'Either text or icon must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: expandWidth ? double.infinity : null,
      child: Material(
        elevation: onPressed != null ? _elevation : 0,
        borderRadius: BorderRadius.circular(borderRadius),
        shadowColor: context.themeShadow,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? _resolvedPadding,
            decoration: BoxDecoration(
              gradient: _buildGradient(context),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: _borderColor(context), width: 1.5),
            ),
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final foregroundColor = _foregroundColor(context);

    if (text != null && icon != null) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: foregroundColor, size: _iconSize),
            SizedBox(width: size == WoodenButtonSize.small ? 4 : 8),
            Text(
              text!,
              style: TextStyle(
                color: foregroundColor,
                fontSize: _fontSize,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    } else if (icon != null) {
      return Icon(icon, color: foregroundColor, size: _iconSize);
    } else {
      return Text(
        text!,
        style: TextStyle(
          color: foregroundColor,
          fontSize: _fontSize,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      );
    }
  }

  LinearGradient? _buildGradient(BuildContext context) {
    if (onPressed == null) {
      return null;
    }

    final isDark = context.isDarkMode;
    final isStarlight = context.colorSchemeType == ColorSchemeType.starlight;

    switch (variant) {
      case WoodenButtonVariant.primary:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  isStarlight
                      ? starlight.StarlightColors.darkPrimary
                      : wooden.WoodenColors.darkPrimary,
                  isStarlight
                      ? starlight.StarlightColors.darkSecondary
                      : wooden.WoodenColors.darkSecondary,
                ]
              : [
                  isStarlight
                      ? starlight.StarlightColors.lightPrimary
                      : wooden.WoodenColors.lightPrimary,
                  isStarlight
                      ? starlight.StarlightColors.lightSecondary
                      : wooden.WoodenColors.lightSecondary,
                ],
        );
      case WoodenButtonVariant.secondary:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  isStarlight
                      ? starlight.StarlightColors.darkSurface
                      : wooden.WoodenColors.darkSurface,
                  isStarlight
                      ? starlight.StarlightColors.darkCard
                      : wooden.WoodenColors.darkCard,
                ]
              : [
                  isStarlight
                      ? starlight.StarlightColors.lightSurface
                      : wooden.WoodenColors.lightSurface,
                  isStarlight
                      ? starlight.StarlightColors.lightCard
                      : wooden.WoodenColors.lightCard,
                ],
        );
      case WoodenButtonVariant.accent:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isStarlight
              ? [
                  starlight.StarlightColors.accentStar,
                  starlight.StarlightColors.accentNebula,
                ]
              : [
                  wooden.WoodenColors.accentAmber,
                  wooden.WoodenColors.accentCopper,
                ],
        );
      case WoodenButtonVariant.outlined:
      case WoodenButtonVariant.ghost:
        return null;
    }
  }

  Color _borderColor(BuildContext context) {
    if (onPressed == null) {
      return context.themeDisabled;
    }

    final isDark = context.isDarkMode;
    final isStarlight = context.colorSchemeType == ColorSchemeType.starlight;

    switch (variant) {
      case WoodenButtonVariant.primary:
        return isDark
            ? (isStarlight
                  ? starlight.StarlightColors.darkBorder
                  : wooden.WoodenColors.darkBorder)
            : (isStarlight
                  ? starlight.StarlightColors.lightBorder
                  : wooden.WoodenColors.lightBorder);
      case WoodenButtonVariant.secondary:
        return isDark
            ? (isStarlight
                  ? starlight.StarlightColors.darkBorder
                  : wooden.WoodenColors.darkBorder)
            : (isStarlight
                  ? starlight.StarlightColors.lightBorder
                  : wooden.WoodenColors.lightBorder);
      case WoodenButtonVariant.accent:
        return isStarlight
            ? starlight.StarlightColors.accentNebula
            : wooden.WoodenColors.accentBronze;
      case WoodenButtonVariant.outlined:
        return context.themeAccent;
      case WoodenButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color _foregroundColor(BuildContext context) {
    if (onPressed == null) {
      return context.themeDisabled;
    }

    final isDark = context.isDarkMode;
    final isStarlight = context.colorSchemeType == ColorSchemeType.starlight;

    switch (variant) {
      case WoodenButtonVariant.primary:
        return isDark
            ? (isStarlight
                  ? starlight.StarlightColors.darkOnPrimary
                  : wooden.WoodenColors.darkOnPrimary)
            : (isStarlight
                  ? starlight.StarlightColors.lightOnPrimary
                  : wooden.WoodenColors.lightOnPrimary);
      case WoodenButtonVariant.secondary:
        return isDark
            ? (isStarlight
                  ? starlight.StarlightColors.darkTextPrimary
                  : wooden.WoodenColors.darkTextPrimary)
            : (isStarlight
                  ? starlight.StarlightColors.lightTextPrimary
                  : wooden.WoodenColors.lightTextPrimary);
      case WoodenButtonVariant.accent:
        return isStarlight
            ? Colors.white
            : wooden.WoodenColors.lightTextPrimary;
      case WoodenButtonVariant.outlined:
      case WoodenButtonVariant.ghost:
        return context.themeAccent;
    }
  }

  double get _elevation {
    switch (size) {
      case WoodenButtonSize.small:
        return 2.0;
      case WoodenButtonSize.medium:
        return 4.0;
      case WoodenButtonSize.large:
        return 6.0;
    }
  }

  EdgeInsets get _resolvedPadding {
    switch (size) {
      case WoodenButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case WoodenButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case WoodenButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 28, vertical: 16);
    }
  }

  double get _fontSize {
    switch (size) {
      case WoodenButtonSize.small:
        return 12;
      case WoodenButtonSize.medium:
        return 14;
      case WoodenButtonSize.large:
        return 16;
    }
  }

  double get _iconSize {
    switch (size) {
      case WoodenButtonSize.small:
        return 16;
      case WoodenButtonSize.medium:
        return 20;
      case WoodenButtonSize.large:
        return 24;
    }
  }
}

/// Size variants for [WoodenButton].
enum WoodenButtonSize { small, medium, large }

/// Style variants for [WoodenButton].
enum WoodenButtonVariant {
  /// Primary button with gradient background.
  primary,

  /// Secondary button with subtle background.
  secondary,

  /// Accent button with amber/copper gradient.
  accent,

  /// Outlined button with transparent background.
  outlined,

  /// Ghost button with no border and transparent background.
  ghost,
}
