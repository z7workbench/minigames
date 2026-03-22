import 'package:flutter/material.dart';
import '../../../ui/theme/wooden_colors.dart';
import '../models/playing_card.dart';

/// AI回合结果汇总
class AiRoundResult {
  final int position;
  final int guessedRankValue;
  final bool wasCorrect;
  final PlayingCard? actualCard;

  const AiRoundResult({
    required this.position,
    required this.guessedRankValue,
    required this.wasCorrect,
    this.actualCard,
  });

  String get rankSymbol => _getRankSymbol(guessedRankValue);

  static String _getRankSymbol(int value) {
    switch (value) {
      case 1:
        return 'A';
      case 11:
        return 'J';
      case 12:
        return 'Q';
      case 13:
        return 'K';
      default:
        return value.toString();
    }
  }
}

/// 猜错时显示的对话框
class WrongGuessDialog extends StatelessWidget {
  final bool isAiGuess;
  final VoidCallback onContinue;

  const WrongGuessDialog({
    super.key,
    this.isAiGuess = false,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? WoodenColors.darkSurface : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Wrong icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cancel, size: 40, color: Colors.red),
            ),
            const SizedBox(height: 16),
            Text(
              isAiGuess ? 'AI猜错了！' : '猜错了！',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? WoodenColors.darkTextPrimary
                    : WoodenColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isAiGuess ? '轮到你了！' : '换对方回合了。',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? WoodenColors.darkTextSecondary
                    : WoodenColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: WoodenColors.accentAmber,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isAiGuess ? '继续' : '确定'),
            ),
          ],
        ),
      ),
    );
  }
}

/// AI回合结束汇总对话框
class AiRoundSummaryDialog extends StatelessWidget {
  final List<AiRoundResult> results;
  final VoidCallback onContinue;

  const AiRoundSummaryDialog({
    super.key,
    required this.results,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final correctCount = results.where((r) => r.wasCorrect).length;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? WoodenColors.darkSurface : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.smart_toy,
                  color: WoodenColors.accentAmber,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI回合结束',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? WoodenColors.darkTextPrimary
                        : WoodenColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'AI猜对了 $correctCount/${results.length} 次',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? WoodenColors.darkTextSecondary
                    : WoodenColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 16),
            // Results list
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Column(
                  children: results
                      .map((result) => _buildResultRow(result, isDark))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: WoodenColors.accentAmber,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('继续'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(AiRoundResult result, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Position
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? WoodenColors.darkBackground
                  : WoodenColors.lightBackground,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '位置${result.position + 1}',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          // Guessed rank
          Container(
            width: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: WoodenColors.accentAmber.withAlpha(30),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              result.rankSymbol,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          // Result icon
          Icon(
            result.wasCorrect ? Icons.check_circle : Icons.cancel,
            color: result.wasCorrect ? Colors.green : Colors.red,
            size: 20,
          ),
          // Actual card (if correct)
          if (result.wasCorrect && result.actualCard != null) ...[
            const SizedBox(width: 8),
            Text(
              result.actualCard!.displayString,
              style: TextStyle(
                fontSize: 12,
                color: result.actualCard!.suit.isRed
                    ? Colors.red
                    : Colors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 交换回合对话框（双人模式）
class TurnSwitchDialog extends StatelessWidget {
  final String nextPlayerName;
  final VoidCallback onConfirm;

  const TurnSwitchDialog({
    super.key,
    required this.nextPlayerName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? WoodenColors.darkSurface : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_horiz, size: 48, color: WoodenColors.accentAmber),
            const SizedBox(height: 16),
            Text(
              '交换回合',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? WoodenColors.darkTextPrimary
                    : WoodenColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '请将设备交给$nextPlayerName。\n记得隐藏你的牌！',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? WoodenColors.darkTextSecondary
                    : WoodenColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: WoodenColors.accentAmber,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('准备好了'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 游戏结束对话框
class GameOverDialog extends StatelessWidget {
  final String winnerName;
  final bool isPlayerWinner;
  final int correctGuesses;
  final int totalGuesses;
  final int maxCombo;
  final Duration duration;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;

  const GameOverDialog({
    super.key,
    required this.winnerName,
    this.isPlayerWinner = true,
    required this.correctGuesses,
    required this.totalGuesses,
    required this.maxCombo,
    required this.duration,
    required this.onPlayAgain,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? WoodenColors.darkSurface : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isPlayerWinner
                    ? WoodenColors.accentAmber.withAlpha(50)
                    : Colors.red.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlayerWinner
                    ? Icons.emoji_events
                    : Icons.sentiment_dissatisfied,
                size: 48,
                color: isPlayerWinner ? WoodenColors.accentGold : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isPlayerWinner ? '$winnerName赢了！' : '$winnerName赢了...',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isPlayerWinner ? WoodenColors.accentAmber : Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatRow('正确猜测', '$correctGuesses/$totalGuesses'),
            _buildStatRow('最高连击', 'x$maxCombo'),
            _buildStatRow('用时', _formatDuration(duration)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: onExit,
                  child: Text(
                    '退出',
                    style: TextStyle(
                      color: isDark
                          ? WoodenColors.darkTextSecondary
                          : WoodenColors.lightTextSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onPlayAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WoodenColors.accentAmber,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('再来一局'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '${minutes}分${seconds}秒';
  }
}
