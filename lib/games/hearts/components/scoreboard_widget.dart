import 'package:flutter/material.dart';
import '../../../ui/theme/theme_colors.dart';
import '../models/hearts_player.dart';

/// Score board showing all player scores
class ScoreboardWidget extends StatelessWidget {
  final List<HeartsPlayer> players;
  final int currentRound;
  final int humanPlayerIndex;
  final bool showGameScores;
  final bool compact;

  const ScoreboardWidget({
    super.key,
    required this.players,
    this.currentRound = 1,
    this.humanPlayerIndex = 0,
    this.showGameScores = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sort players by total score (ascending - lower is better in Hearts)
    final sortedPlayers = List<HeartsPlayer>.from(players)
      ..sort((a, b) => a.totalScore.compareTo(b.totalScore));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.themeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Round indicator
          Text(
            'Round $currentRound',
            style: TextStyle(
              color: context.themeTextPrimary,
              fontSize: compact ? 12 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Player scores (sorted by score, lowest first)
          ...sortedPlayers.asMap().entries.map(
            (entry) => _buildPlayerScore(
              context,
              entry.value,
              entry.value.index == humanPlayerIndex,
              isDark,
              compact,
              entry.key + 1, // Rank (1st, 2nd, 3rd, 4th)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(
    BuildContext context,
    HeartsPlayer player,
    bool isHuman,
    bool isDark,
    bool compact,
    int rank, // Player's rank (1-4)
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Rank indicator
          Container(
            width: compact ? 20 : 28,
            height: compact ? 20 : 28,
            decoration: BoxDecoration(
              color: rank == 1
                  ? context.themeAccent
                  : rank == 2
                  ? context.themeSecondary
                  : context.themeBorder,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 10 : 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Player name
          Expanded(
            child: Text(
              isHuman ? 'You' : player.name,
              style: TextStyle(
                color: context.themeTextPrimary,
                fontSize: compact ? 12 : 14,
              ),
            ),
          ),

          // Round score
          if (!showGameScores)
            Text(
              '${player.roundScore}',
              style: TextStyle(
                color: player.roundScore > 0
                    ? Colors.red.shade600
                    : context.themeAccent,
                fontSize: compact ? 12 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),

          // Game score
          if (showGameScores)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${player.totalScore}',
                  style: TextStyle(
                    color: player.totalScore >= 100
                        ? Colors.red.shade600
                        : context.themeTextPrimary,
                    fontSize: compact ? 12 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!compact)
                  Text(
                    '(${player.roundScore} this round)',
                    style: TextStyle(
                      color: context.themeTextSecondary,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
