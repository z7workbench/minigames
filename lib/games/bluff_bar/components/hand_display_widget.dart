import 'package:flutter/material.dart';
import '../../guess_arrangement/models/playing_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import 'card_widget.dart';

/// Displays a player's hand of cards with selection support for Bluff Bar.
///
/// Features:
/// - Horizontal scrollable hand display
/// - Tap to select/deselect cards (max 4 cards)
/// - Visual feedback: gray out unselected cards when selection exists
/// - Selected cards are raised with accent border
/// - Target cards and Jokers are highlighted with gradient background
/// - Theme-aware colors using context.theme* extensions
class HandDisplayWidget extends StatelessWidget {
  final List<PlayingCard> cards;
  final Set<int> selectedIndices;
  final bool isHumanTurn;
  final Function(int)? onCardTap;
  final AppLocalizations l10n;
  final CardRank? targetRank;  // 目标牌rank，用于高亮显示

  const HandDisplayWidget({
    super.key,
    required this.cards,
    required this.selectedIndices,
    required this.isHumanTurn,
    required this.l10n,
    this.onCardTap,
    this.targetRank,  // 新增参数
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Center(
        child: Text(
          l10n.bb_no_cards,
          style: TextStyle(
            color: context.themeTextSecondary,
            fontSize: 14,
          ),
        ),
      );
    }

    final hasSelection = selectedIndices.isNotEmpty;

    // Use LayoutBuilder for responsive card sizing
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive card size based on available height
        final availableHeight = constraints.maxHeight;
        final cardHeight = availableHeight.clamp(60.0, 85.0);
        final cardWidth = cardHeight * 0.7; // Maintain card ratio

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: cardHeight + 10, // Extra for raised effect
            ),
            child: Row(
              children: List.generate(cards.length, (i) {
                final isSelected = selectedIndices.contains(i);
                final card = cards[i];

                return GestureDetector(
                  onTap: isHumanTurn && onCardTap != null
                      ? () => onCardTap!(i)
                      : null,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: hasSelection && !isSelected ? 0.4 : 1.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: EdgeInsets.only(
                        right: 6,
                        bottom: isSelected ? 8 : 0, // Raised when selected
                      ),
                      child: CardWidget(
                        card: card,
                        isSelected: isSelected,
                        isFaceDown: false,
                        width: cardWidth,
                        height: cardHeight,
                        targetRank: targetRank,  // 传递目标牌
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
