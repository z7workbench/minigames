import 'package:flutter/material.dart';

/// E-Ink (墨水屏) color scheme - Pure grayscale for e-ink displays
/// Light Mode: White background with dark gray text
/// Dark Mode: Black background with light gray text
/// All colors are pure grayscale (R == G == B) for optimal e-ink rendering.
/// No shadow colors — e-ink displays do not render shadows well.
class EinkColors {
  // ==================== LIGHT THEME ====================

  // Primary palette
  static const lightPrimary = Color(0xFF333333); // Dark Gray
  static const lightSecondary = Color(0xFF555555); // Medium Gray

  // Surface colors
  static const lightBackground = Color(0xFFFFFFFF); // Pure White
  static const lightSurface = Color(0xFFF5F5F5); // Off White
  static const lightCard = Color(0xFFEEEEEE); // Light Gray

  // Text colors
  static const lightTextPrimary = Color(0xFF111111); // Near Black
  static const lightTextSecondary = Color(0xFF444444); // Dark Gray

  // Semantic colors - Light theme
  static const lightBorder = Color(0xFF888888); // Medium Gray
  static const lightDivider = Color(0xFFCCCCCC); // Light Gray
  static const lightShadow = Color(0x00000000); // Transparent - no shadows
  static const lightDisabled = Color(0xFFAAAAAA); // Muted Gray
  static const lightOnPrimary = Color(0xFFFFFFFF); // White
  static const lightOnSecondary = Color(0xFFFFFFFF); // White
  static const lightOnBackground = Color(0xFF111111); // Near Black
  static const lightOnSurface = Color(0xFF111111); // Near Black
  static const lightOnError = Color(0xFFFFFFFF); // White
  static const lightError = Color(0xFF333333); // Dark Gray (no red on e-ink)
  static const lightSuccess = Color(0xFF555555); // Medium Gray
  static const lightWarning = Color(0xFF444444); // Dark Gray

  // ==================== DARK THEME ====================

  // Primary palette
  static const darkPrimary = Color(0xFFDDDDDD); // Light Gray
  static const darkSecondary = Color(0xFFAAAAAA); // Medium Light Gray

  // Surface colors
  static const darkBackground = Color(0xFF000000); // Pure Black
  static const darkSurface = Color(0xFF111111); // Near Black
  static const darkCard = Color(0xFF222222); // Dark Gray

  // Text colors
  static const darkTextPrimary = Color(0xFFEEEEEE); // Near White
  static const darkTextSecondary = Color(0xFFBBBBBB); // Light Gray

  // Semantic colors - Dark theme
  static const darkBorder = Color(0xFF777777); // Medium Gray
  static const darkDivider = Color(0xFF333333); // Dark Gray
  static const darkShadow = Color(0x00000000); // Transparent - no shadows
  static const darkDisabled = Color(0xFF555555); // Medium Gray
  static const darkOnPrimary = Color(0xFF111111); // Near Black
  static const darkOnSecondary = Color(0xFF111111); // Near Black
  static const darkOnBackground = Color(0xFFEEEEEE); // Near White
  static const darkOnSurface = Color(0xFFEEEEEE); // Near White
  static const darkOnError = Color(0xFF000000); // Black
  static const darkError = Color(0xFFCCCCCC); // Light Gray
  static const darkSuccess = Color(0xFFAAAAAA); // Medium Light Gray
  static const darkWarning = Color(0xFFBBBBBB); // Light Gray

  // ==================== ACCENT COLORS ====================

  /// Ink - Dark gray accent for interactive elements
  static const accentInk = Color(0xFF222222);

  /// Charcoal - Medium dark accent
  static const accentCharcoal = Color(0xFF444444);

  /// Silver - Light accent for dark mode
  static const accentSilver = Color(0xFFCCCCCC);

  /// Slate - Muted accent
  static const accentSlate = Color(0xFF666666);

  // ==================== THEME-AWARE ACCENT COLORS ====================

  /// Light mode accent color - Use dark ink
  static const lightAccent = accentInk;

  /// Dark mode accent color - Use silver
  static const darkAccent = accentSilver;
}
