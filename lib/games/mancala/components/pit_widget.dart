import 'package:flutter/material.dart';

import '../../../ui/theme/wooden_colors.dart';

/// A pit widget that displays seeds and handles tap events.
class PitWidget extends StatelessWidget {
  /// Number of seeds in this pit.
  final int seeds;

  /// Whether this pit can be tapped (current player's pit with seeds).
  final bool isPlayable;

  /// Whether this is the current player's pit.
  final bool isCurrentPlayerPit;

  /// Callback when the pit is tapped.
  final VoidCallback? onTap;

  /// Whether to highlight this pit (e.g., for animation).
  final bool highlight;

  /// Pit index for identification.
  final int pitIndex;

  const PitWidget({
    super.key,
    required this.seeds,
    this.isPlayable = false,
    this.isCurrentPlayerPit = false,
    this.onTap,
    this.highlight = false,
    required this.pitIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: isPlayable && seeds > 0 ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: _buildGradient(isDark),
          border: Border.all(
            color: _borderColor(isDark),
            width: highlight ? 3 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? WoodenColors.darkShadow.withAlpha(100)
                  : WoodenColors.lightShadow.withAlpha(100),
              blurRadius: highlight ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Seed visualization
            if (seeds > 0) _buildSeeds(isDark),

            // Seed count
            Positioned(
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark
                      ? WoodenColors.darkSurface.withAlpha(200)
                      : WoodenColors.lightSurface.withAlpha(200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$seeds',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? WoodenColors.darkTextPrimary
                        : WoodenColors.lightTextPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeeds(bool isDark) {
    // Show up to 8 seeds visually, then use a number for more
    final displaySeeds = seeds.clamp(0, 8);
    final seedColor = isDark
        ? WoodenColors.accentAmber
        : WoodenColors.accentCopper;

    if (seeds <= 4) {
      // Show individual seeds for small counts
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 2,
        runSpacing: 2,
        children: List.generate(
          seeds,
          (index) => _buildSingleSeed(seedColor, 8),
        ),
      );
    } else if (seeds <= 8) {
      // Show dots for medium counts
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 1,
        runSpacing: 1,
        children: List.generate(
          displaySeeds,
          (index) => _buildSingleSeed(seedColor, 6),
        ),
      );
    } else {
      // Show a cluster for large counts
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(Icons.grain, color: seedColor, size: 24)],
      );
    }
  }

  Widget _buildSingleSeed(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(100),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }

  LinearGradient _buildGradient(bool isDark) {
    if (highlight) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [WoodenColors.darkCard, WoodenColors.accentAmber.withAlpha(50)]
            : [WoodenColors.lightCard, WoodenColors.accentAmber.withAlpha(50)],
      );
    }

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [WoodenColors.darkCard, WoodenColors.darkSurface]
          : [WoodenColors.lightCard, WoodenColors.lightSurface],
    );
  }

  Color _borderColor(bool isDark) {
    if (highlight) {
      return WoodenColors.accentAmber;
    }
    if (isPlayable && seeds > 0) {
      return isDark ? WoodenColors.accentAmber : WoodenColors.lightPrimary;
    }
    return isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder;
  }
}

/// A store widget that displays the collected seeds.
class StoreWidget extends StatelessWidget {
  /// Number of seeds in the store.
  final int seeds;

  /// Label for the store (e.g., "Your Store").
  final String? label;

  /// Whether this is the current player's store.
  final bool isCurrentPlayer;

  const StoreWidget({
    super.key,
    required this.seeds,
    this.label,
    this.isCurrentPlayer = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [WoodenColors.darkCard, WoodenColors.darkSurface]
              : [WoodenColors.lightCard, WoodenColors.lightSurface],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentPlayer
              ? WoodenColors.accentAmber
              : (isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder),
          width: isCurrentPlayer ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? WoodenColors.darkShadow.withAlpha(100)
                : WoodenColors.lightShadow.withAlpha(100),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? WoodenColors.darkTextSecondary
                    : WoodenColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Icon(
            Icons.inventory_2,
            color: isDark
                ? WoodenColors.accentAmber
                : WoodenColors.accentCopper,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            '$seeds',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isCurrentPlayer
                  ? WoodenColors.accentAmber
                  : (isDark
                        ? WoodenColors.darkTextPrimary
                        : WoodenColors.lightTextPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
