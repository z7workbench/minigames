import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_provider.dart';
import 'wooden_colors.dart';
import 'starlight_colors.dart';

/// Extension to easily access theme-aware colors from BuildContext
extension ThemeColorsExtension on BuildContext {
  /// Get the current color scheme type
  /// Uses Riverpod provider if available, otherwise falls back to color detection
  ColorSchemeType get colorSchemeType {
    // Try to get from Riverpod provider first
    try {
      final container = ProviderScope.containerOf(this);
      final asyncValue = container.read(colorSchemeNotifierProvider);
      return asyncValue.valueOrNull ?? ColorSchemeType.wooden;
    } catch (e) {
      // Fallback: check if primary color matches Starlight colors
      final primaryColor = Theme.of(this).primaryColor;

      // Check if primary color matches Starlight colors using toARGB32
      if (primaryColor.toARGB32() == StarlightColors.lightPrimary.toARGB32() ||
          primaryColor.toARGB32() == StarlightColors.darkPrimary.toARGB32()) {
        return ColorSchemeType.starlight;
      }
      return ColorSchemeType.wooden;
    }
  }

  /// Check if current theme is dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Get theme-aware primary color
  Color get themePrimary => Theme.of(this).colorScheme.primary;

  /// Get theme-aware secondary color
  Color get themeSecondary => Theme.of(this).colorScheme.secondary;

  /// Get theme-aware background color
  Color get themeBackground => Theme.of(this).colorScheme.surface;

  /// Get theme-aware surface color
  Color get themeSurface => Theme.of(this).colorScheme.surface;

  /// Get theme-aware card color
  Color get themeCard => Theme.of(this).colorScheme.surfaceContainerHighest;

  /// Get theme-aware text primary color
  Color get themeTextPrimary => Theme.of(this).colorScheme.onSurface;

  /// Get theme-aware text secondary color
  Color get themeTextSecondary => Theme.of(this).colorScheme.onSurfaceVariant;

  /// Get theme-aware border color
  Color get themeBorder => Theme.of(this).colorScheme.outline;

  /// Get theme-aware divider color
  Color get themeDivider => Theme.of(this).colorScheme.outlineVariant;

  /// Get theme-aware shadow color
  Color get themeShadow => Theme.of(this).colorScheme.shadow;

  /// Get theme-aware accent color (amber for wooden, star for starlight)
  Color get themeAccent {
    final isDark = isDarkMode;
    if (colorSchemeType == ColorSchemeType.starlight) {
      return StarlightColors.accentStar;
    }
    // Wooden: use bronze in light mode for better contrast, amber in dark mode
    return isDark ? WoodenColors.accentAmber : WoodenColors.accentBronze;
  }

  /// Get theme-aware secondary accent color
  Color get themeAccentSecondary {
    final isDark = isDarkMode;
    if (colorSchemeType == ColorSchemeType.starlight) {
      return StarlightColors.accentNebula;
    }
    // Wooden: use copper in light mode, amber secondary in dark mode
    return isDark ? WoodenColors.accentCopper : WoodenColors.accentCopper;
  }

  /// Get success color (theme-aware)
  Color get themeSuccess {
    final isDark = isDarkMode;
    if (colorSchemeType == ColorSchemeType.starlight) {
      return StarlightColors.darkSuccess;
    }
    return isDark ? WoodenColors.darkSuccess : WoodenColors.lightSuccess;
  }

  /// Get error color (theme-aware)
  Color get themeError {
    final isDark = isDarkMode;
    if (colorSchemeType == ColorSchemeType.starlight) {
      return StarlightColors.darkError;
    }
    return isDark ? WoodenColors.darkError : WoodenColors.lightError;
  }

  /// Get warning color (theme-aware)
  Color get themeWarning {
    final isDark = isDarkMode;
    if (colorSchemeType == ColorSchemeType.starlight) {
      return StarlightColors.darkWarning;
    }
    return isDark ? WoodenColors.darkWarning : WoodenColors.lightWarning;
  }

  /// Get theme-aware disabled color
  Color get themeDisabled {
    final isDark = isDarkMode;
    if (colorSchemeType == ColorSchemeType.starlight) {
      return isDark
          ? StarlightColors.darkDisabled
          : StarlightColors.lightDisabled;
    }
    return isDark ? WoodenColors.darkDisabled : WoodenColors.lightDisabled;
  }

  /// Get theme-aware on-primary color (text color on primary background)
  Color get themeOnPrimary => Theme.of(this).colorScheme.onPrimary;

  /// Get theme-aware on-accent color (text color on accent background)
  Color get themeOnAccent {
    final isDark = isDarkMode;
    if (colorSchemeType == ColorSchemeType.starlight) {
      return isDark ? Colors.white : StarlightColors.darkOnPrimary;
    }
    return Colors.black;
  }

