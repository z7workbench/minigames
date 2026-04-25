import 'package:flutter/material.dart';

import '../models/bluff_bar_state.dart';
import '../../guess_arrangement/models/playing_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';

/// Displays the pile of played cards with claim information.
/// Responsive design for both portrait and landscape.
class PlayedPileWidget extends StatelessWidget {
  final List<PlayedCards> playedPile;
  final int lastPlayerCardCount;
  final CardRank? lastClaim;
  final AppLocalizations l10n;

  const PlayedPileWidget({
    super.key,
    required this.playedPile,
    required this.lastPlayerCardCount,
    required this.l10n,
    this.lastClaim,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total cards played this round
    final totalCardsPlayed = playedPile.fold(0, (sum, play) => sum + play.count);
    
    if (playedPile.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.themeSurface.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.themeBorder),
        ),
        child: Text(
          l10n.bb_no_cards_played,
          style: TextStyle(
            color: context.themeTextSecondary,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.themeSurface.withAlpha(100),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.themeBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Last claim display
          if (lastClaim != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: context.themeAccent.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.themeAccent),
              ),
              child: Text(
                lastClaim!.symbol,
                style: TextStyle(
                  color: context.themeAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Total cards played text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.layers,
                color: context.themeSecondary,
                size: 18,
              ),
              const SizedBox(width: 6),
Text(
                l10n.bb_cards_played_total(totalCardsPlayed),
                style: TextStyle(
                  color: context.themeTextSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Visual representation of last player's played cards (face down)
          _buildCardStack(context),
        ],
      ),
    );
  }

  Widget _buildCardStack(BuildContext context) {
    final displayCount = lastPlayerCardCount.clamp(0, 5);
    final overflowCount = lastPlayerCardCount > 5 ? lastPlayerCardCount - 5 : 0;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: [
        for (int i = 0; i < displayCount; i++)
          Container(
            width: 36,
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [context.themePrimary, context.themeSecondary],
              ),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: context.themeOnAccent,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.diamond,
              size: 18,
              color: context.themeOnAccent,
            ),
          ),
        if (overflowCount > 0)
          Container(
            width: 36,
            height: 54,
            decoration: BoxDecoration(
              color: context.themeCard,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: context.themeBorder),
            ),
            child: Center(
              child: Text(
                '+$overflowCount',
                style: TextStyle(
                  color: context.themeTextPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}