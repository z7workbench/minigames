import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../models/bluff_bar_player.dart';
import '../models/bluff_bar_state.dart';

/// Round ranking overlay displayed after roulette completes.
/// Shows rankings sorted by:
/// 1. Survivors first (fewer roulette shots = higher rank)
/// 2. Eliminated players last
///
/// Auto-dismisses after 2 seconds and starts the next round.
class RoundRankingOverlay extends ConsumerStatefulWidget {
  final BluffBarState state;
  final VoidCallback? onComplete;

  const RoundRankingOverlay({
    super.key,
    required this.state,
    this.onComplete,
  });

  @override
  ConsumerState<RoundRankingOverlay> createState() => _RoundRankingOverlayState();
}

class _RoundRankingOverlayState extends ConsumerState<RoundRankingOverlay> {
  @override
  void initState() {
    super.initState();
    // Auto-dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  List<BluffBarPlayer> _getRankings() {
    final sorted = List<BluffBarPlayer>.from(widget.state.players);
    sorted.sort((a, b) {
      // Survivors first
      if (a.isEliminated != b.isEliminated) {
        return a.isEliminated ? 1 : -1;
      }
      // Then by roulette shots (fewer shots = higher rank)
      return a.rouletteDeck.currentIndex.compareTo(b.rouletteDeck.currentIndex);
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rankings = _getRankings();

    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.themeSurface.withAlpha(240),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.themeBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.bb_round_ranking(widget.state.roundNumber),
              style: TextStyle(
                color: context.themeTextPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...rankings.asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final player = entry.value;
              return _buildRankingRow(context, player, rank, l10n);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingRow(
    BuildContext context,
    BluffBarPlayer player,
    int rank,
    AppLocalizations l10n,
  ) {
    final positionName = _getPositionName(player.index);
    final shots = player.rouletteDeck.currentIndex;
    final shotsText = '${l10n.bb_roulette_shots}: $shots/6';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '#$rank',
                style: TextStyle(
                  color: context.themeTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                positionName,
                style: TextStyle(
                  color: player.isEliminated
                      ? context.themeError
                      : context.themeTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (player.isEliminated) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.themeError.withAlpha(50),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: context.themeError,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    l10n.bb_eliminated,
                    style: TextStyle(
                      color: context.themeError,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Row(
            children: [
              Text(
                shotsText,
                style: TextStyle(
                  color: player.isEliminated
                      ? context.themeError
                      : context.themeTextSecondary,
                  fontSize: 13,
                ),
              ),
              if (player.isEliminated) ...[
                const SizedBox(width: 8),
                const Text('💀', style: TextStyle(fontSize: 16)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _getPositionName(int index) {
    switch (index) {
      case 0:
        return '南';
      case 1:
        return '东';
      case 2:
        return '西';
      case 3:
        return '北';
      default:
        return 'P${index + 1}';
    }
  }
}
