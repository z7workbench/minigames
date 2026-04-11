import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database.dart';
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

  void _showGameOverDialog() {
    final state = ref.read(twenty48GameProvider);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
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
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: Text(l10n.quit),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
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
    final textSecondaryColor = themeColors.textSecondary;

    return PopScope(
      canPop:
          state.status == Twenty48Status.gameOver ||
          state.status == Twenty48Status.won,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          // Reset state when popping directly (game over or won)
          ref.read(twenty48GameProvider.notifier).reset();
          return;
        }

        // Game is still playing - show exit confirmation
        final saveChoice = await _showExitConfirmationDialog(context, l10n);
        if (saveChoice != null && mounted) {
          if (saveChoice == -2) {
            // User wants to save - show slot selection
            final slotIndex = await _showSaveSlotSelection(context, l10n);
            if (slotIndex != null && slotIndex >= 1 && mounted) {
              try {
                await ref
                    .read(twenty48GameProvider.notifier)
                    .saveToManualSlot(slotIndex);
              } catch (e) {
                // Ignore save errors
              }
              ref.read(twenty48GameProvider.notifier).reset();
              Navigator.of(context).pop();
            }
          } else if (saveChoice == -1) {
            // Exit without saving
            ref.read(twenty48GameProvider.notifier).reset();
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(l10n.game_2048),
          backgroundColor: themeColors.primary,
          foregroundColor: themeColors.onPrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final saveChoice = await _showExitConfirmationDialog(
                context,
                l10n,
              );
              if (saveChoice != null && mounted) {
                if (saveChoice == -2) {
                  // User wants to save - show slot selection
                  final slotIndex = await _showSaveSlotSelection(context, l10n);
                  if (slotIndex != null && slotIndex >= 1 && mounted) {
                    try {
                      await ref
                          .read(twenty48GameProvider.notifier)
                          .saveToManualSlot(slotIndex);
                    } catch (e) {
                      // Ignore save errors
                    }
                    ref.read(twenty48GameProvider.notifier).reset();
                    Navigator.of(context).pop();
                  }
                } else if (saveChoice == -1) {
                  // Exit without saving
                  ref.read(twenty48GameProvider.notifier).reset();
                  Navigator.of(context).pop();
                }
              }
            },
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
            // Save button (only show when playing)
            if (state.status == Twenty48Status.playing)
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () async {
                  final slotIndex = await _showSaveSlotSelection(context, l10n);
                  if (slotIndex != null && slotIndex >= 1 && mounted) {
                    try {
                      await ref
                          .read(twenty48GameProvider.notifier)
                          .saveToManualSlot(slotIndex);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.t48_savedSuccessfully)),
                      );
                    } catch (e) {
                      // Ignore save errors
                    }
                  }
                },
                tooltip: l10n.t48_saveGame,
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
      ),
    );
  }

  /// Show exit confirmation dialog.
  /// Returns:
  /// - null: Cancel (stay on screen)
  /// - -1: Exit without saving
  /// - -2: Save and exit (need to show slot selection)
  Future<int?> _showExitConfirmationDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);

    return showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.t48_exitTitle),
        content: Text(l10n.t48_exitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, null), // Cancel
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, -1), // Exit without saving
            child: Text(l10n.t48_exitWithoutSaving),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, -2), // Save and exit
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColors.accent,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.t48_saveAndExit),
          ),
        ],
      ),
    );
  }

  /// Show save slot selection dialog.
  /// Returns the selected slot index (1-3), or null if cancelled.
  Future<int?> _showSaveSlotSelection(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final manualSaves = await ref
        .read(twenty48GameProvider.notifier)
        .getManualSaves();
    final occupiedSlots = {for (var s in manualSaves) s.slotIndex: s};
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);

    return showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.t48_selectSlot),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (int slot = 1; slot <= 3; slot++)
                _buildSaveSlotCard(
                  context,
                  dialogContext,
                  slot,
                  occupiedSlots[slot],
                  l10n,
                  themeColors,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, null),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  /// Build a save slot card.
  Widget _buildSaveSlotCard(
    BuildContext screenContext,
    BuildContext dialogContext,
    int slotIndex,
    Twenty48Save? existingSave,
    AppLocalizations l10n,
    dynamic themeColors,
  ) {
    return InkWell(
      onTap: () async {
        if (existingSave != null) {
          final confirmed = await showDialog<bool>(
            context: screenContext,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.t48_overwrite),
              content: Text(l10n.t48_overwriteConfirm),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColors.accent,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(l10n.confirm),
                ),
              ],
            ),
          );
          if (confirmed != true) return;
        }
        Navigator.pop(dialogContext, slotIndex);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: themeColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: themeColors.card,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$slotIndex',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeColors.textPrimary,
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
                    l10n.t48_saveSlot(slotIndex),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: themeColors.textPrimary,
                    ),
                  ),
                  if (existingSave != null)
                    Text(
                      '${l10n.score}: ${existingSave.score} | ${l10n.t48_maxTile}: ${existingSave.maxTile}',
                      style: TextStyle(
                        fontSize: 12,
                        color: themeColors.textSecondary,
                      ),
                    ),
                  if (existingSave == null)
                    Text(
                      l10n.t48_emptySlot,
                      style: TextStyle(
                        fontSize: 12,
                        color: themeColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              existingSave != null ? Icons.edit : Icons.add,
              color: themeColors.accent,
            ),
          ],
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
