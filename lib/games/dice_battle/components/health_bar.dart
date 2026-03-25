import 'package:flutter/material.dart';

import '../../../ui/theme/wooden_colors.dart';

/// A health bar widget showing player HP with animated transitions.
class HealthBar extends StatelessWidget {
  /// Current health value.
  final int currentHealth;

  /// Maximum health value.
  final int maxHealth;

  /// Player name to display.
  final String playerName;

  /// Whether this is the active/current player.
  final bool isActive;

  /// Size of the health bar.
  final double height;

  const HealthBar({
    super.key,
    required this.currentHealth,
    required this.maxHealth,
    required this.playerName,
    this.isActive = false,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final healthPercentage = currentHealth / maxHealth;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? WoodenColors.darkSurface : WoodenColors.lightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? WoodenColors.accentAmber
              : (isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                playerName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? WoodenColors.darkTextPrimary
                      : WoodenColors.lightTextPrimary,
                ),
              ),
              Text(
                '$currentHealth / $maxHealth HP',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? WoodenColors.darkTextSecondary
                      : WoodenColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: Container(
              height: height - 16,
              decoration: BoxDecoration(
                color: isDark ? WoodenColors.darkCard : WoodenColors.lightCard,
              ),
              child: Stack(
                children: [
                  // Background
                  Container(
                    width: double.infinity,
                    color: isDark
                        ? WoodenColors.darkDisabled.withAlpha(50)
                        : WoodenColors.lightDisabled.withAlpha(50),
                  ),
                  // Health fill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: healthPercentage * 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _getHealthColors(healthPercentage),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getHealthColors(double percentage) {
    if (percentage > 0.6) {
      return [Colors.green, Colors.green.shade600];
    } else if (percentage > 0.3) {
      return [Colors.orange, Colors.orange.shade600];
    } else {
      return [Colors.red, Colors.red.shade600];
    }
  }
}
