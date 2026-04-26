import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/database_provider.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';

class ReactionTestLeaderboard extends ConsumerWidget {
  const ReactionTestLeaderboard({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const ReactionTestLeaderboard(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);

    return Dialog(
      backgroundColor: themeColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: themeColors.border, width: 2),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.leaderboard, color: themeColors.accent, size: 28),
                const SizedBox(width: 12),
                Text(
                  l10n.leaderboard,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: themeColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: themeColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.rt_leaderboardSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: themeColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            Expanded(
              child: _LeaderboardList(gameType: 'reaction_test'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  l10n.close,
                  style: TextStyle(color: themeColors.accent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardList extends ConsumerWidget {
  final String gameType;

  const _LeaderboardList({required this.gameType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);

    final dao = ref.watch(gameRecordsDaoProvider);

    return FutureBuilder(
      future: dao.getTopScoresByGameType(gameType, limit: 10),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final records = snapshot.data ?? [];

        if (records.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events_outlined, size: 48, color: themeColors.textSecondary),
                const SizedBox(height: 12),
                Text(
                  l10n.rt_noRecords,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: themeColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          itemCount: records.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final record = records[index];
            final rank = index + 1;
            final isTop3 = rank <= 3;

            Color? rankColor;
            if (rank == 1) {
              rankColor = const Color(0xFFFFD700);
            } else if (rank == 2) {
              rankColor = const Color(0xFFC0C0C0);
            } else if (rank == 3) {
              rankColor = const Color(0xFFCD7F32);
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isTop3 ? themeColors.card : themeColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isTop3 ? (rankColor ?? themeColors.border) : themeColors.border,
                  width: isTop3 ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isTop3 ? (rankColor ?? themeColors.accent).withAlpha(50) : themeColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isTop3
                          ? Icon(Icons.emoji_events, size: 18, color: rankColor)
                          : Text(
                              '$rank',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: themeColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.rt_reactionTime(record.score),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: themeColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatDate(record.playedAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: themeColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}