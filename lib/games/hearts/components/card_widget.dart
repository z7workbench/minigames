import 'package:flutter/material.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../guess_arrangement/models/playing_card.dart';

/// Single playing card widget for Hearts
class HeartsCardWidget extends StatelessWidget {
  final PlayingCard card;
  final bool isFaceUp;
  final bool isSelected;
  final bool isPlayable;
  final bool isHighlighted;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const HeartsCardWidget({
    super.key,
    required this.card,
    this.isFaceUp = true,
    this.isSelected = false,
    this.isPlayable = true,
    this.isHighlighted = false,
    this.width = 60,
    this.height = 90,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: isPlayable ? onTap : null,
      onLongPress: isPlayable ? onLongPress : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isFaceUp ? context.themeCard : context.themeSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? context.themeAccent
                : isHighlighted
                ? context.themeAccentSecondary
                : context.themeBorder,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: context.themeShadow.withAlpha(100),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: isFaceUp
            ? _buildCardFace(context, isDark)
            : _buildCardBack(context, isDark),
      ),
    );
  }

  Widget _buildCardFace(BuildContext context, bool isDark) {
    final suitColor = _getSuitColor(card.suit, isDark);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top left corner
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '${card.rank.symbol}${card.suit.symbol}',
              style: TextStyle(
                color: suitColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Center suit
          Expanded(
            child: Center(
              child: Text(
                card.suit.symbol,
                style: TextStyle(color: suitColor, fontSize: 28),
              ),
            ),
          ),

          // Bottom right corner
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '${card.rank.symbol}${card.suit.symbol}',
              style: TextStyle(
                color: suitColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.themePrimary, context.themeSecondary],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Icon(Icons.casino, color: context.themeOnPrimary, size: 24),
      ),
    );
  }

  Color _getSuitColor(CardSuit suit, bool isDark) {
    // Hearts and Diamonds are red, Spades and Clubs are black/dark
    if (suit == CardSuit.hearts || suit == CardSuit.diamonds) {
      return Colors.red.shade600;
    }
    return isDark ? Colors.white : Colors.black;
  }
}
