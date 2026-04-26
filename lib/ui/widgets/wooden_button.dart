import 'package:flutter/material.dart';
import '../theme/theme_colors.dart';

/// A reusable wooden-styled button with customizable appearance.
///
/// This button follows the wooden board game aesthetic with warm wood tones,
/// subtle borders, and shadow effects that evoke traditional wooden game pieces.
///
/// Supports all color schemes (Wooden, Starlight, Forest) automatically.
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
    final themeColors = ThemeColors.getColors(
      context.isDarkMode,
      context.colorSchemeType,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: expandWidth ? double.infinity : null,
      child: Material(
        elevation: onPressed != null ? _elevation : 0,
        borderRadius: BorderRadius.circular(borderRadius),
        shadowColor: themeColors.shadow,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? _resolvedPadding,
            decoration: BoxDecoration(
              gradient: _buildGradient(themeColors),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: _borderColor(themeColors),
                width: 1.5,
              ),
            ),
            child: _buildContent(themeColors),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeColorSet colors) {
    final foregroundColor = _foregroundColor(colors);

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

  /// Build gradient based on variant and theme colors.
  LinearGradient? _buildGradient(ThemeColorSet colors) {
    if (onPressed == null) {
      return null;
    }

    switch (variant) {
      case WoodenButtonVariant.primary:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.secondary],
        );
      case WoodenButtonVariant.secondary:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.surface, colors.card],
        );
      case WoodenButtonVariant.accent:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.accent, colors.accentSecondary],
        );
      case WoodenButtonVariant.outlined:
      case WoodenButtonVariant.ghost:
        return null;
    }
  }

  /// Get border color based on variant and theme colors.
  Color _borderColor(ThemeColorSet colors) {
    if (onPressed == null) {
      return colors.disabled;
    }

    switch (variant) {
      case WoodenButtonVariant.primary:
      case WoodenButtonVariant.secondary:
        return colors.border;
      case WoodenButtonVariant.accent:
        return colors.accentSecondary;
      case WoodenButtonVariant.outlined:
        return colors.accent;
      case WoodenButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  /// Get foreground (text/icon) color based on variant and theme colors.
  Color _foregroundColor(ThemeColorSet colors) {
    if (onPressed == null) {
      return colors.disabled;
    }

    switch (variant) {
      case WoodenButtonVariant.primary:
        return colors.onPrimary;
      case WoodenButtonVariant.secondary:
        return colors.textPrimary;
      case WoodenButtonVariant.accent:
        // Accent buttons need white text for visibility
        return Colors.white;
      case WoodenButtonVariant.outlined:
      case WoodenButtonVariant.ghost:
        return colors.accent;
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

  /// Accent button with accent color gradient.
  accent,

  /// Outlined button with transparent background.
  outlined,

  /// Ghost button with no border and transparent background.
  ghost,
}