import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import 'models/schulte_grid_state.dart';
import 'schulte_grid_provider.dart';
import 'widgets/schulte_grid_leaderboard.dart';

class SchulteGridScreen extends ConsumerStatefulWidget {
  const SchulteGridScreen({super.key});

  @override
  ConsumerState<SchulteGridScreen> createState() => _SchulteGridScreenState();
}

class _SchulteGridScreenState extends ConsumerState<SchulteGridScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    final gameState = ref.read(schulteGridGameProvider);
    if (appState == AppLifecycleState.paused ||
        appState == AppLifecycleState.inactive) {
      if (gameState.status == SchulteGridStatus.running) {
        ref.read(schulteGridGameProvider.notifier).pauseTimer();
      }
    } else if (appState == AppLifecycleState.resumed) {
      if (gameState.status == SchulteGridStatus.paused) {
        ref.read(schulteGridGameProvider.notifier).resumeTimer();
      }
    }
  }

  void _showResultsDialog(
      BuildContext context, SchulteGridState state) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          backgroundColor: themeColors.surface,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 48,
                  color: themeColors.accent,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.sg_completed,
                  style: Theme.of(dialogContext)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: themeColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: themeColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: themeColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.sg_sizeLabel(state.gridSize.dimension,
                            state.gridSize.total),
                        style: Theme.of(dialogContext)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              color: themeColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        SchulteGridState.formatTime(state.elapsedMs),
                        style: Theme.of(dialogContext)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              color: themeColors.accent,
                            ),
                      ),
                      if (state.isNewBest) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: themeColors.accent.withAlpha(40),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            l10n.sg_newBest,
                            style: Theme.of(dialogContext)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: themeColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        l10n.quit,
                        style: TextStyle(color: themeColors.textSecondary),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        SchulteGridLeaderboard.show(context);
                      },
                      child: Text(
                        l10n.leaderboard,
                        style: TextStyle(color: themeColors.accent),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        ref
                            .read(schulteGridGameProvider.notifier)
                            .startGame(state.gridSize);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColors.primary,
                        foregroundColor: themeColors.onPrimary,
                      ),
                      child: Text(l10n.newGame),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);
    final gameState = ref.watch(schulteGridGameProvider);

    ref.listen<SchulteGridState>(schulteGridGameProvider, (prev, next) {
      if (next.status == SchulteGridStatus.completed &&
          prev?.status != SchulteGridStatus.completed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showResultsDialog(context, next);
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: AppBar(
        title: Text(
          '${l10n.sg_gameTitle} - ${gameState.gridSize.label}',
        ),
        backgroundColor: themeColors.primary,
        foregroundColor: themeColors.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(schulteGridGameProvider.notifier)
                  .startGame(gameState.gridSize);
            },
            tooltip: l10n.restart,
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape =
                constraints.maxWidth > constraints.maxHeight;

            if (isLandscape) {
              return _buildLandscapeLayout(
                  context, l10n, themeColors, gameState, constraints);
            } else {
              return _buildPortraitLayout(
                  context, l10n, themeColors, gameState, constraints);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    AppLocalizations l10n,
    ThemeColorSet colors,
    SchulteGridState state,
    BoxConstraints constraints,
  ) {
    final timerAreaHeight = 100.0;
    final progressHeight = 40.0;
    final padding = 16.0;
    final availableForGrid =
        constraints.maxHeight - timerAreaHeight - progressHeight - padding * 2;
    final gridSize = (constraints.maxWidth - padding * 2)
        .clamp(0.0, availableForGrid)
        .toDouble();

    return Column(
      children: [
        const SizedBox(height: 16),
        _buildTimerDisplay(l10n, colors, state),
        const SizedBox(height: 12),
        _buildProgressIndicator(l10n, colors, state),
        const SizedBox(height: 16),
        Expanded(
          child: Center(
            child: _buildGrid(context, colors, state, gridSize),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    AppLocalizations l10n,
    ThemeColorSet colors,
    SchulteGridState state,
    BoxConstraints constraints,
  ) {
    final sidePanelWidth = 180.0;
    final padding = 16.0;
    final availableForGrid =
        constraints.maxHeight - padding * 2 - 32;
    final gridAreaWidth = constraints.maxWidth - sidePanelWidth - padding * 3;
    final gridSize =
        gridAreaWidth.clamp(0.0, availableForGrid).toDouble();

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: _buildGrid(context, colors, state, gridSize),
            ),
          ),
          SizedBox(
            width: sidePanelWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimerDisplay(l10n, colors, state),
                const SizedBox(height: 24),
                _buildProgressIndicator(l10n, colors, state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay(
    AppLocalizations l10n,
    ThemeColorSet colors,
    SchulteGridState state,
  ) {
    return Column(
      children: [
        Text(
          SchulteGridState.formatTime(state.elapsedMs),
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            color: colors.textPrimary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          state.status == SchulteGridStatus.idle
              ? l10n.sg_tapToStart
              : state.status == SchulteGridStatus.paused
                  ? l10n.sg_paused
                  : '',
          style: TextStyle(
            fontSize: 14,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(
    AppLocalizations l10n,
    ThemeColorSet colors,
    SchulteGridState state,
  ) {
    final progress =
        (state.nextNumber - 1) / state.gridSize.total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${l10n.sg_next}: ',
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textSecondary,
                ),
              ),
              Text(
                state.nextNumber <= state.gridSize.total
                    ? '${state.nextNumber}'
                    : '-',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: colors.border,
              valueColor:
                  AlwaysStoppedAnimation<Color>(colors.accent),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    ThemeColorSet colors,
    SchulteGridState state,
    double maxSize,
  ) {
    if (state.grid.isEmpty) return const SizedBox.shrink();

    final dim = state.gridSize.dimension;
    final cellGap = 4.0;
    final totalGap = cellGap * (dim - 1);
    final cellSize = (maxSize - totalGap) / dim;

    return SizedBox(
      width: maxSize,
      height: maxSize,
      child: Column(
        children: List.generate(dim, (row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(dim, (col) {
              final number = state.grid[row][col];
              final isWrong =
                  state.wrongTapRow == row && state.wrongTapCol == col;
              final isTapped = number < state.nextNumber;

              return GestureDetector(
                onTap: () {
                  ref
                      .read(schulteGridGameProvider.notifier)
                      .onTap(row, col);
                },
                child: Container(
                  width: cellSize,
                  height: cellSize,
                  margin: EdgeInsets.only(
                    right: col < dim - 1 ? cellGap : 0,
                    bottom: row < dim - 1 ? cellGap : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isWrong
                        ? Colors.red.withAlpha(180)
                        : isTapped
                            ? colors.accent.withAlpha(40)
                            : colors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isWrong
                          ? Colors.red
                          : isTapped
                              ? colors.accent.withAlpha(100)
                              : colors.border,
                      width: isTapped || isWrong ? 2 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withAlpha(60),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$number',
                        style: TextStyle(
                          fontSize: cellSize * 0.4,
                          fontWeight: FontWeight.bold,
                          color: isWrong
                              ? Colors.white
                              : isTapped
                                  ? colors.accent.withAlpha(120)
                                  : colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
