import 'package:flutter/material.dart';
import 'wooden_colors.dart';

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
  static ThemeData lightTheme() {
    final colorScheme = _lightColorScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: WoodenColors.lightBackground,
      canvasColor: WoodenColors.lightSurface,
      // Typography with wooden aesthetic - using system fonts
      textTheme: _buildTextTheme(colorScheme),
      // AppBar theme with wooden styling
      appBarTheme: _buildLightAppBarTheme(colorScheme),
      // Card theme with wooden texture effect
      cardTheme: _buildLightCardThemeData(),
      // Button themes
      elevatedButtonTheme: _buildLightElevatedButtonTheme(colorScheme),
      textButtonTheme: _buildLightTextButtonTheme(colorScheme),
      outlinedButtonTheme: _buildLightOutlinedButtonTheme(colorScheme),
      // Input decoration theme
      inputDecorationTheme: _buildLightInputDecorationTheme(colorScheme),
      // Floating action button theme
      floatingActionButtonTheme: _buildLightFabTheme(colorScheme),
      // Icon theme
      iconTheme: _buildLightIconTheme(colorScheme),
      // Divider theme
      dividerTheme: _buildLightDividerTheme(),
      // Dialog theme
      dialogTheme: _buildLightDialogThemeData(),
      // Snackbar theme
      snackBarTheme: _buildLightSnackbarTheme(colorScheme),
      // Bottom sheet theme
      bottomSheetTheme: _buildLightBottomSheetTheme(),
      // Chip theme
      chipTheme: _buildLightChipTheme(colorScheme),
      // Switch theme
      switchTheme: _buildLightSwitchTheme(colorScheme),
      // Slider theme
      sliderTheme: _buildLightSliderTheme(colorScheme),
      // Tooltip theme
      tooltipTheme: _buildLightTooltipTheme(),
    );
  }

  /// Returns the dark theme configuration.
  static ThemeData darkTheme() {
    final colorScheme = _darkColorScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: WoodenColors.darkBackground,
      canvasColor: WoodenColors.darkSurface,
      // Typography with wooden aesthetic
      textTheme: _buildTextTheme(colorScheme),
      // AppBar theme with wooden styling
      appBarTheme: _buildDarkAppBarTheme(colorScheme),
      // Card theme with wooden texture effect
      cardTheme: _buildDarkCardThemeData(),
      // Button themes
      elevatedButtonTheme: _buildDarkElevatedButtonTheme(colorScheme),
      textButtonTheme: _buildDarkTextButtonTheme(colorScheme),
      outlinedButtonTheme: _buildDarkOutlinedButtonTheme(colorScheme),
      // Input decoration theme
      inputDecorationTheme: _buildDarkInputDecorationTheme(colorScheme),
      // Floating action button theme
      floatingActionButtonTheme: _buildDarkFabTheme(colorScheme),
      // Icon theme
      iconTheme: _buildDarkIconTheme(colorScheme),
      // Divider theme
      dividerTheme: _buildDarkDividerTheme(),
      // Dialog theme
      dialogTheme: _buildDarkDialogThemeData(),
      // Snackbar theme
      snackBarTheme: _buildDarkSnackbarTheme(colorScheme),
      // Bottom sheet theme
      bottomSheetTheme: _buildDarkBottomSheetTheme(),
      // Chip theme
      chipTheme: _buildDarkChipTheme(colorScheme),
      // Switch theme
      switchTheme: _buildDarkSwitchTheme(colorScheme),
      // Slider theme
      sliderTheme: _buildDarkSliderTheme(colorScheme),
      // Tooltip theme
      tooltipTheme: _buildDarkTooltipTheme(),
    );
  }

  // ===========================================================================
  // COLOR SCHEMES
  // ===========================================================================

  static ColorScheme get _lightColorScheme => const ColorScheme(
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

  static ColorScheme get _darkColorScheme => const ColorScheme(
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

  static AppBarTheme _buildLightAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: WoodenColors.lightPrimary,
      foregroundColor: WoodenColors.lightOnPrimary,
      elevation: _elevationMedium,
      centerTitle: true,
      shadowColor: WoodenColors.lightShadow,
      scrolledUnderElevation: _elevationHigh,
      titleTextStyle: TextStyle(
        color: WoodenColors.lightOnPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: _letterSpacing,
        fontFamily: 'Roboto',
      ),
      iconTheme: IconThemeData(color: WoodenColors.lightOnPrimary, size: 24),
    );
  }

  static AppBarTheme _buildDarkAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: WoodenColors.darkPrimary,
      foregroundColor: WoodenColors.darkOnPrimary,
      elevation: _elevationMedium,
      centerTitle: true,
      shadowColor: WoodenColors.darkShadow,
      scrolledUnderElevation: _elevationHigh,
      titleTextStyle: TextStyle(
        color: WoodenColors.darkOnPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: _letterSpacing,
        fontFamily: 'Roboto',
      ),
      iconTheme: IconThemeData(color: WoodenColors.darkOnPrimary, size: 24),
    );
  }

  // ===========================================================================
  // CARD THEME
  // ===========================================================================

  static CardThemeData _buildLightCardThemeData() {
    return CardThemeData(
      color: WoodenColors.lightCard,
      elevation: _elevationLow,
      shadowColor: WoodenColors.lightShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusMedium),
        side: const BorderSide(color: WoodenColors.lightBorder, width: 1.5),
      ),
      margin: const EdgeInsets.all(8.0),
    );
  }

  static CardThemeData _buildDarkCardThemeData() {
    return CardThemeData(
      color: WoodenColors.darkCard,
      elevation: _elevationLow,
      shadowColor: WoodenColors.darkShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusMedium),
        side: const BorderSide(color: WoodenColors.darkBorder, width: 1.5),
      ),
      margin: const EdgeInsets.all(8.0),
    );
  }

  // ===========================================================================
  // ELEVATED BUTTON THEME
  // ===========================================================================

  static ElevatedButtonThemeData _buildLightElevatedButtonTheme(
    ColorScheme colorScheme,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: WoodenColors.lightPrimary,
        foregroundColor: WoodenColors.lightOnPrimary,
        disabledBackgroundColor: WoodenColors.lightDisabled,
        disabledForegroundColor: WoodenColors.lightTextSecondary,
        elevation: _elevationMedium,
        shadowColor: WoodenColors.lightShadow,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadiusSmall),
          side: const BorderSide(color: WoodenColors.lightBorder, width: 1),
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
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: WoodenColors.darkPrimary,
        foregroundColor: WoodenColors.darkOnPrimary,
        disabledBackgroundColor: WoodenColors.darkDisabled,
        disabledForegroundColor: WoodenColors.darkTextSecondary,
        elevation: _elevationMedium,
        shadowColor: WoodenColors.darkShadow,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadiusSmall),
          side: const BorderSide(color: WoodenColors.darkBorder, width: 1),
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
  ) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: WoodenColors.lightPrimary,
        disabledForegroundColor: WoodenColors.lightDisabled,
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
  ) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: WoodenColors.accentAmber,
        disabledForegroundColor: WoodenColors.darkDisabled,
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
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: WoodenColors.lightPrimary,
        disabledForegroundColor: WoodenColors.lightDisabled,
        side: const BorderSide(color: WoodenColors.lightBorder, width: 1.5),
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
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: WoodenColors.accentAmber,
        disabledForegroundColor: WoodenColors.darkDisabled,
        side: const BorderSide(color: WoodenColors.darkBorder, width: 1.5),
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
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: WoodenColors.lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: const BorderSide(
          color: WoodenColors.lightBorder,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: const BorderSide(
          color: WoodenColors.lightBorder,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: const BorderSide(
          color: WoodenColors.lightPrimary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: const BorderSide(
          color: WoodenColors.lightError,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: const BorderSide(color: WoodenColors.lightError, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: const BorderSide(
          color: WoodenColors.lightDisabled,
          width: 1,
        ),
      ),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant.withAlpha(153),
        fontSize: 14,
      ),
      errorStyle: const TextStyle(color: WoodenColors.lightError, fontSize: 12),
    );
  }

  static InputDecorationTheme _buildDarkInputDecorationTheme(
    ColorScheme colorScheme,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: WoodenColors.darkSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: const BorderSide(
          color: WoodenColors.darkBorder,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: const BorderSide(
          color: WoodenColors.darkBorder,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: const BorderSide(color: WoodenColors.accentAmber, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: const BorderSide(color: WoodenColors.darkError, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: const BorderSide(color: WoodenColors.darkError, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        borderSide: const BorderSide(
          color: WoodenColors.darkDisabled,
          width: 1,
        ),
      ),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant.withAlpha(153),
        fontSize: 14,
      ),
      errorStyle: const TextStyle(color: WoodenColors.darkError, fontSize: 12),
    );
  }

  // ===========================================================================
  // FLOATING ACTION BUTTON THEME
  // ===========================================================================

  static FloatingActionButtonThemeData _buildLightFabTheme(
    ColorScheme colorScheme,
  ) {
    return FloatingActionButtonThemeData(
      backgroundColor: WoodenColors.accentAmber,
      foregroundColor: WoodenColors.lightTextPrimary,
      elevation: _elevationHigh,
      focusElevation: _elevationHigh,
      hoverElevation: _elevationHigh + 2,
      disabledElevation: 0,
      highlightElevation: _elevationHigh + 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusLarge),
        side: const BorderSide(color: WoodenColors.lightBorder, width: 1.5),
      ),
    );
  }

  static FloatingActionButtonThemeData _buildDarkFabTheme(
    ColorScheme colorScheme,
  ) {
    return FloatingActionButtonThemeData(
      backgroundColor: WoodenColors.accentAmber,
      foregroundColor: WoodenColors.darkTextPrimary,
      elevation: _elevationHigh,
      focusElevation: _elevationHigh,
      hoverElevation: _elevationHigh + 2,
      disabledElevation: 0,
      highlightElevation: _elevationHigh + 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusLarge),
        side: const BorderSide(color: WoodenColors.darkBorder, width: 1.5),
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

  static DividerThemeData _buildLightDividerTheme() {
    return DividerThemeData(
      color: WoodenColors.lightDivider,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  static DividerThemeData _buildDarkDividerTheme() {
    return DividerThemeData(
      color: WoodenColors.darkDivider,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  // ===========================================================================
  // DIALOG THEME
  // ===========================================================================

  static DialogThemeData _buildLightDialogThemeData() {
    return DialogThemeData(
      backgroundColor: WoodenColors.lightCard,
      elevation: _elevationHigh,
      shadowColor: WoodenColors.lightShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusLarge),
        side: const BorderSide(color: WoodenColors.lightBorder, width: 2),
      ),
      titleTextStyle: const TextStyle(
        color: WoodenColors.lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      contentTextStyle: const TextStyle(
        color: WoodenColors.lightTextPrimary,
        fontSize: 16,
      ),
    );
  }

  static DialogThemeData _buildDarkDialogThemeData() {
    return DialogThemeData(
      backgroundColor: WoodenColors.darkCard,
      elevation: _elevationHigh,
      shadowColor: WoodenColors.darkShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusLarge),
        side: const BorderSide(color: WoodenColors.darkBorder, width: 2),
      ),
      titleTextStyle: const TextStyle(
        color: WoodenColors.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      contentTextStyle: const TextStyle(
        color: WoodenColors.darkTextPrimary,
        fontSize: 16,
      ),
    );
  }

  // ===========================================================================
  // SNACKBAR THEME
  // ===========================================================================

  static SnackBarThemeData _buildLightSnackbarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      backgroundColor: WoodenColors.lightSurface,
      contentTextStyle: TextStyle(color: colorScheme.onSurface, fontSize: 14),
      actionTextColor: WoodenColors.lightPrimary,
      disabledActionTextColor: WoodenColors.lightDisabled,
      elevation: _elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        side: const BorderSide(color: WoodenColors.lightBorder, width: 1),
      ),
      behavior: SnackBarBehavior.floating,
    );
  }

  static SnackBarThemeData _buildDarkSnackbarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      backgroundColor: WoodenColors.darkSurface,
      contentTextStyle: TextStyle(color: colorScheme.onSurface, fontSize: 14),
      actionTextColor: WoodenColors.accentAmber,
      disabledActionTextColor: WoodenColors.darkDisabled,
      elevation: _elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        side: const BorderSide(color: WoodenColors.darkBorder, width: 1),
      ),
      behavior: SnackBarBehavior.floating,
    );
  }

  // ===========================================================================
  // BOTTOM SHEET THEME
  // ===========================================================================

  static BottomSheetThemeData _buildLightBottomSheetTheme() {
    return BottomSheetThemeData(
      backgroundColor: WoodenColors.lightCard,
      elevation: _elevationHigh,
      shadowColor: WoodenColors.lightShadow,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(_borderRadiusLarge),
        ),
        side: const BorderSide(color: WoodenColors.lightBorder, width: 1.5),
      ),
    );
  }

  static BottomSheetThemeData _buildDarkBottomSheetTheme() {
    return BottomSheetThemeData(
      backgroundColor: WoodenColors.darkCard,
      elevation: _elevationHigh,
      shadowColor: WoodenColors.darkShadow,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(_borderRadiusLarge),
        ),
        side: const BorderSide(color: WoodenColors.darkBorder, width: 1.5),
      ),
    );
  }

  // ===========================================================================
  // CHIP THEME
  // ===========================================================================

  static ChipThemeData _buildLightChipTheme(ColorScheme colorScheme) {
    return ChipThemeData(
      backgroundColor: WoodenColors.lightSurface,
      disabledColor: WoodenColors.lightDisabled,
      selectedColor: WoodenColors.lightPrimary.withAlpha(51),
      secondarySelectedColor: WoodenColors.lightSecondary.withAlpha(51),
      labelStyle: TextStyle(color: colorScheme.onSurface, fontSize: 14),
      secondaryLabelStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        side: const BorderSide(color: WoodenColors.lightBorder, width: 1),
      ),
    );
  }

  static ChipThemeData _buildDarkChipTheme(ColorScheme colorScheme) {
    return ChipThemeData(
      backgroundColor: WoodenColors.darkSurface,
      disabledColor: WoodenColors.darkDisabled,
      selectedColor: WoodenColors.accentAmber.withAlpha(51),
      secondarySelectedColor: WoodenColors.accentCopper.withAlpha(51),
      labelStyle: TextStyle(color: colorScheme.onSurface, fontSize: 14),
      secondaryLabelStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        side: const BorderSide(color: WoodenColors.darkBorder, width: 1),
      ),
    );
  }

  // ===========================================================================
  // SWITCH THEME
  // ===========================================================================

  static SwitchThemeData _buildLightSwitchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return WoodenColors.lightPrimary;
        }
        return WoodenColors.lightTextSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return WoodenColors.lightPrimary.withAlpha(128);
        }
        return WoodenColors.lightDivider;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return WoodenColors.lightPrimary.withAlpha(51);
        }
        return WoodenColors.lightTextSecondary.withAlpha(51);
      }),
    );
  }

  static SwitchThemeData _buildDarkSwitchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return WoodenColors.accentAmber;
        }
        return WoodenColors.darkTextSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return WoodenColors.accentAmber.withAlpha(128);
        }
        return WoodenColors.darkDivider;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return WoodenColors.accentAmber.withAlpha(51);
        }
        return WoodenColors.darkTextSecondary.withAlpha(51);
      }),
    );
  }

  // ===========================================================================
  // SLIDER THEME
  // ===========================================================================

  static SliderThemeData _buildLightSliderTheme(ColorScheme colorScheme) {
    return SliderThemeData(
      activeTrackColor: WoodenColors.lightPrimary,
      inactiveTrackColor: WoodenColors.lightDivider,
      thumbColor: WoodenColors.accentAmber,
      overlayColor: WoodenColors.accentAmber.withAlpha(51),
      valueIndicatorColor: WoodenColors.lightSurface,
      valueIndicatorTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
      ),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
    );
  }

  static SliderThemeData _buildDarkSliderTheme(ColorScheme colorScheme) {
    return SliderThemeData(
      activeTrackColor: WoodenColors.accentAmber,
      inactiveTrackColor: WoodenColors.darkDivider,
      thumbColor: WoodenColors.accentCopper,
      overlayColor: WoodenColors.accentCopper.withAlpha(51),
      valueIndicatorColor: WoodenColors.darkSurface,
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

  static TooltipThemeData _buildLightTooltipTheme() {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: WoodenColors.lightSurface,
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        border: Border.all(color: WoodenColors.lightBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: WoodenColors.lightShadow.withAlpha(77),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      textStyle: const TextStyle(
        color: WoodenColors.lightTextPrimary,
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      preferBelow: true,
    );
  }

  static TooltipThemeData _buildDarkTooltipTheme() {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: WoodenColors.darkSurface,
        borderRadius: BorderRadius.circular(_borderRadiusSmall),
        border: Border.all(color: WoodenColors.darkBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: WoodenColors.darkShadow.withAlpha(128),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      textStyle: const TextStyle(
        color: WoodenColors.darkTextPrimary,
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      preferBelow: true,
    );
  }
}
