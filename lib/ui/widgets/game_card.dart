import 'package:flutter/material.dart';
import '../../models/game_type.dart';
import '../theme/theme_colors.dart';

/// A card widget displaying a game with wooden styling.
///
/// Shows the game icon, title, and description. Placeholder games
/// display a "Coming Soon" badge instead of being clickable.
class GameCard extends StatelessWidget {
  /// The game type to display.
  final GameType gameType;

  /// The localized title of the game.
  final String title;

  /// The localized description of the game.
  final String description;

  /// Callback when the card is tapped (only called for non-placeholder games).
  final VoidCallback? onTap;

  /// Whether this game is a placeholder/coming soon.
  final bool isPlaceholder;

  /// The localized "Coming Soon" text.
  final String? comingSoonText;

  /// Creates a game card widget.
  const GameCard({
    super.key,
    required this.gameType,
    required this.title,
    required this.description,
    this.onTap,
    this.isPlaceholder = false,
    this.comingSoonText,
  });

  IconData get _iconData => gameType.iconData;

  @override
  Widget build(BuildContext context) {
    final cardColor = context.themeCard;
    final borderColor = context.themeBorder;
    final textColor = context.themeTextPrimary;
    final secondaryTextColor = context.themeTextSecondary;
    final disabledColor = context.themeDisabled;
    final accentColor = context.themeAccent;

    return Card(
      color: cardColor,
      elevation: isPlaceholder ? 1.0 : 4.0,
      shadowColor: context.themeShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: isPlaceholder ? disabledColor : borderColor,
          width: isPlaceholder ? 1.0 : 1.5,
        ),
      ),
      child: InkWell(
        onTap: isPlaceholder ? null : onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Game Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isPlaceholder
                      ? disabledColor.withValues(alpha: 0.2)
                      : accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: isPlaceholder ? disabledColor : accentColor,
                    width: 2.0,
                  ),
                ),
                child: Icon(
                  _iconData,
                  size: 28,
                  color: isPlaceholder ? disabledColor : accentColor,
                ),
              ),
              const SizedBox(height: 10.0),
              // Game Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isPlaceholder ? disabledColor : textColor,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6.0),
              // Game Description
              Flexible(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: isPlaceholder ? disabledColor : secondaryTextColor,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Coming Soon Badge
              if (isPlaceholder) ...[
                const SizedBox(height: 6.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 3.0,
                  ),
                  decoration: BoxDecoration(
                    color: disabledColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    comingSoonText ?? 'Coming Soon',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: disabledColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
