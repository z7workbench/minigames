import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import 'models/twenty48_state.dart';
import 'twenty48_provider.dart';
import 'components/grid_widget.dart';

/// Main game screen for 2048.
class Twenty48Screen extends ConsumerStatefulWidget {
  /// Creates the 2048 game screen.
  const Twenty48Screen({super.key});

  @override
  ConsumerState<Twenty48Screen> createState() => _Twenty48ScreenState();
}

class _Twenty48ScreenState extends ConsumerState<Twenty48Screen> {
  Offset? _swipeStart;
  static const double _swipeThreshold = 50.0;

  @override
  void initState() {
    super.initState();
    // Start a new game if the state is idle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(twenty48GameProvider);
      if (state.status == Twenty48Status.idle) {
        ref.read(twenty48GameProvider.notifier).startNewGame();
      }
    });
  }

  void _handleSwipeStart(DragStartDetails details) {
    _swipeStart = details.localPosition;
  }

  void _handleSwipeEnd(DragEndDetails details) {
    if (_swipeStart == null) return;

    final state = ref.read(twenty48GameProvider);
    if (state.status != Twenty48Status.playing) return;

    final swipeEnd = details.velocity.pixelsPerSecond;
    final dx = swipeEnd.dx;
    final dy = swipeEnd.dy;

    if (dx.abs() > dy.abs()) {
      // Horizontal swipe
      if (dx > _swipeThreshold) {
        ref.read(twenty48GameProvider.notifier).move(Twenty48Direction.right);
      } else if (dx < -_swipeThreshold) {
        ref.read(twenty48GameProvider.notifier).move(Twenty48Direction.left);
      }
    } else {
      // Vertical swipe
      if (dy > _swipeThreshold) {
        ref.read(twenty48GameProvider.notifier).move(Twenty48Direction.down);
      } else if (dy < -_swipeThreshold) {
        ref.read(twenty48GameProvider.notifier).move(Twenty48Direction.up);
      }
    }

    _swipeStart = null;
  }

  void _showExitDialog() {
    final state = ref.read(twenty48GameProvider);
    if (state.status == Twenty48Status.gameOver ||
        state.status == Twenty48Status.won) {
      Navigator.of(context).pop();
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.t48_exitTitle),
        content: Text(l10n.t48_exitMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(l10n.t48_exitWithoutSaving),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _showSaveDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.themeAccent,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.t48_saveAndExit),
          ),
        ],
      ),
    );
  }

  Future<void> _showSaveDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(twenty48GameProvider.notifier);

    // Get available slot
    final saves = await notifier.getAllSaves();
    final slotIndex = saves.length < 5 ? saves.length : 0;

    await notifier.saveGame(slotIndex);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.t48_saveGame)));
      Navigator.pop(context);
    }
  }

  void _showGameOverDialog() {
    final state = ref.read(twenty48GameProvider);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          state.status == Twenty48Status.won
              ? l10n.t48_youWon
              : l10n.t48_gameOver,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${l10n.score}: ${state.score}'),
            Text('${l10n.t48_maxTile}: ${state.maxTile}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(l10n.quit),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(twenty48GameProvider.notifier).startNewGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.themeAccent,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.t48_playAgain),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(twenty48GameProvider);

    // Show game over dialog when game ends
    ref.listen<Twenty48State>(twenty48GameProvider, (prev, next) {
      if (prev?.status != next.status &&
          (next.status == Twenty48Status.gameOver ||
              next.status == Twenty48Status.won)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showGameOverDialog();
        });
      }
    });

    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);
    final backgroundColor = themeColors.background;
    final textPrimaryColor = themeColors.textPrimary;
    final textSecondaryColor = themeColors.textSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(l10n.game_2048),
        backgroundColor: themeColors.primary,
        foregroundColor: themeColors.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _showExitDialog,
          tooltip: l10n.back,
        ),
        actions: [
          IconButton(
            icon: Icon(
              state.status == Twenty48Status.paused
                  ? Icons.play_arrow
                  : Icons.pause,
            ),
            onPressed: () {
              if (state.status == Twenty48Status.paused) {
                ref.read(twenty48GameProvider.notifier).resume();
              } else if (state.status == Twenty48Status.playing) {
                ref.read(twenty48GameProvider.notifier).pause();
              }
            },
            tooltip: state.status == Twenty48Status.paused
                ? l10n.play
                : l10n.pause,
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragStart: _handleSwipeStart,
          onHorizontalDragEnd: _handleSwipeEnd,
          onVerticalDragStart: _handleSwipeStart,
          onVerticalDragEnd: _handleSwipeEnd,
          child: Column(
            children: [
              // Score and time display
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScoreCard(
                      context,
                      l10n.score,
                      state.score.toString(),
                      isDark,
                    ),
                    _buildScoreCard(
                      context,
                      l10n.highScore,
                      state.bestScore.toString(),
                      isDark,
                    ),
                    _buildScoreCard(
                      context,
                      l10n.time,
                      _formatTime(state.elapsedSeconds),
                      isDark,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Game grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: GridWidget(grid: state.grid),
                ),
              ),

              const Spacer(),

              // Instructions
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  l10n.t48_instructions,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textSecondaryColor, fontSize: 14),
                ),
              ),

              // New game button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: WoodenButton(
                  text: l10n.t48_newGame,
                  icon: Icons.refresh,
                  size: WoodenButtonSize.medium,
                  variant: WoodenButtonVariant.secondary,
                  expandWidth: true,
                  onPressed: () {
                    ref.read(twenty48GameProvider.notifier).startNewGame();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(
    BuildContext context,
    String label,
    String value,
    bool isDark,
  ) {
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: themeColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: themeColors.border, width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: themeColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
