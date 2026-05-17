import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../ui/theme/theme_colors.dart';
import '../../ui/widgets/wooden_button.dart';
import 'components/connect_four_board.dart';
import 'models/connect_four_state.dart';
import 'models/enums.dart';
import 'connect_four_provider.dart';

class ConnectFourScreen extends ConsumerStatefulWidget {
  final AiDifficulty difficulty;

  const ConnectFourScreen({
    super.key,
    this.difficulty = AiDifficulty.easy,
  });

  @override
  ConsumerState<ConnectFourScreen> createState() => _ConnectFourScreenState();
}

class _ConnectFourScreenState extends ConsumerState<ConnectFourScreen> {
  int? _hoverCol;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGame();
    });
  }

  void _initializeGame() {
    ref
        .read(connectFourGameProvider.notifier)
        .startGame(difficulty: widget.difficulty);
  }

  void _onColumnTap(int col) {
    ref.read(connectFourGameProvider.notifier).dropPiece(col);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(connectFourGameProvider);
    final provider = ref.read(connectFourGameProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldExit = await _showExitConfirmation(context, l10n);
          if (shouldExit == true && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: context.themeBackground,
        appBar: _buildAppBar(context, state, l10n),
        body: _buildBody(context, state, provider, l10n),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ConnectFourState state,
    AppLocalizations l10n,
  ) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
              children: [
                _buildGridIcon(),
                const SizedBox(width: 8),
                Text(l10n.c4_gameTitle),
              ],
            ),
          Text(
            _getStatusText(state, l10n),
            style: TextStyle(
              fontSize: 12,
              color: context.themeOnPrimary.withAlpha(200),
            ),
          ),
        ],
      ),
      backgroundColor: context.themePrimary,
      foregroundColor: context.themeOnPrimary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () async {
          final shouldExit = await _showExitConfirmation(context, l10n);
          if (shouldExit == true && mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _handleMenuAction(value, context, l10n),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'new_game',
              child: Row(
                children: [
                  Icon(Icons.refresh, color: context.themeTextPrimary),
                  const SizedBox(width: 8),
                  Text(l10n.c4_newGame),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'undo',
              child: Row(
                children: [
                  Icon(Icons.undo, color: context.themeTextPrimary),
                  const SizedBox(width: 8),
                  Text(l10n.c4_undo),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'quit',
              child: Row(
                children: [
                  Icon(Icons.exit_to_app, color: context.themeError),
                  const SizedBox(width: 8),
                  Text(l10n.c4_exitGame),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    ConnectFourState state,
    ConnectFourGame provider,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;

          if (isLandscape) {
            return _buildLandscapeLayout(
                context, state, provider, l10n, constraints);
          } else {
            return _buildPortraitLayout(
                context, state, provider, l10n, constraints);
          }
        },
      ),
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    ConnectFourState state,
    ConnectFourGame provider,
    AppLocalizations l10n,
    BoxConstraints constraints,
  ) {
    const labelSize = 20.0;
    final availableHeight = constraints.maxHeight * 0.65;
    final availableWidth = constraints.maxWidth - 32;

    final aspectRatio = ConnectFourState.rows / ConnectFourState.cols;
    final maxBoardWidth = (availableHeight - labelSize) / aspectRatio;
    final finalBoardWidth =
        (availableWidth - labelSize) < maxBoardWidth
            ? (availableWidth - labelSize)
            : maxBoardWidth;

    final totalWidth = finalBoardWidth + labelSize;
    final totalHeight = finalBoardWidth * aspectRatio + labelSize;

    return Column(
      children: [
        _buildInfoBar(state, provider, l10n),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: totalWidth,
                height: totalHeight,
                child: Stack(
                  children: [
                    ConnectFourBoard(
                      state: state,
                      onColumnTap: _onColumnTap,
                      hoverCol: _hoverCol,
                    ),
                    if (state.phase == GamePhase.gameOver)
                      _buildGameOverOverlay(state, provider, l10n),
                  ],
                ),
              ),
            ),
          ),
        ),
        _buildBottomControls(state, provider, l10n),
      ],
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    ConnectFourState state,
    ConnectFourGame provider,
    AppLocalizations l10n,
    BoxConstraints constraints,
  ) {
    const labelSize = 20.0;
    final availableHeight = constraints.maxHeight - 16;
    final aspectRatio = ConnectFourState.rows / ConnectFourState.cols;
    final boardWidth = (availableHeight - labelSize) / aspectRatio;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: boardWidth + labelSize,
                height: availableHeight,
                child: Stack(
                  children: [
                    ConnectFourBoard(
                      state: state,
                      onColumnTap: _onColumnTap,
                      hoverCol: _hoverCol,
                    ),
                    if (state.phase == GamePhase.gameOver)
                      _buildGameOverOverlay(state, provider, l10n),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildInfoBar(state, provider, l10n),
              Expanded(child: _buildMoveHistoryPanel(state, l10n)),
              _buildBottomControls(state, provider, l10n,
                  showMoveHistoryButton: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBar(
    ConnectFourState state,
    ConnectFourGame provider,
    AppLocalizations l10n,
  ) {
    final isAiTurn = state.currentTurn == CellState.ai &&
        state.phase != GamePhase.gameOver;
    final difficultyText = _getDifficultyText(state.difficulty, l10n);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.themeSurface.withAlpha(50),
        border: Border(bottom: BorderSide(color: context.themeBorder)),
      ),
      child: Row(
        children: [
          _buildPlayerIndicator(CellState.player, l10n),
          const SizedBox(width: 8),
          Text(
            l10n.c4_vs,
            style: TextStyle(
              color: context.themeTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          _buildPlayerIndicator(CellState.ai, l10n),
          if (isAiTurn) ...[
            const SizedBox(width: 12),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.themeAccent,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              l10n.c4_thinking,
              style: TextStyle(
                color: context.themeAccent,
                fontSize: 12,
              ),
            ),
          ],
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: context.themeCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.themeBorder),
            ),
            child: Text(
              difficultyText,
              style: TextStyle(
                color: context.themeAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerIndicator(CellState piece, AppLocalizations l10n) {
    final isPlayer = piece == CellState.player;
    final isActive = piece == ref.watch(connectFourGameProvider).currentTurn;
    final color = isPlayer ? Colors.red : Colors.yellow;
    final label = isPlayer ? l10n.c4_you : l10n.c4_ai;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: isActive
                ? Border.all(color: Colors.white, width: 2)
                : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? context.themeAccent : context.themeTextPrimary,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls(
    ConnectFourState state,
    ConnectFourGame provider,
    AppLocalizations l10n, {
    bool showMoveHistoryButton = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.themeSurface.withAlpha(50),
        border: Border(top: BorderSide(color: context.themeBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: WoodenButton(
              text: l10n.c4_undo,
              icon: Icons.undo,
              variant: WoodenButtonVariant.secondary,
              onPressed: state.canUndo && !provider.isAiThinking
                  ? () {
                      provider.undoMove();
                    }
                  : null,
            ),
          ),
          if (showMoveHistoryButton) ...[
            const SizedBox(width: 8),
            Expanded(
              child: WoodenButton(
                text: l10n.c4_moveHistory,
                icon: Icons.list,
                variant: WoodenButtonVariant.secondary,
                onPressed: state.moveHistory.isNotEmpty
                    ? () => _showMoveHistoryDialog(state, l10n)
                    : null,
              ),
            ),
          ],
          const SizedBox(width: 8),
          Expanded(
            child: WoodenButton(
              text: l10n.c4_newGame,
              icon: Icons.refresh,
              variant: WoodenButtonVariant.primary,
              onPressed: () {
                _showRestartConfirmation(context, l10n);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay(
    ConnectFourState state,
    ConnectFourGame provider,
    AppLocalizations l10n,
  ) {
    String text;
    Color color;
    IconData icon;

    switch (state.result) {
      case GameResult.playerWin:
        text = l10n.c4_youWin;
        color = context.themeSuccess;
        icon = Icons.emoji_events;
        break;
      case GameResult.aiWin:
        text = l10n.c4_aiWins;
        color = context.themeError;
        icon = Icons.sentiment_dissatisfied;
        break;
      case GameResult.draw:
        text = l10n.c4_draw;
        color = context.themeWarning;
        icon = Icons.handshake;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: context.themeBackground.withAlpha(180),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _initializeGame(),
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.c4_newGame),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.themeAccent,
                    foregroundColor: context.themeOnAccent,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: Text(l10n.back),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.themeTextPrimary,
                    side: BorderSide(color: context.themeBorder),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoveHistoryPanel(ConnectFourState state, AppLocalizations l10n) {
    final notations = state.moveNotations;

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.themeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.c4_moveHistory,
            style: TextStyle(
              color: context.themeTextPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: notations.isEmpty
                ? Center(
                    child: Text(
                      l10n.c4_noMovesYet,
                      style: TextStyle(
                        color: context.themeDisabled,
                        fontSize: 12,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: (notations.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      final whiteIdx = index * 2;
                      final blackIdx = index * 2 + 1;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Text(
                                '${index + 1}.',
                                style: TextStyle(
                                  color: context.themeTextSecondary,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                whiteIdx < notations.length
                                    ? notations[whiteIdx]
                                    : '',
                                style: TextStyle(
                                  color: context.themeTextPrimary,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                blackIdx < notations.length
                                    ? notations[blackIdx]
                                    : '',
                                style: TextStyle(
                                  color: context.themeTextPrimary,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showMoveHistoryDialog(ConnectFourState state, AppLocalizations l10n) {
    final notations = state.moveNotations;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: context.themeSurface,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.c4_moveHistory,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.themeTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.maxFinite,
                height: 300,
                child: notations.isEmpty
                    ? Center(
                        child: Text(
                          l10n.c4_noMovesYet,
                          style: TextStyle(
                            color: context.themeDisabled,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: (notations.length / 2).ceil(),
                        itemBuilder: (context, index) {
                          final whiteIdx = index * 2;
                          final blackIdx = index * 2 + 1;
                          final isLastWhite =
                              whiteIdx == notations.length - 1;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 36,
                                  child: Text(
                                    '${index + 1}.',
                                    style: TextStyle(
                                      color: context.themeTextSecondary,
                                      fontSize: 14,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: isLastWhite
                                        ? BoxDecoration(
                                            color: context.themeAccent
                                                .withAlpha(30),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          )
                                        : null,
                                    child: Text(
                                      whiteIdx < notations.length
                                          ? notations[whiteIdx]
                                          : '',
                                      style: TextStyle(
                                        color: isLastWhite
                                            ? context.themeAccent
                                            : context.themeTextPrimary,
                                        fontSize: 14,
                                        fontFamily: 'monospace',
                                        fontWeight: isLastWhite
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: !isLastWhite &&
                                            blackIdx < notations.length &&
                                            blackIdx == notations.length - 1
                                        ? BoxDecoration(
                                            color: context.themeAccent
                                                .withAlpha(30),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          )
                                        : null,
                                    child: Text(
                                      blackIdx < notations.length
                                          ? notations[blackIdx]
                                          : '',
                                      style: TextStyle(
                                        color: !isLastWhite &&
                                                blackIdx < notations.length &&
                                                blackIdx ==
                                                    notations.length - 1
                                            ? context.themeAccent
                                            : context.themeTextPrimary,
                                        fontSize: 14,
                                        fontFamily: 'monospace',
                                        fontWeight: !isLastWhite &&
                                                blackIdx < notations.length &&
                                                blackIdx ==
                                                    notations.length - 1
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.themeAccent,
                    foregroundColor: context.themeOnAccent,
                  ),
                  child: Text(l10n.ok),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(ConnectFourState state, AppLocalizations l10n) {
    switch (state.phase) {
      case GamePhase.idle:
        return l10n.c4_preparing;
      case GamePhase.playing:
      case GamePhase.animating:
        return state.currentTurn == CellState.player
            ? l10n.c4_yourTurn
            : l10n.c4_aiTurn;
      case GamePhase.gameOver:
        switch (state.result) {
          case GameResult.playerWin:
            return l10n.c4_youWin;
          case GameResult.aiWin:
            return l10n.c4_aiWins;
          case GameResult.draw:
            return l10n.c4_draw;
          default:
            return '';
        }
    }
  }

  String _getDifficultyText(AiDifficulty difficulty, AppLocalizations l10n) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return l10n.c4_easy;
      case AiDifficulty.medium:
        return l10n.c4_medium;
      case AiDifficulty.hard:
        return l10n.c4_hard;
    }
  }

  void _handleMenuAction(
      String action, BuildContext context, AppLocalizations l10n) {
    switch (action) {
      case 'new_game':
        _showRestartConfirmation(context, l10n);
        break;
      case 'undo':
        ref.read(connectFourGameProvider.notifier).undoMove();
        break;
      case 'quit':
        _showExitConfirmation(context, l10n).then((shouldExit) {
          if (shouldExit == true && mounted) {
            Navigator.of(context).pop();
          }
        });
        break;
    }
  }

  Future<bool?> _showExitConfirmation(
      BuildContext context, AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.c4_exitGame),
        content: Text(l10n.c4_exitConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.themeError,
            ),
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
        title: Text(l10n.c4_newGame),
        content: Text(l10n.c4_restartConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeGame();
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  Widget _buildGridIcon() {
    const size = 8.0;
    const gap = 2.0;
    final hollowColor = context.themeOnPrimary;
    final filledColor = context.themeOnPrimary;

    Widget circle(bool filled) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? filledColor : Colors.transparent,
          border: Border.all(color: hollowColor, width: 1.2),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            circle(false),
            const SizedBox(width: gap),
            circle(true),
          ],
        ),
        const SizedBox(height: gap),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            circle(false),
            const SizedBox(width: gap),
            circle(false),
          ],
        ),
      ],
    );
  }
}
