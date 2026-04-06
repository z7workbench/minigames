import 'package:flutter/material.dart';
import '../models/playing_card.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

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
  final AppLocalizations l10n;
  final VoidCallback onContinue;

  const WrongGuessDialog({
    super.key,
    this.isAiGuess = false,
    required this.l10n,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: context.themeSurface,
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
              isAiGuess ? l10n.ga_aiWrongGuess : l10n.ga_wrongGuessTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? context.themeTextPrimary
                    : context.themeTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isAiGuess ? l10n.ga_turnToYou : l10n.ga_turnToOpponent,
              style: TextStyle(fontSize: 14, color: context.themeTextSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.themeAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isAiGuess ? l10n.ga_continue : l10n.ok),
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
  final AppLocalizations l10n;
  final VoidCallback onContinue;

  const AiRoundSummaryDialog({
    super.key,
    required this.results,
    required this.l10n,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final correctCount = results.where((r) => r.wasCorrect).length;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: context.themeSurface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.smart_toy, color: context.themeAccent, size: 28),
                const SizedBox(width: 8),
                Text(
                  l10n.ga_aiRoundEnd,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.themeTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.ga_aiCorrectCount(correctCount, results.length),
              style: TextStyle(fontSize: 14, color: context.themeTextSecondary),
            ),
            const SizedBox(height: 16),
            // Results list
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Column(
                  children: results
                      .map((result) => _buildResultRow(result, isDark, context))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.themeAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.ga_continue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(
    AiRoundResult result,
    bool isDark,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Position
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: context.themeBackground,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              l10n.ga_positionLabel(result.position + 1),
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
              color: context.themeAccent.withAlpha(30),
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
  final AppLocalizations l10n;
  final VoidCallback onConfirm;

  const TurnSwitchDialog({
    super.key,
    required this.nextPlayerName,
    required this.l10n,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: context.themeSurface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_horiz, size: 48, color: context.themeAccent),
            const SizedBox(height: 16),
            Text(
              l10n.ga_switchTurns,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? context.themeTextPrimary
                    : context.themeTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.ga_switchTurnHint(nextPlayerName),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: context.themeTextSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.themeAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.ga_readyToPlay),
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
  final AppLocalizations l10n;
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
    required this.l10n,
    required this.onPlayAgain,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: context.themeSurface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.themeAccent.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlayerWinner
                    ? Icons.emoji_events
                    : Icons.sentiment_dissatisfied,
                size: 48,
                color: isPlayerWinner ? context.themeAccent : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isPlayerWinner
                  ? l10n.ga_winnerWins(winnerName)
                  : l10n.ga_winnerLoses(winnerName),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isPlayerWinner ? context.themeAccent : Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatRow(
              l10n.ga_correctGuessesLabel,
              '$correctGuesses/$totalGuesses',
            ),
            _buildStatRow(l10n.ga_maxComboLabel, 'x$maxCombo'),
            _buildStatRow(l10n.ga_playDurationLabel, _formatDuration(duration)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: onExit,
                  child: Text(
                    l10n.ga_exit,
                    style: TextStyle(color: context.themeTextSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: onPlayAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.themeAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(l10n.ga_playAgainButton),
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
    return l10n.ga_durationFormat(minutes, seconds);
  }
}
