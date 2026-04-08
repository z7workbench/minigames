import 'package:flutter/material.dart';
import '../../../ui/theme/theme_colors.dart';
import '../models/hearts_player.dart';
import '../models/enums.dart';

/// Position enum for player layout
enum PlayerPosition {
  south, // bottom (human player)
  west, // left
  north, // top
  east, // right
}

/// Player info display (name, position, AI indicator)
class PlayerInfoWidget extends StatelessWidget {
  final HeartsPlayer player;
  final bool isCurrentTurn;
  final bool isHuman;
  final PlayerPosition position;
  final String? displayName; // Override display name if provided

  const PlayerInfoWidget({
    super.key,
    required this.player,
    this.isCurrentTurn = false,
    this.isHuman = false,
    required this.position,
    this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    // Determine display name: use override, then position-based, then player name
    final name = displayName ?? _getPositionName();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrentTurn
            ? context.themeAccent.withAlpha(150)
            : context.themeSurface.withAlpha(100),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentTurn
              ? context.themeAccent
              : context.themeBorder.withAlpha(50),
          width: isCurrentTurn ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AI indicator
          if (!isHuman) ...[
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _getDifficultyColor(player.aiDifficulty),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 10),
            ),
            const SizedBox(width: 4),
          ],

          // Name - flexible to handle overflow
          Flexible(
            child: Text(
              name,
              style: TextStyle(
                color: context.themeTextPrimary,
                fontSize: 12,
                fontWeight: isCurrentTurn ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Card count
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: context.themeCard,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${player.cardCount}',
              style: TextStyle(color: context.themeTextSecondary, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  /// Get position-based display name
  String _getPositionName() {
    // If this is the human player, always show "You"
    if (isHuman) return 'You';

    // Otherwise, use visual position name
    switch (position) {
      case PlayerPosition.south:
        return 'South Player';
      case PlayerPosition.west:
        return 'West Player';
      case PlayerPosition.north:
        return 'North Player';
      case PlayerPosition.east:
        return 'East Player';
    }
  }

  Color _getDifficultyColor(AiDifficulty? difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return Colors.green;
      case AiDifficulty.medium:
        return Colors.orange;
      case AiDifficulty.hard:
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }
}
