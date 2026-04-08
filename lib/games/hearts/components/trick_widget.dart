import 'package:flutter/material.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../guess_arrangement/models/playing_card.dart';
import '../models/trick.dart';
import 'card_widget.dart';

/// Current trick display (4 cards in center)
class TrickWidget extends StatelessWidget {
  final Trick trick;
  final int humanPlayerPosition; // 0=South, 1=West, 2=North, 3=East
  final bool showWinner;
  final int? winnerIndex;
  final double cardWidth;
  final double cardHeight;

  const TrickWidget({
    super.key,
    required this.trick,
    this.humanPlayerPosition = 0,
    this.showWinner = false,
    this.winnerIndex,
    this.cardWidth = 70,
    this.cardHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 260,
      height: 180,
      decoration: BoxDecoration(
        color: context.themeSurface.withAlpha(30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.themeBorder.withAlpha(50), width: 1),
      ),
      child: Stack(
        children: [
          // Position cards based on player positions
          _positionCards(context, isDark),

          // Show lead suit indicator
          if (trick.cards.isNotEmpty)
            Positioned(
              top: 8,
              left: 8,
              child: _buildLeadSuitIndicator(context, isDark),
            ),

          // Show winner indicator
          if (showWinner && winnerIndex != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: _buildWinnerIndicator(context, isDark),
            ),
        ],
      ),
    );
  }

  Widget _positionCards(BuildContext context, bool isDark) {
    // Map player indices to positions relative to human player
    // Human is always at bottom (South), so we adjust other positions

    final cardPositions = <Widget>[];

    for (int i = 0; i < trick.cards.length; i++) {
      final playerIndex = trick.playerIndices[i];
      final card = trick.cards[i];

      // Calculate relative position
      final relativePos = _getRelativePosition(
        playerIndex,
        humanPlayerPosition,
      );

      final position = _getCardPosition(relativePos);

      cardPositions.add(
        Positioned(
          left: position.x,
          top: position.y,
          child: HeartsCardWidget(
            card: card,
            isFaceUp: true,
            width: cardWidth,
            height: cardHeight,
          ),
        ),
      );
    }

    return Stack(children: cardPositions);
  }

  /// Convert absolute player index to relative position from human player's perspective
  int _getRelativePosition(int playerIndex, int humanPosition) {
    // 0=South, 1=West, 2=North, 3=East
    // Relative: human is always 0 (South view)
    // So we rotate the view based on humanPosition

    return (playerIndex - humanPosition + 4) % 4;
  }

  /// Get card position based on relative player position
  /// 0=South (bottom), 1=West (left), 2=North (top), 3=East (right)
  _Position _getCardPosition(int relativePos) {
    final centerX = (260 - cardWidth) / 2;
    final centerY = (180 - cardHeight) / 2;

    switch (relativePos) {
      case 0: // South - bottom
        return _Position(centerX, centerY + 40);
      case 1: // West - left
        return _Position(centerX - 50, centerY);
      case 2: // North - top
        return _Position(centerX, centerY - 40);
      case 3: // East - right
        return _Position(centerX + 50, centerY);
      default:
        return _Position(centerX, centerY);
    }
  }

  Widget _buildLeadSuitIndicator(BuildContext context, bool isDark) {
    final leadSuit = trick.leadSuit!;
    final suitColor = _getSuitColor(leadSuit, isDark);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.themeCard,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Lead: ${leadSuit.symbol}',
        style: TextStyle(
          color: suitColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWinnerIndicator(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.themeAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Winner',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getSuitColor(CardSuit suit, bool isDark) {
    if (suit == CardSuit.hearts || suit == CardSuit.diamonds) {
      return Colors.red.shade600;
    }
    return isDark ? Colors.white : Colors.black;
  }
}

class _Position {
  final double x;
  final double y;

  _Position(this.x, this.y);
}
