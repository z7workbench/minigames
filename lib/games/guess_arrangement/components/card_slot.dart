import 'package:flutter/material.dart';
import '../../../ui/theme/wooden_colors.dart';
import '../models/playing_card.dart';
import 'card_display.dart';

/// A slot that holds a card at a specific position.
/// Used for both the guessing interface and displaying hands.
class CardSlot extends StatelessWidget {
  final int position;
  final PlayingCard? card;
  final bool isRevealed;
  final bool isCurrentPlayerCard;
  final bool isSelectable;
  final VoidCallback? onTap;
  final bool showMinIndicator;
  final bool showMaxIndicator;
  final double width;
  final double height;
  final bool enableFlipAnimation;

  const CardSlot({
    super.key,
    required this.position,
    this.card,
    this.isRevealed = false,
    this.isCurrentPlayerCard = false,
    this.isSelectable = false,
    this.onTap,
    this.showMinIndicator = false,
    this.showMaxIndicator = false,
    this.width = 60,
    this.height = 84,
    this.enableFlipAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Position indicator
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isSelectable
                ? WoodenColors.accentAmber
                : (isDark
                      ? WoodenColors.darkSurface
                      : WoodenColors.lightSurface),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? WoodenColors.darkBorder
                  : WoodenColors.lightBorder,
            ),
          ),
          child: Center(
            child: Text(
              '${position + 1}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelectable
                    ? Colors.white
                    : (isDark
                          ? WoodenColors.darkTextPrimary
                          : WoodenColors.lightTextPrimary),
              ),
            ),
          ),
        ),

        const SizedBox(height: 4),

        // Card display with optional flip animation
        enableFlipAnimation
            ? AnimatedCardDisplay(
                card: card,
                isRevealed: isRevealed,
                isHidden: !isRevealed && card != null,
                width: width,
                height: height,
                onTap: isSelectable ? onTap : null,
                isSelected: false,
                showMinIndicator: showMinIndicator,
                showMaxIndicator: showMaxIndicator,
              )
            : CardDisplay(
                card: card,
                isRevealed: isRevealed,
                isHidden: !isRevealed && card != null,
                width: width,
                height: height,
                onTap: isSelectable ? onTap : null,
                isSelected: false,
                showMinIndicator: showMinIndicator,
                showMaxIndicator: showMaxIndicator,
              ),
      ],
    );
  }
}

/// A row of card slots representing a player's hand.
class CardHandRow extends StatelessWidget {
  final List<PlayingCard> cards;
  final List<bool> revealedPositions;
  final bool isCurrentPlayerCard;
  final bool isSelectable;
  final Function(int)? onSlotTap;
  final int? selectedPosition;
  final double cardWidth;
  final double cardHeight;
  final double spacing;

  const CardHandRow({
    super.key,
    required this.cards,
    required this.revealedPositions,
    this.isCurrentPlayerCard = false,
    this.isSelectable = false,
    this.onSlotTap,
    this.selectedPosition,
    this.cardWidth = 60,
    this.cardHeight = 84,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            CardSlot(
              position: i,
              card: cards[i],
              isRevealed: revealedPositions.length > i
                  ? revealedPositions[i]
                  : false,
              isCurrentPlayerCard: isCurrentPlayerCard,
              isSelectable: isSelectable && !revealedPositions[i],
              onTap: onSlotTap != null ? () => onSlotTap!(i) : null,
              showMinIndicator: i == 0,
              showMaxIndicator: i == cards.length - 1,
              width: cardWidth,
              height: cardHeight,
            ),
            if (i < cards.length - 1) SizedBox(width: spacing),
          ],
        ],
      ),
    );
  }
}

/// Card selector for guessing - only shows ranks (A-K), not suits.
/// Players only guess the rank, not the suit.
class RankSelector extends StatelessWidget {
  final Function(int rankValue) onRankSelected;
  final Set<int>? disabledRanks;
  final double itemWidth;
  final double itemHeight;

  const RankSelector({
    super.key,
    required this.onRankSelected,
    this.disabledRanks,
    this.itemWidth = 45,
    this.itemHeight = 50,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: CardRank.values.map((rank) {
          final isDisabled = disabledRanks?.contains(rank.value) ?? false;

          return _buildRankButton(rank, isDisabled, isDark);
        }).toList(),
      ),
    );
  }

  Widget _buildRankButton(CardRank rank, bool isDisabled, bool isDark) {
    return GestureDetector(
      onTap: isDisabled ? null : () => onRankSelected(rank.value),
      child: Opacity(
        opacity: isDisabled ? 0.3 : 1.0,
        child: Container(
          width: itemWidth,
          height: itemHeight,
          decoration: BoxDecoration(
            gradient: isDisabled
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [WoodenColors.darkPrimary, WoodenColors.darkSecondary]
                        : [
                            WoodenColors.lightPrimary,
                            WoodenColors.lightSecondary,
                          ],
                  ),
            color: isDisabled
                ? (isDark
                      ? WoodenColors.darkSurface
                      : WoodenColors.lightSurface)
                : null,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark
                  ? WoodenColors.darkBorder
                  : WoodenColors.lightBorder,
            ),
            boxShadow: isDisabled
                ? null
                : [
                    BoxShadow(
                      color:
                          (isDark
                                  ? WoodenColors.darkShadow
                                  : WoodenColors.lightShadow)
                              .withAlpha(100),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              rank.symbol,
              style: TextStyle(
                fontSize: itemWidth * 0.5,
                fontWeight: FontWeight.bold,
                color: isDisabled
                    ? (isDark
                          ? WoodenColors.darkTextSecondary
                          : WoodenColors.lightTextSecondary)
                    : (isDark
                          ? WoodenColors.darkOnPrimary
                          : WoodenColors.lightOnPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
