import 'package:flutter/material.dart';

import '../../guess_arrangement/models/playing_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import 'card_widget.dart';

/// Displays a hand of cards with optional selection and interaction.
/// Responsive design supporting both portrait and landscape orientations.
class HandWidget extends StatelessWidget {
  final List<PlayingCard> cards;
  final Set<int> selectedIndices;
  final bool isHumanPlayer;
  final Function(int)? onCardTap;
  final double cardWidth;
  final double cardHeight;
  final double overlap;
  final AppLocalizations l10n;

  const HandWidget({
    super.key,
    required this.cards,
    required this.l10n,
    this.selectedIndices = const {},
    this.isHumanPlayer = false,
    this.onCardTap,
    this.cardWidth = 60,
    this.cardHeight = 84,
    this.overlap = 25,
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Container(
        height: cardHeight + 20,
        alignment: Alignment.center,
        child: Text(
          l10n.bb_no_cards,
          style: TextStyle(
            color: context.themeTextSecondary,
            fontSize: 14,
          ),
        ),
      );
    }

    // Responsive card size based on available width
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final totalWidth = cards.length > 1 
            ? cardWidth + (cards.length - 1) * overlap
            : cardWidth;
        
        // Scale down if cards would overflow
        double scale = 1.0;
        if (totalWidth > availableWidth) {
          scale = availableWidth / totalWidth;
        }

        final scaledWidth = cardWidth * scale;
        final scaledHeight = cardHeight * scale;
        final scaledOverlap = overlap * scale;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: scaledHeight + 20,
            child: Stack(
              children: [
                for (int i = 0; i < cards.length; i++)
                  Positioned(
                    left: i * scaledOverlap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      transform: selectedIndices.contains(i)
                          ? Matrix4.translationValues(0, -10, 0)
                          : null,
                      child: CardWidget(
                        card: cards[i],
                        isSelected: selectedIndices.contains(i),
                        isFaceDown: !isHumanPlayer,
                        width: scaledWidth,
                        height: scaledHeight,
                        onTap: isHumanPlayer && onCardTap != null
                            ? () => onCardTap!(i)
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}