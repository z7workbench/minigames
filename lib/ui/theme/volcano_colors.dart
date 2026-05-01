import 'package:flutter/material.dart';

/// Volcano (火山) color scheme - Red & Black tones
/// Light Mode: Warm ash gray + crimson accents
/// Dark Mode: Obsidian black + lava red glow
class VolcanoColors {
  // ==================== LIGHT THEME ====================

  // Primary palette
  static const lightPrimary = Color(0xFFC62828); // Crimson
  static const lightSecondary = Color(0xFF4E342E); // Volcanic Rock

  // Surface colors
  static const lightBackground = Color(0xFFF5E6E0); // Warm Ash
  static const lightSurface = Color(0xFFE8D5CC); // Soft Ash
  static const lightCard = Color(0xFFDBC4B8); // Light Cinder

  // Text colors
  static const lightTextPrimary = Color(0xFF1A0A0A); // Obsidian
  static const lightTextSecondary = Color(0xFF5D4037); // Dark Rock

  // Semantic colors - Light theme
  static const lightBorder = Color(0xFF8D6E63); // Warm Stone
  static const lightDivider = Color(0xFFD7CCC8); // Pale Stone
  static const lightShadow = Color(0x3D000000); // 24% black
  static const lightDisabled = Color(0xFFBCAAA4); // Muted Ash
  static const lightOnPrimary = Color(0xFFFFFFFF); // White
  static const lightOnSecondary = Color(0xFFFFFFFF); // White
  static const lightOnBackground = Color(0xFF1A0A0A); // Obsidian
  static const lightOnSurface = Color(0xFF1A0A0A); // Obsidian
  static const lightOnError = Color(0xFFFFFFFF); // White
  static const lightError = Color(0xFFD32F2F); // Red Alert
  static const lightSuccess = Color(0xFF2E7D32); // Green
  static const lightWarning = Color(0xFFE65100); // Deep Orange

  // ==================== DARK THEME ====================

  // Primary palette
  static const darkPrimary = Color(0xFFFF3D00); // Lava Red
  static const darkSecondary = Color(0xFF3E2723); // Dark Basalt

  // Surface colors
  static const darkBackground = Color(0xFF120808); // Obsidian Black
  static const darkSurface = Color(0xFF1E1010); // Dark Magma
  static const darkCard = Color(0xFF2C1515); // Volcanic Card

  // Text colors
  static const darkTextPrimary = Color(0xFFFFE0D0); // Warm Light
  static const darkTextSecondary = Color(0xFFBCAAA4); // Soft Ash

  // Semantic colors - Dark theme
  static const darkBorder = Color(0xFF4E342E); // Dark Rock
  static const darkDivider = Color(0xFF2C1515); // Volcanic Divider
  static const darkShadow = Color(0x80000000); // 50% black
  static const darkDisabled = Color(0xFF5D4037); // Disabled Rock
  static const darkOnPrimary = Color(0xFFFFFFFF); // White
  static const darkOnSecondary = Color(0xFFFFE0D0); // Warm Light
  static const darkOnBackground = Color(0xFFFFE0D0); // Warm Light
  static const darkOnSurface = Color(0xFFFFE0D0); // Warm Light
  static const darkOnError = Color(0xFF000000); // Black
  static const darkError = Color(0xFFEF5350); // Light Red
  static const darkSuccess = Color(0xFF66BB6A); // Light Green
  static const darkWarning = Color(0xFFFFA726); // Light Amber

  // ==================== VOLCANO EFFECT COLORS ====================

  /// Lava Glow 1 - Bright lava for gradients/patterns
  static const lavaGlow1 = Color(0xFFFF6E40);

  /// Lava Glow 2 - Deep magma for subtle overlays
  static const lavaGlow2 = Color(0xFFFF3D00);

  /// Obsidian Dark 1 - Deep volcanic for dark patterns
  static const obsidianDark1 = Color(0xFF1A0A0A);

  /// Obsidian Dark 2 - Darkest volcanic for subtle dark overlays
  static const obsidianDark2 = Color(0xFF120808);

  // ==================== ACCENT COLORS ====================

  /// Lava - Bright red-orange accent
  static const accentLava = Color(0xFFFF3D00);

  /// Ember - Warm orange accent
  static const accentEmber = Color(0xFFFF6E40);

  /// Magma - Deep red accent
  static const accentMagma = Color(0xFFDD2C00);

  /// Ash Glow - Soft warm accent
  static const accentAshGlow = Color(0xFFFFAB91);

  // ==================== THEME-AWARE ACCENT COLORS ====================

  /// Light mode accent color - Use magma for high contrast
  static const lightAccent = accentMagma;

  /// Dark mode accent color - Use lava for glow effect
  static const darkAccent = accentLava;
}
