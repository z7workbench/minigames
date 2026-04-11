import 'package:flutter/material.dart';
import 'wooden_colors.dart';
import 'starlight_colors.dart';
import 'forest_colors.dart';
import 'theme_provider.dart';

/// Application theme configuration with wooden board game aesthetic.
class AppTheme {
  // Border radius for wooden card/ button appearance
  static const double _borderRadiusSmall = 8.0;
  static const double _borderRadiusMedium = 12.0;
  static const double _borderRadiusLarge = 16.0;

  // Elevation values for shadows
  static const double _elevationLow = 2.0;
  static const double _elevationMedium = 4.0;
  static const double _elevationHigh = 8.0;

  // Typography scale
  static const double _letterSpacing = 0.5;

  /// Returns the light theme configuration.
  static ThemeData lightTheme([
    ColorSchemeType colorScheme = ColorSchemeType.wooden,
  ]) {
    final colors = _getColorScheme(colorScheme, Brightness.light);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.surface,
      // Typography with wooden aesthetic - using system fonts
      textTheme: _buildTextTheme(colors),
      // AppBar theme with wooden styling
      appBarTheme: _buildLightAppBarTheme(colors, colorScheme),
      // Card theme with wooden texture effect
      cardTheme: _buildLightCardThemeData(colors, colorScheme),
      // Button themes
      elevatedButtonTheme: _buildLightElevatedButtonTheme(colors, colorScheme),
      textButtonTheme: _buildLightTextButtonTheme(colors, colorScheme),
      outlinedButtonTheme: _buildLightOutlinedButtonTheme(colors, colorScheme),
      // Input decoration theme
      inputDecorationTheme: _buildLightInputDecorationTheme(
        colors,
        colorScheme,
      ),
      // Floating action button theme
      floatingActionButtonTheme: _buildLightFabTheme(colors, colorScheme),
      // Icon theme
      iconTheme: _buildLightIconTheme(colors),
      // Divider theme
      dividerTheme: _buildLightDividerTheme(colorScheme),
      // Dialog theme
      dialogTheme: _buildLightDialogThemeData(colors, colorScheme),
      // Snackbar theme
      snackBarTheme: _buildLightSnackbarTheme(colors, colorScheme),
      // Bottom sheet theme
      bottomSheetTheme: _buildLightBottomSheetTheme(colors, colorScheme),
      // Chip theme
      chipTheme: _buildLightChipTheme(colors, colorScheme),
      // Switch theme
      switchTheme: _buildLightSwitchTheme(colors, colorScheme),
      // Slider theme
      sliderTheme: _buildLightSliderTheme(colors, colorScheme),
      // Tooltip theme
      tooltipTheme: _buildLightTooltipTheme(colors, colorScheme),
    );
  }

  /// Returns the dark theme configuration.
  static ThemeData darkTheme([
    ColorSchemeType colorScheme = ColorSchemeType.wooden,
  ]) {
    final colors = _getColorScheme(colorScheme, Brightness.dark);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.surface,
      // Typography with wooden aesthetic
      textTheme: _buildTextTheme(colors),
      // AppBar theme with wooden styling
      appBarTheme: _buildDarkAppBarTheme(colors, colorScheme),
      // Card theme with wooden texture effect
      cardTheme: _buildDarkCardThemeData(colors, colorScheme),
      // Button themes
      elevatedButtonTheme: _buildDarkElevatedButtonTheme(colors, colorScheme),
      textButtonTheme: _buildDarkTextButtonTheme(colors, colorScheme),
      outlinedButtonTheme: _buildDarkOutlinedButtonTheme(colors, colorScheme),
      // Input decoration theme
      inputDecorationTheme: _buildDarkInputDecorationTheme(colors, colorScheme),
      // Floating action button theme
      floatingActionButtonTheme: _buildDarkFabTheme(colors, colorScheme),
      // Icon theme
      iconTheme: _buildDarkIconTheme(colors),
      // Divider theme
      dividerTheme: _buildDarkDividerTheme(colorScheme),
      // Dialog theme
      dialogTheme: _buildDarkDialogThemeData(colors, colorScheme),
      // Snackbar theme
      snackBarTheme: _buildDarkSnackbarTheme(colors, colorScheme),
      // Bottom sheet theme
      bottomSheetTheme: _buildDarkBottomSheetTheme(colors, colorScheme),
      // Chip theme
      chipTheme: _buildDarkChipTheme(colors, colorScheme),
      // Switch theme
      switchTheme: _buildDarkSwitchTheme(colors, colorScheme),
      // Slider theme
      sliderTheme: _buildDarkSliderTheme(colors, colorScheme),
      // Tooltip theme
      tooltipTheme: _buildDarkTooltipTheme(colors, colorScheme),
    );
  }

  // ===========================================================================
  // COLOR SCHEMES
  // ===========================================================================

  static ColorScheme _getColorScheme(
    ColorSchemeType type,
    Brightness brightness,
  ) {
    switch (type) {
      case ColorSchemeType.starlight:
        return brightness == Brightness.light
            ? _starlightLightColorScheme
            : _starlightDarkColorScheme;
      case ColorSchemeType.forest:
        return brightness == Brightness.light
            ? _forestLightColorScheme
            : _forestDarkColorScheme;
      case ColorSchemeType.wooden:
        return brightness == Brightness.light
            ? _woodenLightColorScheme
            : _woodenDarkColorScheme;
    }
  }

  static ColorScheme get _woodenLightColorScheme => const ColorScheme(
    brightness: Brightness.light,
    primary: WoodenColors.lightPrimary,
    onPrimary: WoodenColors.lightOnPrimary,
    primaryContainer: WoodenColors.lightSecondary,
    onPrimaryContainer: WoodenColors.lightOnPrimary,
    secondary: WoodenColors.lightSecondary,
    onSecondary: WoodenColors.lightOnSecondary,
    secondaryContainer: WoodenColors.lightCard,
    onSecondaryContainer: WoodenColors.lightTextPrimary,
    tertiary: WoodenColors.accentAmber,
    onTertiary: WoodenColors.lightTextPrimary,
    tertiaryContainer: WoodenColors.accentCopper,
    onTertiaryContainer: WoodenColors.lightTextPrimary,
    surface: WoodenColors.lightSurface,
    onSurface: WoodenColors.lightOnSurface,
    surfaceContainerHighest: WoodenColors.lightCard,
    onSurfaceVariant: WoodenColors.lightTextSecondary,
    background: WoodenColors.lightBackground,
    onBackground: WoodenColors.lightOnBackground,
    error: WoodenColors.lightError,
    onError: WoodenColors.lightOnError,
    errorContainer: Color(0xFFFFCDD2),
    onErrorContainer: Color(0xFFB71C1C),
    outline: WoodenColors.lightBorder,
    outlineVariant: WoodenColors.lightDivider,
    shadow: WoodenColors.lightShadow,
    scrim: Color(0xFF000000),
    inverseSurface: WoodenColors.darkSurface,
    onInverseSurface: WoodenColors.darkTextPrimary,
    inversePrimary: WoodenColors.darkPrimary,
  );

  static ColorScheme get _woodenDarkColorScheme => const ColorScheme(
    brightness: Brightness.dark,
    primary: WoodenColors.darkPrimary,
    onPrimary: WoodenColors.darkOnPrimary,
    primaryContainer: WoodenColors.darkSecondary,
    onPrimaryContainer: WoodenColors.darkOnPrimary,
    secondary: WoodenColors.darkSecondary,
    onSecondary: WoodenColors.darkOnSecondary,
    secondaryContainer: WoodenColors.darkCard,
    onSecondaryContainer: WoodenColors.darkTextPrimary,
    tertiary: WoodenColors.accentAmber,
    onTertiary: WoodenColors.darkTextPrimary,
    tertiaryContainer: WoodenColors.accentCopper,
    onTertiaryContainer: WoodenColors.darkTextPrimary,
    surface: WoodenColors.darkSurface,
    onSurface: WoodenColors.darkOnSurface,
    surfaceContainerHighest: WoodenColors.darkCard,
    onSurfaceVariant: WoodenColors.darkTextSecondary,
    background: WoodenColors.darkBackground,
    onBackground: WoodenColors.darkOnBackground,
    error: WoodenColors.darkError,
    onError: WoodenColors.darkOnError,
    errorContainer: Color(0xFFB71C1C),
    onErrorContainer: Color(0xFFFFCDD2),
    outline: WoodenColors.darkBorder,
    outlineVariant: WoodenColors.darkDivider,
    shadow: WoodenColors.darkShadow,
    scrim: Color(0xFF000000),
    inverseSurface: WoodenColors.lightSurface,
    onInverseSurface: WoodenColors.lightTextPrimary,
    inversePrimary: WoodenColors.lightPrimary,
  );

  static ColorScheme get _starlightLightColorScheme => const ColorScheme(
    brightness: Brightness.light,
    primary: StarlightColors.lightPrimary,
    onPrimary: StarlightColors.lightOnPrimary,
    primaryContainer: StarlightColors.lightSecondary,
    onPrimaryContainer: StarlightColors.lightOnPrimary,
    secondary: StarlightColors.lightSecondary,
    onSecondary: StarlightColors.lightOnSecondary,
    secondaryContainer: StarlightColors.lightCard,
    onSecondaryContainer: StarlightColors.lightTextPrimary,
    tertiary: StarlightColors.accentStar,
    onTertiary: Colors.white,
    tertiaryContainer: StarlightColors.accentCosmos,
    onTertiaryContainer: Colors.white,
    surface: StarlightColors.lightSurface,
    onSurface: StarlightColors.lightOnSurface,
    surfaceContainerHighest: StarlightColors.lightCard,
    onSurfaceVariant: StarlightColors.lightTextSecondary,
    background: StarlightColors.lightBackground,
    onBackground: StarlightColors.lightOnBackground,
    error: StarlightColors.lightError,
    onError: StarlightColors.lightOnError,
    errorContainer: Color(0xFFFFCDD2),
    onErrorContainer: Color(0xFFC62828),
    outline: StarlightColors.lightBorder,
    outlineVariant: StarlightColors.lightDivider,
    shadow: StarlightColors.lightShadow,
    scrim: Color(0xFF000000),
    inverseSurface: StarlightColors.darkSurface,
    onInverseSurface: StarlightColors.darkTextPrimary,
    inversePrimary: StarlightColors.darkPrimary,
  );

  static ColorScheme get _starlightDarkColorScheme => const ColorScheme(
    brightness: Brightness.dark,
    primary: StarlightColors.darkPrimary,
    onPrimary: StarlightColors.darkOnPrimary,
    primaryContainer: StarlightColors.darkSecondary,
    onPrimaryContainer: StarlightColors.darkOnPrimary,
    secondary: StarlightColors.darkSecondary,
    onSecondary: StarlightColors.darkOnSecondary,
    secondaryContainer: StarlightColors.darkCard,
    onSecondaryContainer: StarlightColors.darkTextPrimary,
    tertiary: StarlightColors.accentStar,
    onTertiary: Colors.white,
    tertiaryContainer: StarlightColors.accentNebula,
    onTertiaryContainer: Colors.white,
    surface: StarlightColors.darkSurface,
    onSurface: StarlightColors.darkOnSurface,
    surfaceContainerHighest: StarlightColors.darkCard,
    onSurfaceVariant: StarlightColors.darkTextSecondary,
    background: StarlightColors.darkBackground,
    onBackground: StarlightColors.darkOnBackground,
    error: StarlightColors.darkError,
    onError: StarlightColors.darkOnError,
    errorContainer: Color(0xFFB71C1C),
    onErrorContainer: Color(0xFFFFCDD2),
    outline: StarlightColors.darkBorder,
    outlineVariant: StarlightColors.darkDivider,
    shadow: StarlightColors.darkShadow,
    scrim: Color(0xFF000000),
    inverseSurface: StarlightColors.lightSurface,
    onInverseSurface: StarlightColors.lightTextPrimary,
    inversePrimary: StarlightColors.lightPrimary,
  );

  // ===========================================================================
  // FOREST COLOR SCHEMES
  // ===========================================================================

  static ColorScheme get _forestLightColorScheme => const ColorScheme(
    brightness: Brightness.light,
    primary: ForestColors.lightPrimary,
    onPrimary: ForestColors.lightOnPrimary,
    primaryContainer: ForestColors.lightSecondary,
    onPrimaryContainer: ForestColors.lightOnPrimary,
    secondary: ForestColors.lightSecondary,
    onSecondary: ForestColors.lightOnSecondary,
    secondaryContainer: ForestColors.lightCard,
    onSecondaryContainer: ForestColors.lightTextPrimary,
    tertiary: ForestColors.accentEmerald,
    onTertiary: Colors.white,
    tertiaryContainer: ForestColors.accentMoss,
    onTertiaryContainer: Colors.white,
    surface: ForestColors.lightSurface,
    onSurface: ForestColors.lightOnSurface,
    surfaceContainerHighest: ForestColors.lightCard,
    onSurfaceVariant: ForestColors.lightTextSecondary,
    background: ForestColors.lightBackground,
    onBackground: ForestColors.lightOnBackground,
    error: ForestColors.lightError,
    onError: ForestColors.lightOnError,
    errorContainer: Color(0xFFFFCDD2),
    onErrorContainer: Color(0xFFB71C1C),
    outline: ForestColors.lightBorder,
    outlineVariant: ForestColors.lightDivider,
    shadow: ForestColors.lightShadow,
    scrim: Color(0xFF000000),
    inverseSurface: ForestColors.darkSurface,
    onInverseSurface: ForestColors.darkTextPrimary,
    inversePrimary: ForestColors.darkPrimary,
  );

  static ColorScheme get _forestDarkColorScheme => const ColorScheme(
    brightness: Brightness.dark,
    primary: ForestColors.darkPrimary,
    onPrimary: ForestColors.darkOnPrimary,
    primaryContainer: ForestColors.darkSecondary,
    onPrimaryContainer: ForestColors.darkOnPrimary,
    secondary: ForestColors.darkSecondary,
    onSecondary: ForestColors.darkOnSecondary,
    secondaryContainer: ForestColors.darkCard,
    onSecondaryContainer: ForestColors.darkTextPrimary,
    tertiary: ForestColors.accentEmerald,
    onTertiary: Colors.white,
    tertiaryContainer: ForestColors.accentMoss,
    onTertiaryContainer: Colors.white,
    surface: ForestColors.darkSurface,
    onSurface: ForestColors.darkOnSurface,
    surfaceContainerHighest: ForestColors.darkCard,
    onSurfaceVariant: ForestColors.darkTextSecondary,
    background: ForestColors.darkBackground,
    onBackground: ForestColors.darkOnBackground,
    error: ForestColors.darkError,
    onError: ForestColors.darkOnError,
    errorContainer: Color(0xFFB71C1C),
    onErrorContainer: Color(0xFFFFCDD2),
    outline: ForestColors.darkBorder,
    outlineVariant: ForestColors.darkDivider,
    shadow: ForestColors.darkShadow,
    scrim: Color(0xFF000000),
    inverseSurface: ForestColors.lightSurface,
    onInverseSurface: ForestColors.lightTextPrimary,
    inversePrimary: ForestColors.lightPrimary,
  );

  // ===========================================================================
  // TEXT THEME
  // ===========================================================================

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: _letterSpacing * -0.25,
        fontFamily: 'Roboto',
      ),
      displayMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: _letterSpacing * 0,
        fontFamily: 'Roboto',
      ),
      displaySmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: _letterSpacing * 0,
        fontFamily: 'Roboto',
      ),
      // Headline styles
      headlineLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 32,
        fontWeight: FontWeight.w500,
        letterSpacing: _letterSpacing * 0,
        fontFamily: 'Roboto',
      ),
      headlineMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 28,
        fontWeight: FontWeight.w500,
        letterSpacing: _letterSpacing * 0.25,
        fontFamily: 'Roboto',
      ),
      headlineSmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        letterSpacing: _letterSpacing * 0,
        fontFamily: 'Roboto',
      ),
      // Title styles
      titleLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: _letterSpacing * 0,
        fontFamily: 'Roboto',
      ),
      titleMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: _letterSpacing * 0.15,
        fontFamily: 'Roboto',
      ),
      titleSmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: _letterSpacing * 0.1,
        fontFamily: 'Roboto',
      ),
      // Body styles
      bodyLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: _letterSpacing * 0.5,
        fontFamily: 'Roboto',
      ),
      bodyMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: _letterSpacing * 0.25,
        fontFamily: 'Roboto',
      ),
      bodySmall: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: _letterSpacing * 0.4,
        fontFamily: 'Roboto',
      ),
      // Label styles
      labelLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: _letterSpacing * 0.1,
        fontFamily: 'Roboto',
      ),
      labelMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: _letterSpacing * 0.5,
        fontFamily: 'Roboto',
      ),
      labelSmall: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: _letterSpacing * 0.5,
        fontFamily: 'Roboto',
      ),
    );
  }

  // ===========================================================================
  // APP BAR THEME
  // ===========================================================================

  static AppBarTheme _buildLightAppBarTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (primary, onPrimary, shadow) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.lightPrimary,
        StarlightColors.lightOnPrimary,
        StarlightColors.lightShadow,
      ),
      ColorSchemeType.forest => (
        ForestColors.lightPrimary,
        ForestColors.lightOnPrimary,
        ForestColors.lightShadow,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.lightPrimary,
        WoodenColors.lightOnPrimary,
        WoodenColors.lightShadow,
      ),
    };

    return AppBarTheme(
      backgroundColor: primary,
      foregroundColor: onPrimary,
      elevation: _elevationMedium,
      centerTitle: true,
      shadowColor: shadow,
      scrolledUnderElevation: _elevationHigh,
      titleTextStyle: TextStyle(
        color: onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: _letterSpacing,
        fontFamily: 'Roboto',
      ),
      iconTheme: IconThemeData(color: onPrimary, size: 24),
    );
  }

  static AppBarTheme _buildDarkAppBarTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (primary, onPrimary, shadow) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.darkPrimary,
        StarlightColors.darkOnPrimary,
        StarlightColors.darkShadow,
      ),
      ColorSchemeType.forest => (
        ForestColors.darkPrimary,
        ForestColors.darkOnPrimary,
        ForestColors.darkShadow,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.darkPrimary,
        WoodenColors.darkOnPrimary,
        WoodenColors.darkShadow,
      ),
    };

    return AppBarTheme(
      backgroundColor: primary,
      foregroundColor: onPrimary,
      elevation: _elevationMedium,
      centerTitle: true,
      shadowColor: shadow,
      scrolledUnderElevation: _elevationHigh,
      titleTextStyle: TextStyle(
        color: onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: _letterSpacing,
        fontFamily: 'Roboto',
      ),
      iconTheme: IconThemeData(color: onPrimary, size: 24),
    );
  }

  // ===========================================================================
  // CARD THEME
  // ===========================================================================

  static CardThemeData _buildLightCardThemeData(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (card, shadow, border) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.lightCard,
        StarlightColors.lightShadow,
        StarlightColors.lightBorder,
      ),
      ColorSchemeType.forest => (
        ForestColors.lightCard,
        ForestColors.lightShadow,
        ForestColors.lightBorder,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.lightCard,
        WoodenColors.lightShadow,
        WoodenColors.lightBorder,
      ),
    };

    return CardThemeData(
      color: card,
      elevation: _elevationLow,
      shadowColor: shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusMedium),
        side: BorderSide(color: border, width: 1.5),
      ),
      margin: const EdgeInsets.all(8.0),
    );
  }

  static CardThemeData _buildDarkCardThemeData(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (card, shadow, border) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.darkCard,
        StarlightColors.darkShadow,
        StarlightColors.darkBorder,
      ),
      ColorSchemeType.forest => (
        ForestColors.darkCard,
        ForestColors.darkShadow,
        ForestColors.darkBorder,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.darkCard,
        WoodenColors.darkShadow,
        WoodenColors.darkBorder,
      ),
    };

    return CardThemeData(
      color: card,
      elevation: _elevationLow,
      shadowColor: shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusMedium),
        side: BorderSide(color: border, width: 1.5),
      ),
      margin: const EdgeInsets.all(8.0),
    );
  }

  // ===========================================================================
  // ELEVATED BUTTON THEME
  // ===========================================================================

  static ElevatedButtonThemeData _buildLightElevatedButtonTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (
      primary,
      onPrimary,
      disabled,
      disabledFg,
      shadow,
      border,
    ) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.lightPrimary,
        StarlightColors.lightOnPrimary,
        StarlightColors.lightDisabled,
        StarlightColors.lightTextSecondary,
        StarlightColors.lightShadow,
        StarlightColors.lightBorder,
      ),
      ColorSchemeType.forest => (
        ForestColors.lightPrimary,
        ForestColors.lightOnPrimary,
        ForestColors.lightDisabled,
        ForestColors.lightTextSecondary,
        ForestColors.lightShadow,
        ForestColors.lightBorder,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.lightPrimary,
        WoodenColors.lightOnPrimary,
        WoodenColors.lightDisabled,
        WoodenColors.lightTextSecondary,
        WoodenColors.lightShadow,
        WoodenColors.lightBorder,
      ),
    };

    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        disabledBackgroundColor: disabled,
        disabledForegroundColor: disabledFg,
        elevation: _elevationMedium,
        shadowColor: shadow,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadiusSmall),
          side: BorderSide(color: border, width: 1),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: _letterSpacing,
        ),
      ),
    );
  }

  static ElevatedButtonThemeData _buildDarkElevatedButtonTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (
      primary,
      onPrimary,
      disabled,
      disabledFg,
      shadow,
      border,
    ) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.darkPrimary,
        StarlightColors.darkOnPrimary,
        StarlightColors.darkDisabled,
        StarlightColors.darkTextSecondary,
        StarlightColors.darkShadow,
        StarlightColors.darkBorder,
      ),
      ColorSchemeType.forest => (
        ForestColors.darkPrimary,
        ForestColors.darkOnPrimary,
        ForestColors.darkDisabled,
        ForestColors.darkTextSecondary,
        ForestColors.darkShadow,
        ForestColors.darkBorder,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.darkPrimary,
        WoodenColors.darkOnPrimary,
        WoodenColors.darkDisabled,
        WoodenColors.darkTextSecondary,
        WoodenColors.darkShadow,
        WoodenColors.darkBorder,
      ),
    };

    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        disabledBackgroundColor: disabled,
        disabledForegroundColor: disabledFg,
        elevation: _elevationMedium,
        shadowColor: shadow,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadiusSmall),
          side: BorderSide(color: border, width: 1),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: _letterSpacing,
        ),
      ),
    );
  }

  // ===========================================================================
  // TEXT BUTTON THEME
  // ===========================================================================

  static TextButtonThemeData _buildLightTextButtonTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (primary, disabled) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.lightPrimary,
        StarlightColors.lightDisabled,
      ),
      ColorSchemeType.forest => (
        ForestColors.lightPrimary,
        ForestColors.lightDisabled,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.lightPrimary,
        WoodenColors.lightDisabled,
      ),
    };

    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        disabledForegroundColor: disabled,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadiusSmall),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: _letterSpacing,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildDarkTextButtonTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (accent, disabled) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.accentStar,
        StarlightColors.darkDisabled,
      ),
      ColorSchemeType.forest => (
        ForestColors.accentEmerald,
        ForestColors.darkDisabled,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.accentAmber,
        WoodenColors.darkDisabled,
      ),
    };

    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accent,
        disabledForegroundColor: disabled,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadiusSmall),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: _letterSpacing,
        ),
      ),
    );
  }

  // ===========================================================================
  // OUTLINED BUTTON THEME
  // ===========================================================================

  static OutlinedButtonThemeData _buildLightOutlinedButtonTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (primary, disabled, border) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.lightPrimary,
        StarlightColors.lightDisabled,
        StarlightColors.lightBorder,
      ),
      ColorSchemeType.forest => (
        ForestColors.lightPrimary,
        ForestColors.lightDisabled,
        ForestColors.lightBorder,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.lightPrimary,
        WoodenColors.lightDisabled,
        WoodenColors.lightBorder,
      ),
    };

    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        disabledForegroundColor: disabled,
        side: BorderSide(color: border, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadiusSmall),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: _letterSpacing,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildDarkOutlinedButtonTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (accent, disabled, border) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.accentStar,
        StarlightColors.darkDisabled,
        StarlightColors.darkBorder,
      ),
      ColorSchemeType.forest => (
        ForestColors.accentEmerald,
        ForestColors.darkDisabled,
        ForestColors.darkBorder,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.accentAmber,
        WoodenColors.darkDisabled,
        WoodenColors.darkBorder,
      ),
    };

    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accent,
        disabledForegroundColor: disabled,
        side: BorderSide(color: border, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadiusSmall),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: _letterSpacing,
        ),
      ),
    );
  }

  // ===========================================================================
  // INPUT DECORATION THEME
  // ===========================================================================

  static InputDecorationTheme _buildLightInputDecorationTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (surface, border, primary, error, disabled) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.lightSurface,
        StarlightColors.lightBorder,
        StarlightColors.lightPrimary,
        StarlightColors.lightError,
        StarlightColors.lightDisabled,
      ),
      ColorSchemeType.forest => (
        ForestColors.lightSurface,
        ForestColors.lightBorder,
        ForestColors.lightPrimary,
        ForestColors.lightError,
        ForestColors.lightDisabled,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.lightSurface,
        WoodenColors.lightBorder,
        WoodenColors.lightPrimary,
        WoodenColors.lightError,
        WoodenColors.lightDisabled,
      ),
    };

    return InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: BorderSide(color: border, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: BorderSide(color: border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: BorderSide(color: error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: BorderSide(color: error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: BorderSide(color: disabled, width: 1),
      ),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant.withAlpha(153),
        fontSize: 14,
      ),
      errorStyle: TextStyle(color: error, fontSize: 12),
    );
  }

  static InputDecorationTheme _buildDarkInputDecorationTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (surface, border, accent, error, disabled) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.darkSurface,
        StarlightColors.darkBorder,
        StarlightColors.accentStar,
        StarlightColors.darkError,
        StarlightColors.darkDisabled,
      ),
      ColorSchemeType.forest => (
        ForestColors.darkSurface,
        ForestColors.darkBorder,
        ForestColors.accentEmerald,
        ForestColors.darkError,
        ForestColors.darkDisabled,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.darkSurface,
        WoodenColors.darkBorder,
        WoodenColors.accentAmber,
        WoodenColors.darkError,
        WoodenColors.darkDisabled,
      ),
    };

    return InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: BorderSide(color: border, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: BorderSide(color: border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: BorderSide(color: accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: BorderSide(color: error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: BorderSide(color: error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: BorderSide(color: disabled, width: 1),
      ),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant.withAlpha(153),
        fontSize: 14,
      ),
      errorStyle: TextStyle(color: error, fontSize: 12),
    );
  }

  // ===========================================================================
  // FLOATING ACTION BUTTON THEME
  // ===========================================================================

  static FloatingActionButtonThemeData _buildLightFabTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (accent, textPrimary, border) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.accentStar,
        StarlightColors.lightTextPrimary,
        StarlightColors.lightBorder,
      ),
      ColorSchemeType.forest => (
        ForestColors.accentEmerald,
        ForestColors.lightTextPrimary,
        ForestColors.lightBorder,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.accentAmber,
        WoodenColors.lightTextPrimary,
        WoodenColors.lightBorder,
      ),
    };

    return FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: textPrimary,
      elevation: _elevationHigh,
      focusElevation: _elevationHigh,
      hoverElevation: _elevationHigh + 2,
      disabledElevation: 0,
      highlightElevation: _elevationHigh + 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusLarge),
        side: BorderSide(color: border, width: 1.5),
      ),
    );
  }

  static FloatingActionButtonThemeData _buildDarkFabTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (accent, textPrimary, border) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.accentStar,
        StarlightColors.darkTextPrimary,
        StarlightColors.darkBorder,
      ),
      ColorSchemeType.forest => (
        ForestColors.accentEmerald,
        ForestColors.darkTextPrimary,
        ForestColors.darkBorder,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.accentAmber,
        WoodenColors.darkTextPrimary,
        WoodenColors.darkBorder,
      ),
    };

    return FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: textPrimary,
      elevation: _elevationHigh,
      focusElevation: _elevationHigh,
      hoverElevation: _elevationHigh + 2,
      disabledElevation: 0,
      highlightElevation: _elevationHigh + 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusLarge),
        side: BorderSide(color: border, width: 1.5),
      ),
    );
  }

  // ===========================================================================
  // ICON THEME
  // ===========================================================================

  static IconThemeData _buildLightIconTheme(ColorScheme colorScheme) {
    return IconThemeData(color: colorScheme.onSurface, size: 24);
  }

  static IconThemeData _buildDarkIconTheme(ColorScheme colorScheme) {
    return IconThemeData(color: colorScheme.onSurface, size: 24);
  }

  // ===========================================================================
  // DIVIDER THEME
  // ===========================================================================

  static DividerThemeData _buildLightDividerTheme(ColorSchemeType type) {
    final divider = switch (type) {
      ColorSchemeType.starlight => StarlightColors.lightDivider,
      ColorSchemeType.forest => ForestColors.lightDivider,
      ColorSchemeType.wooden => WoodenColors.lightDivider,
    };

    return DividerThemeData(
      color: divider,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  static DividerThemeData _buildDarkDividerTheme(ColorSchemeType type) {
    final divider = switch (type) {
      ColorSchemeType.starlight => StarlightColors.darkDivider,
      ColorSchemeType.forest => ForestColors.darkDivider,
      ColorSchemeType.wooden => WoodenColors.darkDivider,
    };

    return DividerThemeData(
      color: divider,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  // ===========================================================================
  // DIALOG THEME
  // ===========================================================================

  static DialogThemeData _buildLightDialogThemeData(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (card, shadow, border, textPrimary) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.lightCard,
        StarlightColors.lightShadow,
        StarlightColors.lightBorder,
        StarlightColors.lightTextPrimary,
      ),
      ColorSchemeType.forest => (
        ForestColors.lightCard,
        ForestColors.lightShadow,
        ForestColors.lightBorder,
        ForestColors.lightTextPrimary,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.lightCard,
        WoodenColors.lightShadow,
        WoodenColors.lightBorder,
        WoodenColors.lightTextPrimary,
      ),
    };

    return DialogThemeData(
      backgroundColor: card,
      elevation: _elevationHigh,
      shadowColor: shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusLarge),
        side: BorderSide(color: border, width: 2),
      ),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      contentTextStyle: TextStyle(color: textPrimary, fontSize: 16),
    );
  }

  static DialogThemeData _buildDarkDialogThemeData(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (card, shadow, border, textPrimary) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.darkCard,
        StarlightColors.darkShadow,
        StarlightColors.darkBorder,
        StarlightColors.darkTextPrimary,
      ),
      ColorSchemeType.forest => (
        ForestColors.darkCard,
        ForestColors.darkShadow,
        ForestColors.darkBorder,
        ForestColors.darkTextPrimary,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.darkCard,
        WoodenColors.darkShadow,
        WoodenColors.darkBorder,
        WoodenColors.darkTextPrimary,
      ),
    };

    return DialogThemeData(
      backgroundColor: card,
      elevation: _elevationHigh,
      shadowColor: shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusLarge),
        side: BorderSide(color: border, width: 2),
      ),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      contentTextStyle: TextStyle(color: textPrimary, fontSize: 16),
    );
  }

  // ===========================================================================
  // SNACKBAR THEME
  // ===========================================================================

  static SnackBarThemeData _buildLightSnackbarTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (surface, primary, disabled, border) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.lightSurface,
        StarlightColors.lightPrimary,
        StarlightColors.lightDisabled,
        StarlightColors.lightBorder,
      ),
      ColorSchemeType.forest => (
        ForestColors.lightSurface,
        ForestColors.lightPrimary,
        ForestColors.lightDisabled,
        ForestColors.lightBorder,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.lightSurface,
        WoodenColors.lightPrimary,
        WoodenColors.lightDisabled,
        WoodenColors.lightBorder,
      ),
    };

    return SnackBarThemeData(
      backgroundColor: surface,
      contentTextStyle: TextStyle(color: colorScheme.onSurface, fontSize: 14),
      actionTextColor: primary,
      disabledActionTextColor: disabled,
      elevation: _elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        side: BorderSide(color: border, width: 1),
      ),
      behavior: SnackBarBehavior.floating,
    );
  }

  static SnackBarThemeData _buildDarkSnackbarTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (surface, accent, disabled, border) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.darkSurface,
        StarlightColors.accentStar,
        StarlightColors.darkDisabled,
        StarlightColors.darkBorder,
      ),
      ColorSchemeType.forest => (
        ForestColors.darkSurface,
        ForestColors.accentEmerald,
        ForestColors.darkDisabled,
        ForestColors.darkBorder,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.darkSurface,
        WoodenColors.accentAmber,
        WoodenColors.darkDisabled,
        WoodenColors.darkBorder,
      ),
    };

    return SnackBarThemeData(
      backgroundColor: surface,
      contentTextStyle: TextStyle(color: colorScheme.onSurface, fontSize: 14),
      actionTextColor: accent,
      disabledActionTextColor: disabled,
      elevation: _elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        side: BorderSide(color: border, width: 1),
      ),
      behavior: SnackBarBehavior.floating,
    );
  }

  // ===========================================================================
  // BOTTOM SHEET THEME
  // ===========================================================================

  static BottomSheetThemeData _buildLightBottomSheetTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (card, shadow, border) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.lightCard,
        StarlightColors.lightShadow,
        StarlightColors.lightBorder,
      ),
      ColorSchemeType.forest => (
        ForestColors.lightCard,
        ForestColors.lightShadow,
        ForestColors.lightBorder,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.lightCard,
        WoodenColors.lightShadow,
        WoodenColors.lightBorder,
      ),
    };

    return BottomSheetThemeData(
      backgroundColor: card,
      elevation: _elevationHigh,
      shadowColor: shadow,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(_borderRadiusLarge),
        ),
        side: BorderSide(color: border, width: 1.5),
      ),
    );
  }

  static BottomSheetThemeData _buildDarkBottomSheetTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (card, shadow, border) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.darkCard,
        StarlightColors.darkShadow,
        StarlightColors.darkBorder,
      ),
      ColorSchemeType.forest => (
        ForestColors.darkCard,
        ForestColors.darkShadow,
        ForestColors.darkBorder,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.darkCard,
        WoodenColors.darkShadow,
        WoodenColors.darkBorder,
      ),
    };

    return BottomSheetThemeData(
      backgroundColor: card,
      elevation: _elevationHigh,
      shadowColor: shadow,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(_borderRadiusLarge),
        ),
        side: BorderSide(color: border, width: 1.5),
      ),
    );
  }

  // ===========================================================================
  // CHIP THEME
  // ===========================================================================

  static ChipThemeData _buildLightChipTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (surface, disabled, primary, secondary, border) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.lightSurface,
        StarlightColors.lightDisabled,
        StarlightColors.lightPrimary,
        StarlightColors.lightSecondary,
        StarlightColors.lightBorder,
      ),
      ColorSchemeType.forest => (
        ForestColors.lightSurface,
        ForestColors.lightDisabled,
        ForestColors.lightPrimary,
        ForestColors.lightSecondary,
        ForestColors.lightBorder,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.lightSurface,
        WoodenColors.lightDisabled,
        WoodenColors.lightPrimary,
        WoodenColors.lightSecondary,
        WoodenColors.lightBorder,
      ),
    };

    return ChipThemeData(
      backgroundColor: surface,
      disabledColor: disabled,
      selectedColor: primary.withAlpha(51),
      secondarySelectedColor: secondary.withAlpha(51),
      labelStyle: TextStyle(color: colorScheme.onSurface, fontSize: 14),
      secondaryLabelStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        side: BorderSide(color: border, width: 1),
      ),
    );
  }

  static ChipThemeData _buildDarkChipTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (surface, disabled, accent, border, accentSecondary) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.darkSurface,
        StarlightColors.darkDisabled,
        StarlightColors.accentStar,
        StarlightColors.darkBorder,
        StarlightColors.accentNebula,
      ),
      ColorSchemeType.forest => (
        ForestColors.darkSurface,
        ForestColors.darkDisabled,
        ForestColors.accentEmerald,
        ForestColors.darkBorder,
        ForestColors.accentMoss,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.darkSurface,
        WoodenColors.darkDisabled,
        WoodenColors.accentAmber,
        WoodenColors.darkBorder,
        WoodenColors.accentCopper,
      ),
    };

    return ChipThemeData(
      backgroundColor: surface,
      disabledColor: disabled,
      selectedColor: accent.withAlpha(51),
      secondarySelectedColor: accentSecondary.withAlpha(51),
      labelStyle: TextStyle(color: colorScheme.onSurface, fontSize: 14),
      secondaryLabelStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        side: BorderSide(color: border, width: 1),
      ),
    );
  }

  // ===========================================================================
  // SWITCH THEME
  // ===========================================================================

  static SwitchThemeData _buildLightSwitchTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (primary, textSecondary, divider) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.lightPrimary,
        StarlightColors.lightTextSecondary,
        StarlightColors.lightDivider,
      ),
      ColorSchemeType.forest => (
        ForestColors.lightPrimary,
        ForestColors.lightTextSecondary,
        ForestColors.lightDivider,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.lightPrimary,
        WoodenColors.lightTextSecondary,
        WoodenColors.lightDivider,
      ),
    };

    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary;
        }
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary.withAlpha(128);
        }
        return divider;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary.withAlpha(51);
        }
        return textSecondary.withAlpha(51);
      }),
    );
  }

  static SwitchThemeData _buildDarkSwitchTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (accent, textSecondary, divider) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.accentStar,
        StarlightColors.darkTextSecondary,
        StarlightColors.darkDivider,
      ),
      ColorSchemeType.forest => (
        ForestColors.accentEmerald,
        ForestColors.darkTextSecondary,
        ForestColors.darkDivider,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.accentAmber,
        WoodenColors.darkTextSecondary,
        WoodenColors.darkDivider,
      ),
    };

    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent;
        }
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent.withAlpha(128);
        }
        return divider;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accent.withAlpha(51);
        }
        return textSecondary.withAlpha(51);
      }),
    );
  }

  // ===========================================================================
  // SLIDER THEME
  // ===========================================================================

  static SliderThemeData _buildLightSliderTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (primary, divider, accent) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.lightPrimary,
        StarlightColors.lightDivider,
        StarlightColors.accentStar,
      ),
      ColorSchemeType.forest => (
        ForestColors.lightPrimary,
        ForestColors.lightDivider,
        ForestColors.accentEmerald,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.lightPrimary,
        WoodenColors.lightDivider,
        WoodenColors.accentAmber,
      ),
    };

    return SliderThemeData(
      activeTrackColor: primary,
      inactiveTrackColor: divider,
      thumbColor: accent,
      overlayColor: accent.withAlpha(51),
      valueIndicatorColor: colorScheme.surface,
      valueIndicatorTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
      ),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
    );
  }

  static SliderThemeData _buildDarkSliderTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (accent, divider, thumbColor) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.accentStar,
        StarlightColors.darkDivider,
        StarlightColors.accentNebula,
      ),
      ColorSchemeType.forest => (
        ForestColors.accentEmerald,
        ForestColors.darkDivider,
        ForestColors.accentMoss,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.accentAmber,
        WoodenColors.darkDivider,
        WoodenColors.accentCopper,
      ),
    };

    return SliderThemeData(
      activeTrackColor: accent,
      inactiveTrackColor: divider,
      thumbColor: thumbColor,
      overlayColor: thumbColor.withAlpha(51),
      valueIndicatorColor: colorScheme.surface,
      valueIndicatorTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
      ),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
    );
  }

  // ===========================================================================
  // TOOLTIP THEME
  // ===========================================================================

  static TooltipThemeData _buildLightTooltipTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (surface, border, shadow, textPrimary) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.lightSurface,
        StarlightColors.lightBorder,
        StarlightColors.lightShadow,
        StarlightColors.lightTextPrimary,
      ),
      ColorSchemeType.forest => (
        ForestColors.lightSurface,
        ForestColors.lightBorder,
        ForestColors.lightShadow,
        ForestColors.lightTextPrimary,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.lightSurface,
        WoodenColors.lightBorder,
        WoodenColors.lightShadow,
        WoodenColors.lightTextPrimary,
      ),
    };

    return TooltipThemeData(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: shadow.withAlpha(77),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      textStyle: TextStyle(color: textPrimary, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      preferBelow: true,
    );
  }

  static TooltipThemeData _buildDarkTooltipTheme(
    ColorScheme colorScheme,
    ColorSchemeType type,
  ) {
    final (surface, border, shadow, textPrimary) = switch (type) {
      ColorSchemeType.starlight => (
        StarlightColors.darkSurface,
        StarlightColors.darkBorder,
        StarlightColors.darkShadow,
        StarlightColors.darkTextPrimary,
      ),
      ColorSchemeType.forest => (
        ForestColors.darkSurface,
        ForestColors.darkBorder,
        ForestColors.darkShadow,
        ForestColors.darkTextPrimary,
      ),
      ColorSchemeType.wooden => (
        WoodenColors.darkSurface,
        WoodenColors.darkBorder,
        WoodenColors.darkShadow,
        WoodenColors.darkTextPrimary,
      ),
    };

    return TooltipThemeData(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: shadow.withAlpha(128),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      textStyle: TextStyle(color: textPrimary, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      preferBelow: true,
    );
  }
}
