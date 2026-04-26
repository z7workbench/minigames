import 'package:flutter/material.dart';
import '../../models/game_type.dart';
import '../theme/theme_colors.dart';

/// A card widget displaying a game with wooden styling.
///
/// Shows the game icon, title, and description.
class GameCard extends StatelessWidget {
  /// The game type to display.
  final GameType gameType;

  /// The localized title of the game.
  final String title;

  /// The localized description of the game.
  final String description;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Whether this game is marked as a favorite.
  final bool isFavorite;

  /// Callback when the favorite button is tapped.
  final VoidCallback? onToggleFavorite;

  /// Creates a game card widget.
  const GameCard({
    super.key,
    required this.gameType,
    required this.title,
    required this.description,
    this.onTap,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  IconData get _iconData => gameType.iconData;

  @override
  Widget build(BuildContext context) {
    final cardColor = context.themeCard;
    final borderColor = context.themeBorder;
    final textColor = context.themeTextPrimary;
    final secondaryTextColor = context.themeTextSecondary;
    final accentColor = context.themeAccent;

    return Card(
      elevation: 4.0,
      shadowColor: context.themeShadow,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Main content
            Padding(
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
                      color: accentColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: accentColor,
                        width: 2.0,
                      ),
                    ),
                    child: Icon(
                      _iconData,
                      size: 28,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // Game Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
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
                        color: secondaryTextColor,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            
            // Favorite button - inside card, top-right corner
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onToggleFavorite,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 24,
                    color: isFavorite ? context.themeError : context.themeDisabled,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
