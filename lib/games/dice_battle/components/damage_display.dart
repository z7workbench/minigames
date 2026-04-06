import 'package:flutter/material.dart';

import '../../../ui/theme/theme_colors.dart';

/// Displays damage dealt with animation.
class DamageDisplay extends StatelessWidget {
  /// Amount of damage dealt.
  final int damage;

  /// Whether the damage was critical (double damage).
  final bool isCritical;

  /// Animation controller value (0.0 to 1.0).
  final double animationValue;

  const DamageDisplay({
    super.key,
    required this.damage,
    this.isCritical = false,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AlwaysStoppedAnimation(animationValue),
      builder: (context, child) {
        final scale = 0.5 + (animationValue * 0.8);
        final opacity = animationValue < 0.8
            ? 1.0
            : 1.0 - ((animationValue - 0.8) * 5);

        return Transform.scale(
          scale: scale,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isCritical
                ? [Colors.red, Colors.red.shade700]
                : [context.themeAccent, context.themeAccentSecondary],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (isCritical ? Colors.red : context.themeAccent)
                  .withAlpha(150),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCritical)
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flash_on, color: Colors.yellow, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'CRITICAL!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.flash_on, color: Colors.yellow, size: 28),
                ],
              ),
            const SizedBox(height: 8),
            Text(
              '-$damage',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'DAMAGE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white.withAlpha(230),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows a blocking indicator when damage is blocked.
class BlockedDisplay extends StatelessWidget {
  final double animationValue;

  const BlockedDisplay({super.key, required this.animationValue});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AlwaysStoppedAnimation(animationValue),
      builder: (context, child) {
        final scale = 0.5 + (animationValue * 0.5);
        final opacity = animationValue < 0.7
            ? 1.0
            : 1.0 - ((animationValue - 0.7) * 3.33);

        return Transform.scale(
          scale: scale,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade700],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withAlpha(150),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield, color: Colors.white, size: 64),
            SizedBox(height: 12),
            Text(
              'BLOCKED!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Defense was too strong!',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
