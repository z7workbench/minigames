import 'package:flutter/material.dart';

/// Starlight (星空) color scheme - Purple and deep blue tones
class StarlightColors {
  // Light theme - Soft purple and sky blue tones
  static const lightPrimary = Color(0xFF9575CD); // Soft purple
  static const lightSecondary = Color(0xFF5C6BC0); // Soft indigo
  static const lightBackground = Color(0xFFF3E5F5); // Very light purple
  static const lightSurface = Color(0xFFE8EAF6); // Light indigo tint
  static const lightCard = Color(0xFFD1C4E9); // Light purple
  static const lightTextPrimary = Color(0xFF311B92); // Deep purple
  static const lightTextSecondary = Color(0xFF5E35B1); // Medium purple
  static const lightError = Color(0xFFD32F2F);
  static const lightSuccess = Color(0xFF388E3C);
  static const lightWarning = Color(0xFFF57C00);

  // Dark theme - Deep purple and navy blue tones
  static const darkPrimary = Color(0xFF7C4DFF); // Bright purple
  static const darkSecondary = Color(0xFF536DFE); // Deep blue
  static const darkBackground = Color(0xFF0D0D1A); // Near black with blue tint
  static const darkSurface = Color(0xFF1A1A2E); // Dark navy
  static const darkCard = Color(0xFF16213E); // Deep navy
  static const darkTextPrimary = Color(0xFFE8EAF6); // Light indigo tint
  static const darkTextSecondary = Color(0xFFB39DDB); // Soft purple
  static const darkError = Color(0xFFEF5350);
  static const darkSuccess = Color(0xFF66BB6A);
  static const darkWarning = Color(0xFFFFA726);

  // Starlight effect colors
  static const starlightLight1 = Color(0xFFE1BEE7);
  static const starlightLight2 = Color(0xFFC5CAE9);
  static const starlightDark1 = Color(0xFF1A237E);
  static const starlightDark2 = Color(0xFF311B92);

  // Semantic colors - Light theme
  static const lightBorder = Color(0xFF7E57C2);
  static const lightDivider = Color(0xFFB39DDB);
  static const lightShadow = Color(0xFF5E35B1);
  static const lightDisabled = Color(0xFFB39DDB);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightOnBackground = Color(0xFF311B92);
  static const lightOnSurface = Color(0xFF311B92);
  static const lightOnError = Color(0xFFFFFFFF);

  // Semantic colors - Dark theme
  static const darkBorder = Color(0xFF7C4DFF);
  static const darkDivider = Color(0xFF3949AB);
  static const darkShadow = Color(0xFF000000);
  static const darkDisabled = Color(0xFF5C6BC0);
  static const darkOnPrimary = Color(0xFFFFFFFF);
  static const darkOnSecondary = Color(0xFFFFFFFF);
  static const darkOnBackground = Color(0xFFE8EAF6);
  static const darkOnSurface = Color(0xFFE8EAF6);
  static const darkOnError = Color(0xFF000000);

  // Accent colors for interactive elements (stars)
  static const accentStar = Color(0xFF7C4DFF); // Bright purple star
  static const accentNebula = Color(0xFFE040FB); // Pink nebula
  static const accentCosmos = Color(0xFF536DFE); // Blue cosmos
  static const accentGalaxy = Color(0xFF448AFF); // Galaxy blue

  // Theme-aware accent colors
  /// Light mode accent color - Use bright purple star
  static const lightAccent = accentStar;

  /// Dark mode accent color - Use nebula pink for glow effect
  static const darkAccent = accentNebula;
}
