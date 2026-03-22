import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ui/theme/wooden_colors.dart';
import '../../ui/widgets/wooden_button.dart';
import 'models/guess_arrangement_state.dart';
import 'models/playing_card.dart';
import 'guess_arrangement_provider.dart';
import 'components/card_slot.dart';
import 'components/card_display.dart';
import 'components/result_dialog.dart';

/// Main game screen for Guess Arrangement.
class GuessArrangementScreen extends ConsumerStatefulWidget {
  final AiDifficulty? aiDifficulty;

  const GuessArrangementScreen({super.key, this.aiDifficulty});

  @override
  ConsumerState<GuessArrangementScreen> createState() =>
      _GuessArrangementScreenState();
}

class _GuessArrangementScreenState
    extends ConsumerState<GuessArrangementScreen> {
  int? _selectedPosition;
  bool _showRankSelector = false;

  // AI回合相关状态
  bool _isAiTurnInProgress = false;
  int? _aiCurrentPosition;
  int? _aiCurrentRank;
  List<AiRoundResult> _aiRoundResults = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(guessArrangementGameProvider.notifier)
          .startGame(aiDifficulty: widget.aiDifficulty);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(guessArrangementGameProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? WoodenColors.darkBackground
          : WoodenColors.lightBackground,
      appBar: _buildAppBar(context, isDark),
      body: _buildBody(context, state, isDark),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      title: const Text('猜排列'),
      backgroundColor: isDark
          ? WoodenColors.darkPrimary
          : WoodenColors.lightPrimary,
      foregroundColor: isDark
          ? WoodenColors.darkOnPrimary
          : WoodenColors.lightOnPrimary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => _showExitConfirmation(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _showRestartConfirmation(context),
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    GuessArrangementState state,
    bool isDark,
  ) {
    if (state.status == GameStatus.idle) {
      return _buildLoadingState(isDark);
    }

    if (state.status == GameStatus.dealing) {
      return _buildDealingState(isDark);
    }

    if (state.status == GameStatus.switching) {
      return _buildSwitchingState(state, isDark);
    }

    if (state.isGameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameOverDialog(state);
      });
    }

    return _buildPlayingState(context, state, isDark);
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: CircularProgressIndicator(color: WoodenColors.accentAmber),
    );
  }

  Widget _buildDealingState(bool isDark) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        ref.read(guessArrangementGameProvider.notifier).finishDealing();

        // 检查是否 AI 先手
        final state = ref.read(guessArrangementGameProvider);
        if (state.isAiTurn && state.status == GameStatus.playing) {
          _startAiTurn();
        }
      });
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '发牌中...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? WoodenColors.darkTextPrimary
                  : WoodenColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 24),
          CircularProgressIndicator(color: WoodenColors.accentAmber),
        ],
      ),
    );
  }

  Widget _buildSwitchingState(GuessArrangementState state, bool isDark) {
    final nextPlayer = state.opponentPlayer;
    return Center(
      child: TurnSwitchDialog(
        nextPlayerName: nextPlayer.name,
        onConfirm: () {
          ref.read(guessArrangementGameProvider.notifier).confirmTurnSwitch();
        },
      ),
    );
  }

  Widget _buildPlayingState(
    BuildContext context,
    GuessArrangementState state,
    bool isDark,
  ) {
    return SafeArea(
      child: Column(
        children: [
          _buildGameHeader(state, isDark),
          Expanded(flex: 3, child: _buildOpponentHand(state, isDark)),
          _buildCenterInfo(state, isDark),
          if (_showRankSelector && _selectedPosition != null)
            _buildRankSelectorSheet(state, isDark),
          _buildCurrentPlayerHand(state, isDark),
          if (!state.isAiTurn) _buildActionButtons(state, isDark),
        ],
      ),
    );
  }

  Widget _buildGameHeader(GuessArrangementState state, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? WoodenColors.darkSurface : WoodenColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            icon: Icons.person,
            label: '回合',
            value: state.currentPlayer.name,
            isDark: isDark,
          ),
          _buildInfoItem(
            icon: Icons.format_list_numbered,
            label: '轮次',
            value: '${state.roundNumber}',
            isDark: isDark,
          ),
          _buildInfoItem(
            icon: Icons.local_fire_department,
            label: '连击',
            value: 'x${state.currentPlayer.maxCombo}',
            isDark: isDark,
            highlight: state.currentPlayer.maxCombo >= 3,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    bool highlight = false,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: highlight
                  ? WoodenColors.accentAmber
                  : WoodenColors.accentCopper,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? WoodenColors.darkTextSecondary
                    : WoodenColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: highlight
                ? WoodenColors.accentAmber
                : (isDark
                      ? WoodenColors.darkTextPrimary
                      : WoodenColors.lightTextPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildOpponentHand(GuessArrangementState state, bool isDark) {
    final opponent = state.opponentPlayer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        children: [
          Text(
            "${opponent.name}的牌",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? WoodenColors.darkTextPrimary
                  : WoodenColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            state.isAiTurn ? 'AI思考中...' : '点击牌来猜测',
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? WoodenColors.darkTextSecondary
                  : WoodenColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(opponent.hand.length, (index) {
                    final card = opponent.hand.cardAt(index);
                    final isRevealed = opponent.hand.isPositionRevealed(index);
                    final isAiTarget =
                        _isAiTurnInProgress && _aiCurrentPosition == index;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: state.isAiTurn || isRevealed
                            ? null
                            : () => _selectPosition(index),
                        child: Stack(
                          children: [
                            CardSlot(
                              position: index,
                              card: card,
                              isRevealed: isRevealed,
                              isSelectable: !state.isAiTurn && !isRevealed,
                              showMinIndicator: index == 0,
                              showMaxIndicator:
                                  index == opponent.hand.length - 1,
                              width: 50,
                              height: 70,
                            ),
                            if (isAiTarget)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: WoodenColors.accentAmber,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          if (_selectedPosition != null && !state.isAiTurn)
            Text(
              '已选择位置 ${_selectedPosition! + 1} - 请在下方选择数字',
              style: TextStyle(
                fontSize: 12,
                color: WoodenColors.accentAmber,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCenterInfo(GuessArrangementState state, bool isDark) {
    // 显示AI当前猜测
    if (_isAiTurnInProgress &&
        _aiCurrentPosition != null &&
        _aiCurrentRank != null) {
      final rankSymbol = CardRank.values[_aiCurrentRank! - 1].symbol;
      return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: WoodenColors.accentAmber.withAlpha(30),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: WoodenColors.accentAmber),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.smart_toy, color: WoodenColors.accentAmber),
            const SizedBox(width: 8),
            Text(
              'AI猜测: 位置${_aiCurrentPosition! + 1} 是 $rankSymbol',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: WoodenColors.accentAmber,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            state.isAiTurn ? Icons.smart_toy : Icons.person,
            size: 18,
            color: WoodenColors.accentAmber,
          ),
          const SizedBox(width: 8),
          Text(
            state.isAiTurn ? 'AI思考中...' : '你的回合！',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? WoodenColors.darkTextPrimary
                  : WoodenColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankSelectorSheet(GuessArrangementState state, bool isDark) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 220),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? WoodenColors.darkSurface : WoodenColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder,
            width: 2,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '选择数字 (A-K)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _showRankSelector = false;
                    _selectedPosition = null;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: RankSelector(
                onRankSelected: (rankValue) => _makeGuess(rankValue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPlayerHand(GuessArrangementState state, bool isDark) {
    final player = state.currentPlayer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? WoodenColors.darkSurface.withAlpha(100)
            : WoodenColors.lightSurface.withAlpha(100),
        border: Border(
          top: BorderSide(
            color: isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "你的牌",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? WoodenColors.darkTextSecondary
                  : WoodenColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(player.hand.length, (index) {
                final card = player.hand.cardAt(index);
                final isRevealed = player.hand.isPositionRevealed(index);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: CardDisplay(
                    card: card,
                    isRevealed: isRevealed,
                    isHidden: !isRevealed,
                    width: 40,
                    height: 56,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(GuessArrangementState state, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          if (widget.aiDifficulty == null)
            Expanded(
              child: WoodenButton(
                text: '结束回合',
                icon: Icons.swap_horiz,
                size: WoodenButtonSize.small,
                variant: WoodenButtonVariant.secondary,
                expandWidth: true,
                onPressed: () => _requestTurnSwitch(),
              ),
            ),
          if (widget.aiDifficulty == null) const SizedBox(width: 12),
          Expanded(
            child: WoodenButton(
              text: '清除选择',
              icon: Icons.clear,
              size: WoodenButtonSize.small,
              variant: WoodenButtonVariant.outlined,
              expandWidth: true,
              onPressed: _selectedPosition != null ? _clearSelection : null,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 游戏逻辑 ====================

  void _selectPosition(int position) {
    setState(() {
      _selectedPosition = position;
      _showRankSelector = true;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedPosition = null;
      _showRankSelector = false;
    });
  }

  void _makeGuess(int rankValue) {
    if (_selectedPosition == null) return;

    // 先保存position
    final position = _selectedPosition!;

    final opponent = ref.read(guessArrangementGameProvider).opponentPlayer;
    final actualCard = opponent.hand.cardAt(position);
    final wasCorrect = actualCard?.rank.value == rankValue;

    // 执行猜测
    ref
        .read(guessArrangementGameProvider.notifier)
        .makeGuess(position, rankValue);

    // 清除选择
    _clearSelection();

    // 获取更新后的状态
    final state = ref.read(guessArrangementGameProvider);

    if (wasCorrect) {
      // 猜对：显示snackbar + combo
      final newCombo = state.currentPlayer.currentCombo;
      _showCorrectSnackbar(newCombo, actualCard);

      // 检查游戏是否结束
      if (state.isGameOver) return;
    } else {
      // 猜错：显示对话框
      _showWrongGuessDialog(isAiGuess: false);
    }
  }

  void _showCorrectSnackbar(int combo, PlayingCard? card) {
    final message = card != null
        ? '猜对了！${card.displayString} ${combo > 1 ? '连击 x$combo' : ''}'
        : '猜对了！${combo > 1 ? '连击 x$combo' : ''}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showWrongGuessDialog({required bool isAiGuess}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => WrongGuessDialog(
        isAiGuess: isAiGuess,
        onContinue: () {
          Navigator.pop(dialogContext);

          if (widget.aiDifficulty == null && !isAiGuess) {
            // 双人模式：切换回合
            ref.read(guessArrangementGameProvider.notifier).handleWrongGuess();
          } else if (widget.aiDifficulty != null && !isAiGuess) {
            // AI模式：玩家猜错，点击确定后开始AI回合
            _startAiTurn();
          }
          // AI猜错的情况：汇总对话框在 _executeAiGuess 中已经显示
        },
      ),
    );
  }

  // ==================== AI回合 ====================

  Future<void> _startAiTurn() async {
    if (_isAiTurnInProgress) return;

    setState(() {
      _isAiTurnInProgress = true;
      _aiRoundResults = [];
    });

    await _executeAiGuess();
  }

  Future<void> _executeAiGuess() async {
    final state = ref.read(guessArrangementGameProvider);
    if (!state.isAiTurn || state.isGameOver) {
      _endAiTurn();
      return;
    }

    final notifier = ref.read(guessArrangementGameProvider.notifier);
    final decision = await notifier.getAiDecision();

    if (decision == null || !mounted) {
      _endAiTurn();
      return;
    }

    // 显示AI猜测（等待1秒）
    setState(() {
      _aiCurrentPosition = decision.position;
      _aiCurrentRank = decision.guessedRankValue;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // 执行猜测
    final result = await notifier.applyAiGuess(decision);

    // 获取实际的牌
    final actualCard = ref
        .read(guessArrangementGameProvider)
        .opponentPlayer
        .hand
        .cardAt(decision.position);

    // 记录结果
    _aiRoundResults.add(
      AiRoundResult(
        position: decision.position,
        guessedRankValue: decision.guessedRankValue,
        wasCorrect: result.wasCorrect,
        actualCard: result.wasCorrect ? actualCard : null,
      ),
    );

    // 清除当前猜测显示
    setState(() {
      _aiCurrentPosition = null;
      _aiCurrentRank = null;
    });

    if (result.wasCorrect) {
      // 猜对：显示snackbar，继续猜
      final combo = ref
          .read(guessArrangementGameProvider)
          .currentPlayer
          .currentCombo;
      _showCorrectSnackbar(combo, actualCard);

      // 检查游戏是否结束
      if (ref.read(guessArrangementGameProvider).isGameOver) {
        _endAiTurn();
        return;
      }

      // 继续AI回合
      await Future.delayed(const Duration(milliseconds: 500));
      _executeAiGuess();
    } else {
      // 猜错：显示汇总对话框
      _endAiTurn();
      _showAiRoundSummary();
    }
  }

  void _endAiTurn() {
    setState(() {
      _isAiTurnInProgress = false;
      _aiCurrentPosition = null;
      _aiCurrentRank = null;
    });
  }

  void _showAiRoundSummary() {
    if (_aiRoundResults.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AiRoundSummaryDialog(
        results: List.from(_aiRoundResults),
        onContinue: () {
          Navigator.pop(context);
          _aiRoundResults = [];
        },
      ),
    );
  }

  void _requestTurnSwitch() {
    ref.read(guessArrangementGameProvider.notifier).handleWrongGuess();
  }

  void _showGameOverDialog(GuessArrangementState state) {
    final isPlayerWinner = state.winnerIndex == 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(
        winnerName: isPlayerWinner
            ? '你'
            : (widget.aiDifficulty != null ? 'AI' : '对手'),
        isPlayerWinner: isPlayerWinner,
        correctGuesses: state.players[0].correctGuesses,
        totalGuesses: state.players[0].totalGuesses,
        maxCombo: state.players[0].maxCombo,
        duration: state.duration ?? Duration.zero,
        onPlayAgain: () {
          Navigator.pop(context);
          ref
              .read(guessArrangementGameProvider.notifier)
              .startGame(aiDifficulty: widget.aiDifficulty);
        },
        onExit: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出游戏？'),
        content: const Text('确定要退出吗？当前进度将丢失。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }

  void _showRestartConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重新开始？'),
        content: const Text('确定要重新开始游戏吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(guessArrangementGameProvider.notifier)
                  .startGame(aiDifficulty: widget.aiDifficulty);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WoodenColors.accentAmber,
            ),
            child: const Text('重新开始'),
          ),
        ],
      ),
    );
  }
}