  /// Get theme-aware selection color for chips/buttons (with good contrast)
  Color get themeSelectionColor {
    final isDark = isDarkMode;
    if (colorSchemeType == ColorSchemeType.starlight) {
      // Starlight: use bright purple for selection
      return isDark
          ? StarlightColors.darkPrimary.withAlpha(200) // Brighter in dark mode
          : StarlightColors.lightPrimary.withAlpha(
              150,
            ); // Visible in light mode
    } else {
      // Wooden: use amber/copper for selection
      return isDark
          ? WoodenColors.accentAmber.withAlpha(200) // Bright amber in dark mode
          : WoodenColors.accentCopper.withAlpha(
              180,
            ); // Copper in light mode for contrast
    }
  }

  /// Get theme-aware pattern/decorative color (for card back patterns, etc.)
  /// Wooden: golden/copper tones, Starlight: white/light tones
  Color get themePattern {
    if (colorSchemeType == ColorSchemeType.starlight) {
      // Starlight: white pattern for contrast against purple background
      return Colors.white.withAlpha(180);
    }
    // Wooden: golden/copper pattern against brown background
    return WoodenColors.accentCopper.withAlpha(150);
  }
}

/// Helper class to get theme-aware colors without BuildContext
/// Useful for components that need colors but don't have context
class ThemeColors {
  /// Get colors based on brightness and color scheme type
  static ThemeColorSet getColors(bool isDark, ColorSchemeType scheme) {
    switch (scheme) {
      case ColorSchemeType.starlight:
        return ThemeColorSet(
          primary: isDark
              ? StarlightColors.darkPrimary
              : StarlightColors.lightPrimary,
          secondary: isDark
              ? StarlightColors.darkSecondary
              : StarlightColors.lightSecondary,
          background: isDark
              ? StarlightColors.darkBackground
              : StarlightColors.lightBackground,
          surface: isDark
              ? StarlightColors.darkSurface
              : StarlightColors.lightSurface,
          card: isDark ? StarlightColors.darkCard : StarlightColors.lightCard,
          textPrimary: isDark
              ? StarlightColors.darkTextPrimary
              : StarlightColors.lightTextPrimary,
          textSecondary: isDark
              ? StarlightColors.darkTextSecondary
              : StarlightColors.lightTextSecondary,
          border: isDark
              ? StarlightColors.darkBorder
              : StarlightColors.lightBorder,
          divider: isDark
              ? StarlightColors.darkDivider
              : StarlightColors.lightDivider,
          shadow: isDark
              ? StarlightColors.darkShadow
              : StarlightColors.lightShadow,
          accent: StarlightColors.accentStar,
          accentSecondary: StarlightColors.accentNebula,
          error: isDark
              ? StarlightColors.darkError
              : StarlightColors.lightError,
          success: isDark
              ? StarlightColors.darkSuccess
              : StarlightColors.lightSuccess,
          warning: isDark
              ? StarlightColors.darkWarning
              : StarlightColors.lightWarning,
          onPrimary: isDark
              ? StarlightColors.darkOnPrimary
              : StarlightColors.lightOnPrimary,
          pattern: Colors.white.withAlpha(180),
        );
      case ColorSchemeType.wooden:
        return ThemeColorSet(
          primary: isDark
              ? WoodenColors.darkPrimary
              : WoodenColors.lightPrimary,
          secondary: isDark
              ? WoodenColors.darkSecondary
              : WoodenColors.lightSecondary,
          background: isDark
              ? WoodenColors.darkBackground
              : WoodenColors.lightBackground,
          surface: isDark
              ? WoodenColors.darkSurface
              : WoodenColors.lightSurface,
          card: isDark ? WoodenColors.darkCard : WoodenColors.lightCard,
          textPrimary: isDark
              ? WoodenColors.darkTextPrimary
              : WoodenColors.lightTextPrimary,
          textSecondary: isDark
              ? WoodenColors.darkTextSecondary
              : WoodenColors.lightTextSecondary,
          border: isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder,
          divider: isDark
              ? WoodenColors.darkDivider
              : WoodenColors.lightDivider,
          shadow: isDark ? WoodenColors.darkShadow : WoodenColors.lightShadow,
          accent: WoodenColors.accentAmber,
          accentSecondary: WoodenColors.accentCopper,
          error: isDark ? WoodenColors.darkError : WoodenColors.lightError,
          success: isDark
              ? WoodenColors.darkSuccess
              : WoodenColors.lightSuccess,
          warning: isDark
              ? WoodenColors.darkWarning
              : WoodenColors.lightWarning,
          onPrimary: isDark
              ? WoodenColors.darkOnPrimary
              : WoodenColors.lightOnPrimary,
          pattern: WoodenColors.accentCopper.withAlpha(150),
        );
    }
  }
}

/// A set of theme-aware colors
class ThemeColorSet {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color divider;
  final Color shadow;
  final Color accent;
  final Color accentSecondary;
  final Color error;
  final Color success;
  final Color warning;
  final Color onPrimary;
  final Color pattern;

  const ThemeColorSet({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.divider,
    required this.shadow,
    required this.accent,
    required this.accentSecondary,
    required this.error,
    required this.success,
    required this.warning,
    required this.onPrimary,
    required this.pattern,
  });
}
