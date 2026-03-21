import 'package:flutter/material.dart';

import '../models/scoring.dart';
import '../models/scoring_category.dart';
import '../models/yacht_dice_state.dart';
import 'package:minigames/ui/theme/wooden_colors.dart';
import 'package:minigames/l10n/generated/app_localizations.dart';

/// A scrollable score card widget that shows potential scores for each category
/// based on the current dice values. Used during the category selection phase
/// to help players make informed decisions.
///
/// Features:
/// - Shows all 12 scoring categories
/// - Displays potential score for unused categories
/// - Shows recorded score for used categories (greyed out)
/// - Highlights positive scores with amber accent color
/// - Only tappable when `canSelect` is true
/// - Supports light/dark themes
class ScorePreviewCard extends StatelessWidget {
  /// Creates a score preview card widget.
  ///
  /// [player] is the current player's state containing their scores.
  /// [dice] are the current dice values used to calculate potential scores.
  /// [canSelect] determines if the card is interactive.
  /// [onCategorySelected] is called when a category is tapped and not yet used.
  const ScorePreviewCard({
    super.key,
    required this.player,
    required this.dice,
    required this.canSelect,
    required this.onCategorySelected,
  });

  /// The current player's state.
  final PlayerState player;

  /// The current dice values.
  final List<int> dice;

  /// Whether category selection is allowed.
  final bool canSelect;

  /// Callback when a category is tapped.
  final void Function(ScoringCategory category) onCategorySelected;

  /// Gets the theme colors based on whether we're in light or dark mode.
  static (Color cardColor, Color textColor, Color boundaryColor)
  _getThemeColors(BuildContext context, bool isUsed, int potentialScore) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      if (isUsed) {
        return (
          WoodenColors.darkSurface.withAlpha(128),
          WoodenColors.darkTextSecondary,
          Colors.transparent,
        );
      } else if (potentialScore > 0) {
        return (
          WoodenColors.darkCard,
          WoodenColors.darkTextPrimary,
          WoodenColors.accentAmber,
        );
      } else {
        return (
          WoodenColors.darkCard.withAlpha(200),
          WoodenColors.darkTextPrimary,
          Colors.transparent,
        );
      }
    } else {
      if (isUsed) {
        return (
          WoodenColors.lightSecondary.withAlpha(128),
          Colors.grey,
          Colors.transparent,
        );
      } else if (potentialScore > 0) {
        return (
          WoodenColors.lightPrimary.withAlpha(200),
          WoodenColors.lightTextPrimary,
          WoodenColors.accentAmber,
        );
      } else {
        return (
          WoodenColors.lightCard,
          WoodenColors.lightTextPrimary,
          Colors.transparent,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scores = getAllPossibleScores(dice);

    return SingleChildScrollView(
      child: Column(
        children: ScoringCategory.values.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          final score = player.scores[category];
          final isUsed = score != null;
          final potentialScore = scores[category] ?? 0;

          final (cardColor, textColor, boundaryColor) = _getThemeColors(
            context,
            isUsed,
            potentialScore,
          );

          final isCategorySelected = canSelect && !isUsed;

          return GestureDetector(
            key: ValueKey('category_$index'),
            onTap: isCategorySelected
                ? () => onCategorySelected(category)
                : null,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
                border: boundaryColor != Colors.transparent
                    ? Border.all(color: boundaryColor, width: 2)
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _getLocalizedCategoryName(category, l10n),
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isUsed
                          ? null
                          : (potentialScore > 0
                                ? WoodenColors.accentAmber.withAlpha(50)
                                : null),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isUsed
                          ? score.toString()
                          : (potentialScore > 0
                                ? '+$potentialScore'
                                : potentialScore.toString()),
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Get localized category name
  String _getLocalizedCategoryName(
    ScoringCategory category,
    AppLocalizations l10n,
  ) {
    switch (category) {
      case ScoringCategory.ones:
        return l10n.yd_ones;
      case ScoringCategory.twos:
        return l10n.yd_twos;
      case ScoringCategory.threes:
        return l10n.yd_threes;
      case ScoringCategory.fours:
        return l10n.yd_fours;
      case ScoringCategory.fives:
        return l10n.yd_fives;
      case ScoringCategory.sixes:
        return l10n.yd_sixes;
      case ScoringCategory.allSelect:
        return l10n.yd_allSelect;
      case ScoringCategory.fullHouse:
        return l10n.yd_fullHouse;
      case ScoringCategory.fourOfAKind:
        return l10n.yd_fourOfAKind;
      case ScoringCategory.smallStraight:
        return l10n.yd_smallStraight;
      case ScoringCategory.largeStraight:
        return l10n.yd_largeStraight;
      case ScoringCategory.yacht:
        return l10n.yd_yacht;
    }
  }
}
