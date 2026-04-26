import 'package:flutter/material.dart';

/// Forest (森林) color scheme - Green tones
/// Light Mode: Normal green + pale green
/// Dark Mode: Dark forest green (墨绿色)
class ForestColors {
  // ==================== LIGHT THEME ====================

  // Primary palette
  static const lightPrimary = Color(0xFF4CAF50); // Forest Green
  static const lightSecondary = Color(0xFF388E3C); // Pine Green

  // Surface colors
  static const lightBackground = Color(0xFFE8F5E9); // Pale Green
  static const lightSurface = Color(0xFFC8E6C9); // Mint
  static const lightCard = Color(0xFFA5D6A7); // Light Green

  // Text colors
  static const lightTextPrimary = Color(0xFF1B5E20); // Dark Forest
  static const lightTextSecondary = Color(0xFF388E3C); // Forest

  // Semantic colors - Light theme
  static const lightBorder = Color(0xFF388E3C); // Pine
  static const lightDivider = Color(0xFFC8E6C9); // Mint
  static const lightShadow = Color(0x3D000000); // 24% black
  static const lightDisabled = Color(
    0xFF81C784,
  ); // Soft Green (darker than lightCard for contrast)
  static const lightOnPrimary = Color(0xFFFFFFFF); // White
  static const lightOnSecondary = Color(0xFFFFFFFF); // White
  static const lightOnBackground = Color(0xFF1B5E20); // Dark Forest
  static const lightOnSurface = Color(0xFF1B5E20); // Dark Forest
  static const lightOnError = Color(0xFFFFFFFF); // White
  static const lightError = Color(0xFFE57373); // Rose
  static const lightSuccess = Color(0xFF4CAF50); // Green
  static const lightWarning = Color(0xFFFFB74D); // Amber

  // ==================== DARK THEME ====================

  // Primary palette
  static const darkPrimary = Color(0xFF1B5E20); // Dark Forest (墨绿)
  static const darkSecondary = Color(0xFF2E7D32); // Deep Forest

  // Surface colors
  static const darkBackground = Color(0xFF0D1F12); // Dark Moss
  static const darkSurface = Color(0xFF1A2F1C); // Deep Pine
  static const darkCard = Color(0xFF234B25); // Forest Card

  // Text colors
  static const darkTextPrimary = Color(0xFFC8E6C9); // Pale Mint
  static const darkTextSecondary = Color(0xFF81C784); // Soft Green

  // Semantic colors - Dark theme
  static const darkBorder = Color(0xFF2E7D32); // Deep Forest
  static const darkDivider = Color(0xFF1A2F1C); // Deep Pine
  static const darkShadow = Color(0x80000000); // 50% black
  static const darkDisabled = Color(0xFF388E3C); // Disabled
  static const darkOnPrimary = Color(0xFFFFFFFF); // White
  static const darkOnSecondary = Color(0xFFFFFFFF); // White
  static const darkOnBackground = Color(0xFFC8E6C9); // Pale Mint
  static const darkOnSurface = Color(0xFFC8E6C9); // Pale Mint
  static const darkOnError = Color(0xFF000000); // Black
  static const darkError = Color(0xFFFFCDD2); // Light Rose
  static const darkSuccess = Color(0xFF81C784); // Light Green
  static const darkWarning = Color(0xFFFFE0B2); // Light Amber

  // ==================== FOREST EFFECT COLORS ====================

  /// Forest light effect 1 - Pale green for gradients/patterns
  static const forestLight1 = Color(0xFFC8E6C9);

  /// Forest light effect 2 - Mint for subtle overlays
  static const forestLight2 = Color(0xFFA5D6A7);

  /// Forest dark effect 1 - Deep forest for dark patterns
  static const forestDark1 = Color(0xFF1B5E20);

  /// Forest dark effect 2 - Dark moss for subtle dark overlays
  static const forestDark2 = Color(0xFF0D1F12);

  // ==================== ACCENT COLORS ====================

  /// Emerald - Bright green accent
  static const accentEmerald = Color(
    0xFF00A844,
  ); // Darker emerald for better contrast

  /// Moss Glow - Soft green accent
  static const accentMoss = Color(0xFF69F0AE);

  /// Spring Green - Alternative bright accent
  static const accentSpring = Color(0xFF76FF03);

  /// Mint Glow - Alternative soft accent
  static const accentMintGlow = Color(0xFFB9F6CA);

  // ==================== THEME-AWARE ACCENT COLORS ====================

  /// Light mode accent color - Use emerald for high contrast
  static const lightAccent = accentEmerald;

  /// Dark mode accent color - Use moss for soft glow effect
  static const darkAccent = accentMoss;
}
