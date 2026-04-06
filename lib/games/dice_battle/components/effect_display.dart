import 'package:flutter/material.dart';

import '../../../ui/theme/wooden_colors.dart';

import '../../../ui/theme/theme_colors.dart';
import '../models/battle_effect.dart';

/// Displays the current battle effect with animation.
class EffectDisplay extends StatelessWidget {
  /// Current battle effect (null if no effect active).
  final BattleEffect? effect;

  /// Whether this is the first round (no effect).
  final bool isFirstRound;

  const EffectDisplay({super.key, this.effect, this.isFirstRound = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isFirstRound || effect == null) {
      return _buildNoEffect(context, isDark);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.themeAccent, context.themeAccentSecondary],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.themeAccent.withAlpha(100),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getEffectIcon(effect!), color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Effect',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withAlpha(200),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                effect!.displayName,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoEffect(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.themeCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.themeBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.remove_circle_outline,
            color: context.themeTextSecondary,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            'No Active Effect',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? context.themeTextSecondary
                  : context.themeTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEffectIcon(BattleEffect effect) {
    switch (effect) {
      case BattleEffect.oddBonus:
        return Icons.exposure_plus_1;
      case BattleEffect.evenBonus:
        return Icons.shield;
      case BattleEffect.comboOnLowDamage:
        return Icons.flash_on;
      case BattleEffect.diceUpgrade:
        return Icons.upgrade;
      case BattleEffect.perfectBlockInstant:
        return Icons.shield_moon;
      case BattleEffect.comboOnHighAttack:
        return Icons.bolt;
      case BattleEffect.lifeSyncBonus:
        return Icons.favorite;
      // Legacy effects
      case BattleEffect.doubleDamage:
        return Icons.flash_on;
      case BattleEffect.diceSwap:
        return Icons.swap_horiz;
    }
  }
}

/// Shows a floating effect notification.
class EffectNotification extends StatelessWidget {
  final BattleEffect effect;
  final VoidCallback onDismiss;

  const EffectNotification({
    super.key,
    required this.effect,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.themeAccent, context.themeAccentSecondary],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getEffectIcon(effect), size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              'New Effect!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white.withAlpha(230),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              effect.displayName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              effect.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withAlpha(200),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: context.themeAccent,
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEffectIcon(BattleEffect effect) {
    switch (effect) {
      case BattleEffect.oddBonus:
        return Icons.exposure_plus_1;
      case BattleEffect.evenBonus:
        return Icons.shield;
      case BattleEffect.comboOnLowDamage:
        return Icons.flash_on;
      case BattleEffect.diceUpgrade:
        return Icons.upgrade;
      case BattleEffect.perfectBlockInstant:
        return Icons.shield_moon;
      case BattleEffect.comboOnHighAttack:
        return Icons.bolt;
      case BattleEffect.lifeSyncBonus:
        return Icons.favorite;
      // Legacy effects
      case BattleEffect.doubleDamage:
        return Icons.flash_on;
      case BattleEffect.diceSwap:
        return Icons.swap_horiz;
    }
  }
}
