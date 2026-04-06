import 'package:flutter/material.dart';

import '../models/yacht_dice_state.dart';
import '../models/scoring_category.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Shows a bottom sheet modal with detailed score breakdown for a player
void showScoreDetailModal(BuildContext context, PlayerState player) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ScoreDetailContent(player: player),
  );
}

class _ScoreDetailContent extends StatefulWidget {
  final PlayerState player;

  const _ScoreDetailContent({required this.player});

  @override
  State<_ScoreDetailContent> createState() => _ScoreDetailContentState();
}

class _ScoreDetailContentState extends State<_ScoreDetailContent> {
  Color get backgroundColor => context.themeCard;
  Color get surfaceColor => context.themeSurface;
  Color get textPrimaryColor => context.themeTextPrimary;
  Color get textSecondaryColor => context.themeTextSecondary;
  Color get dividerColor => context.themeDivider;
  Color get accentColor => context.themeAccent;
  Color get successColor => context.themeSuccess;

  Color get primaryColor => context.themePrimary;

  /// Upper section categories in order
  static const List<ScoringCategory> upperCategories = [
    ScoringCategory.ones,
    ScoringCategory.twos,
    ScoringCategory.threes,
    ScoringCategory.fours,
    ScoringCategory.fives,
    ScoringCategory.sixes,
  ];

  /// Lower section categories in order
  static const List<ScoringCategory> lowerCategories = [
    ScoringCategory.allSelect,
    ScoringCategory.fullHouse,
    ScoringCategory.fourOfAKind,
    ScoringCategory.smallStraight,
    ScoringCategory.largeStraight,
    ScoringCategory.yacht,
  ];

  /// Calculate upper section sum
  int get upperSum {
    return upperCategories
        .map((category) => widget.player.scores[category] ?? 0)
        .reduce((a, b) => a + b);
  }

  /// Calculate bonus (35 if upper sum >= 63)
  int get bonus => upperSum >= 63 ? 35 : 0;

  /// Calculate lower section sum
  int get lowerSum {
    return lowerCategories
        .map((category) => widget.player.scores[category] ?? 0)
        .reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          _buildHeader(l10n),

          const SizedBox(height: 8),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Upper Section
                  _buildSectionTitle(l10n.yd_bonusThreshold),
                  const SizedBox(height: 8),
                  ...upperCategories.map(
                    (category) =>
                        _buildCategoryRow(category: category, l10n: l10n),
                  ),
                  Divider(color: dividerColor, height: 24),
                  _buildSubtotalRow(l10n.score, upperSum),
                  const SizedBox(height: 8),
                  _buildBonusRow(l10n.yd_bonus, bonus, upperSum),

                  const SizedBox(height: 24),

                  // Lower Section
                  _buildSectionTitle('Lower Section'),
                  const SizedBox(height: 8),
                  ...lowerCategories.map(
                    (category) =>
                        _buildCategoryRow(category: category, l10n: l10n),
                  ),
                  Divider(color: dividerColor, height: 24),
                  _buildSubtotalRow('Lower Total', lowerSum),

                  const SizedBox(height: 24),

                  // Grand Total
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withAlpha(60),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Grand Total',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textPrimaryColor,
                          ),
                        ),
                        Text(
                          widget.player.totalScore.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.player.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.score,
                  style: TextStyle(fontSize: 14, color: textSecondaryColor),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: primaryColor.withAlpha(60),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.player.totalScore.toString(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: surfaceColor.withAlpha(100),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textSecondaryColor,
        ),
      ),
    );
  }

  Widget _buildCategoryRow({
    required ScoringCategory category,
    required AppLocalizations l10n,
  }) {
    final score = widget.player.scores[category];
    final isPlayed = score != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getLocalizedCategoryName(category, l10n),
            style: TextStyle(
              fontSize: 16,
              color: isPlayed ? textPrimaryColor : textSecondaryColor,
              fontWeight: isPlayed ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          Text(
            isPlayed ? score.toString() : '-',
            style: TextStyle(
              fontSize: 16,
              color: isPlayed ? textPrimaryColor : textSecondaryColor,
              fontWeight: isPlayed ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtotalRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textSecondaryColor,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusRow(String label, int bonusValue, int upperTotal) {
    final hasBonus = bonusValue > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: hasBonus ? accentColor : textSecondaryColor,
                ),
              ),
              const SizedBox(width: 8),
              if (hasBonus)
                Icon(Icons.check_circle, size: 16, color: successColor),
            ],
          ),
          Text(
            bonusValue.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: hasBonus ? successColor : textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

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
