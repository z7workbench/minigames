import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';

import '../../../ui/theme/wooden_colors.dart';
import 'components/board_widget.dart';
import 'models/mancala_state.dart';
import 'mancala_provider.dart';

/// Main game screen for Mancala.
class MancalaScreen extends ConsumerStatefulWidget {
  /// AI difficulty for single-player mode (null for 2-player).
  final AiDifficulty? aiDifficulty;

  const MancalaScreen({super.key, this.aiDifficulty});

  @override
  ConsumerState<MancalaScreen> createState() => _MancalaScreenState();
}

class _MancalaScreenState extends ConsumerState<MancalaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(mancalaGameProvider.notifier)
          .startGame(aiDifficulty: widget.aiDifficulty);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mancalaGameProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    // Listen for game over
    ref.listen<MancalaState>(mancalaGameProvider, (prev, next) {
      if (prev?.status != next.status &&
          next.status == MancalaStatus.gameOver) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showGameOverDialog(next, l10n);
        });
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && state.status == MancalaStatus.playing) {
          final shouldExit = await _showExitConfirmation(context, l10n);
          if (shouldExit == true) {
            Navigator.of(context).pop();
          }
        } else if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: isDark
            ? WoodenColors.darkBackground
            : WoodenColors.lightBackground,
        appBar: AppBar(
          title: Text(l10n.game_mancala),
          backgroundColor: isDark
              ? WoodenColors.darkPrimary
              : WoodenColors.lightPrimary,
          foregroundColor: isDark
              ? WoodenColors.darkOnPrimary
              : WoodenColors.lightOnPrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (state.status == MancalaStatus.playing) {
                final shouldExit = await _showExitConfirmation(context, l10n);
                if (shouldExit == true && mounted) {
                  Navigator.of(context).pop();
                }
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _showRestartConfirmation(context, l10n),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Score header
              _buildScoreHeader(state, isDark, l10n),

              // Main game board
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BoardWidget(
                    state: state,
                    onPitSelected: (pitIndex) {
                      ref
                          .read(mancalaGameProvider.notifier)
                          .selectPit(pitIndex);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreHeader(
    MancalaState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [WoodenColors.darkSurface, WoodenColors.darkCard]
              : [WoodenColors.lightSurface, WoodenColors.lightCard],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Player 1 score
          _buildScoreItem(
            label: widget.aiDifficulty != null
                ? l10n.mc_playerStore
                : 'Player 1',
            score: state.player1Store,
            isActive:
                state.currentPlayer == 0 &&
                state.status == MancalaStatus.playing,
            isDark: isDark,
          ),

          // Timer
          Column(
            children: [
              Icon(Icons.timer, color: WoodenColors.accentAmber, size: 20),
              const SizedBox(height: 4),
              Text(
                _formatTime(state.elapsedSeconds),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? WoodenColors.darkTextPrimary
                      : WoodenColors.lightTextPrimary,
                ),
              ),
            ],
          ),

          // Player 2 score
          _buildScoreItem(
            label: widget.aiDifficulty != null
                ? l10n.mc_opponentStore
                : 'Player 2',
            score: state.player2Store,
            isActive:
                state.currentPlayer == 1 &&
                state.status == MancalaStatus.playing,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem({
    required String label,
    required int score,
    required bool isActive,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? WoodenColors.accentAmber.withAlpha(30)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? Border.all(color: WoodenColors.accentAmber, width: 2)
            : null,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? WoodenColors.darkTextSecondary
                  : WoodenColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$score',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isActive
                  ? WoodenColors.accentAmber
                  : (isDark
                        ? WoodenColors.darkTextPrimary
                        : WoodenColors.lightTextPrimary),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<bool?> _showExitConfirmation(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.quit),
        content: Text('确定要退出游戏吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.quit),
          ),
        ],
      ),
    );
  }

  void _showRestartConfirmation(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.restart),
        content: Text('确定要重新开始吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(mancalaGameProvider.notifier)
                  .startGame(aiDifficulty: widget.aiDifficulty);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog(MancalaState state, AppLocalizations l10n) {
    final winner = state.winner;
    final scores = state.finalScores;

    String title;
    String message;

    if (winner == null) {
      title = l10n.mc_draw;
      message = '双方都获得了 ${scores.player1} 粒种子！';
    } else if (widget.aiDifficulty != null) {
      title = winner == 0 ? l10n.mc_youWin : l10n.mc_aiWins;
      message = winner == 0
          ? '你获得了 ${scores.player1} 粒种子，AI获得了 ${scores.player2} 粒种子！'
          : 'AI获得了 ${scores.player2} 粒种子，你获得了 ${scores.player1} 粒种子！';
    } else {
      title = 'Player ${winner + 1} Wins!';
      message =
          '玩家${winner + 1}获得了 ${winner == 0 ? scores.player1 : scores.player2} 粒种子！';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              winner != null ? Icons.emoji_events : Icons.handshake,
              color: WoodenColors.accentAmber,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(message),
            const SizedBox(height: 8),
            Text(
              '用时: ${_formatTime(state.elapsedSeconds)}',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? WoodenColors.darkTextSecondary
                    : WoodenColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(l10n.mc_exit),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(mancalaGameProvider.notifier)
                  .startGame(aiDifficulty: widget.aiDifficulty);
            },
            child: Text(l10n.mc_playAgain),
          ),
        ],
      ),
    );
  }
}
