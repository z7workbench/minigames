import 'package:flutter/material.dart';

import '../../../ui/theme/theme_colors.dart';

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
          gradient: _buildGradient(context, isDark),
          border: Border.all(
            color: _borderColor(context, isDark),
            width: highlight ? 3 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: context.themeShadow.withAlpha(100),
              blurRadius: highlight ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Seed visualization
            if (seeds > 0) _buildSeeds(context, isDark),

            // Seed count
            Positioned(
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.themeSurface.withAlpha(200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$seeds',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: context.themeTextPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeeds(BuildContext context, bool isDark) {
    // Show up to 8 seeds visually, then use a number for more
    final displaySeeds = seeds.clamp(0, 8);
    final seedColor = context.themeAccent;

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

  LinearGradient _buildGradient(BuildContext context, bool isDark) {
    if (highlight) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [context.themeCard, context.themeAccent.withAlpha(50)],
      );
    }

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [context.themeCard, context.themeSurface],
    );
  }

  Color _borderColor(BuildContext context, bool isDark) {
    if (highlight) {
      return context.themeAccent;
    }
    if (isPlayable && seeds > 0) {
      return context.themeAccent;
    }
    return context.themeBorder;
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
          colors: [context.themeCard, context.themeSurface],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentPlayer ? context.themeAccent : context.themeBorder,
          width: isCurrentPlayer ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: context.themeShadow.withAlpha(100),
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
                color: context.themeTextSecondary,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Icon(Icons.inventory_2, color: context.themeAccent, size: 20),
          const SizedBox(height: 4),
          Text(
            '$seeds',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isCurrentPlayer
                  ? context.themeAccent
                  : context.themeTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
