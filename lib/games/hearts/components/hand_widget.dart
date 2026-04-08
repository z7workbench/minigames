import 'package:flutter/material.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../guess_arrangement/models/playing_card.dart';
import 'card_widget.dart';

/// Player's hand of cards with selection support
class HandWidget extends StatelessWidget {
  final List<PlayingCard> cards;
  final Set<PlayingCard>? selectedCards;
  final Set<PlayingCard>?
  legalCards; // Cards that can be played (highlighted during turn)
  final Set<PlayingCard>?
  highlightedCards; // Reserved for future use (currently not used in Hearts)
  final bool isSelectable;
  final int maxSelectable;
  final Function(PlayingCard)? onCardTap;
  final Function(PlayingCard)? onCardLongPress;
  final bool isHorizontal;
  final double cardWidth;
  final double cardHeight;
  final double overlap;

  const HandWidget({
    super.key,
    required this.cards,
    this.selectedCards,
    this.legalCards,
    this.highlightedCards,
    this.isSelectable = false,
    this.maxSelectable = 13,
    this.onCardTap,
    this.onCardLongPress,
    this.isHorizontal = true,
    this.cardWidth = 60,
    this.cardHeight = 90,
    this.overlap = 30,
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Center(
        child: Text(
          'No cards',
          style: TextStyle(color: context.themeTextSecondary, fontSize: 14),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.themeSurface.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: isHorizontal
          ? _buildHorizontalHand(context)
          : _buildVerticalHand(context),
    );
  }

  Widget _buildHorizontalHand(BuildContext context) {
    final cardSpacing = cardWidth - overlap;
    final totalWidth = cardWidth + (cards.length - 1) * cardSpacing;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: totalWidth,
        height: cardHeight,
        child: Stack(
          children: cards.asMap().entries.map((entry) {
            final index = entry.key;
            final card = entry.value;
            final isSelected = selectedCards?.contains(card) ?? false;
            final isLegal = legalCards?.contains(card) ?? false;
            final canSelectMore = (selectedCards?.length ?? 0) < maxSelectable;
            final isPlayable = isSelectable && (isSelected || canSelectMore);
            // Only highlight legal cards when it's the player's turn
            // (isSelectable is true only during human's turn in playing phase)
            final shouldHighlight = isLegal && isSelectable && !isSelected;

            return Positioned(
              left: index * cardSpacing,
              child: Transform.translate(
                offset: Offset(0, isSelected ? -10 : 0),
                child: HeartsCardWidget(
                  card: card,
                  isSelected: isSelected,
                  isPlayable: isPlayable,
                  isHighlighted: shouldHighlight,
                  width: cardWidth,
                  height: cardHeight,
                  onTap: onCardTap != null ? () => onCardTap!(card) : null,
                  onLongPress: onCardLongPress != null
                      ? () => onCardLongPress!(card)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildVerticalHand(BuildContext context) {
    final cardSpacing = cardHeight - overlap;
    final totalHeight = cardHeight + (cards.length - 1) * cardSpacing;

    return SizedBox(
      width: cardWidth,
      height: totalHeight,
      child: Stack(
        children: cards.asMap().entries.map((entry) {
          final index = entry.key;
          final card = entry.value;
          final isSelected = selectedCards?.contains(card) ?? false;

          return Positioned(
            top: index * cardSpacing,
            child: HeartsCardWidget(
              card: card,
              isSelected: isSelected,
              isPlayable: isSelectable,
              width: cardWidth,
              height: cardHeight,
              onTap: onCardTap != null ? () => onCardTap!(card) : null,
              onLongPress: onCardLongPress != null
                  ? () => onCardLongPress!(card)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  int get selectedCount => selectedCards?.length ?? 0;
  bool get canSelectMore => selectedCount < maxSelectable;
}
