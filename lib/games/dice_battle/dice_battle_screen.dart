import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ui/theme/wooden_colors.dart';
import '../../ui/widgets/wooden_button.dart';
import '../../ui/widgets/wooden_app_bar.dart';
import 'models/dice_battle_state.dart';
import 'models/dice_battle_player.dart';
import 'models/dice_set.dart';
import 'components/health_bar.dart';
import 'components/effect_display.dart';
import 'components/battle_log.dart';
import 'components/dice_selector.dart';
import 'dice_battle_provider.dart';

/// Main game screen for Dice Battle.
class DiceBattleScreen extends ConsumerStatefulWidget {
  final AiDifficulty? aiDifficulty;
  final DiceSet player1Set;
  final DiceSet player2Set;

  const DiceBattleScreen({
    super.key,
    this.aiDifficulty,
    required this.player1Set,
    required this.player2Set,
  });

  @override
  ConsumerState<DiceBattleScreen> createState() => _DiceBattleScreenState();
}

class _DiceBattleScreenState extends ConsumerState<DiceBattleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(diceBattleGameProvider.notifier)
          .startGame(
            aiDifficulty: widget.aiDifficulty,
            player1Set: widget.player1Set,
            player2Set: widget.player2Set,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diceBattleGameProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? WoodenColors.darkBackground
          : WoodenColors.lightBackground,
      appBar: WoodenAppBar(
        titleText: 'Dice Battle',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _showRestartConfirmation(context),
          ),
        ],
      ),
      body: _buildBody(context, state, isDark),
    );
  }

  Widget _buildBody(BuildContext context, DiceBattleState state, bool isDark) {
    if (state.status == GameStatus.idle) {
      return _buildLoadingState(isDark);
    }

    if (state.isGameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameOverDialog(state);
      });
    }

    return SafeArea(
      child: Column(
        children: [
          // Health bars
          _buildHealthBars(state, isDark),
          const SizedBox(height: 8),

          // Effect display
          EffectDisplay(
            effect: state.currentEffect,
            isFirstRound: state.isFirstRound,
          ),
          const SizedBox(height: 8),

          // Game phase indicator
          _buildPhaseIndicator(state, isDark),
          const SizedBox(height: 8),

          // Main game area
          Expanded(child: _buildGameArea(state, isDark)),

          // Battle log
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BattleLog(messages: state.battleLog, maxHeight: 100),
          ),
          const SizedBox(height: 8),

          // Action buttons
          if (!state.isGameOver && !state.isAiTurn)
            _buildActionButtons(state, isDark),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: WoodenColors.accentAmber),
          const SizedBox(height: 16),
          Text(
            '准备战斗中...',
            style: TextStyle(
              fontSize: 18,
              color: isDark
                  ? WoodenColors.darkTextSecondary
                  : WoodenColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthBars(DiceBattleState state, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: HealthBar(
              currentHealth: state.players[0].health,
              maxHealth: state.players[0].maxHealth,
              playerName: state.players[0].name,
              isActive: state.currentPlayerIndex == 0,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: HealthBar(
              currentHealth: state.players[1].health,
              maxHealth: state.players[1].maxHealth,
              playerName: state.players[1].name,
              isActive: state.currentPlayerIndex == 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseIndicator(DiceBattleState state, bool isDark) {
    String phaseText;
    IconData phaseIcon;

    switch (state.status) {
      case GameStatus.attacking:
        phaseText = '${state.currentPlayer.name} 进攻中';
        phaseIcon = Icons.sports_mma;
        break;
      case GameStatus.defending:
        phaseText = '${state.currentPlayer.name} 防守中';
        phaseIcon = Icons.shield;
        break;
      case GameStatus.calculating:
        phaseText = '计算伤害中...';
        phaseIcon = Icons.calculate;
        break;
      default:
        phaseText = '第 ${state.roundNumber} 回合';
        phaseIcon = Icons.numbers;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: WoodenColors.accentAmber.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WoodenColors.accentAmber),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(phaseIcon, color: WoodenColors.accentAmber, size: 20),
          const SizedBox(width: 8),
          Text(
            phaseText,
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

  Widget _buildGameArea(DiceBattleState state, bool isDark) {
    if (state.phase == GamePhase.rolling) {
      return _buildRollingState(state, isDark);
    }

    if (state.phase == GamePhase.selectingDice) {
      return _buildSelectingState(state, isDark);
    }

    if (state.phase == GamePhase.rerolling) {
      return _buildRerollState(state, isDark);
    }

    if (state.phase == GamePhase.effectApplying) {
      return _buildCalculatingState(isDark);
    }

    return const Center(child: Text('Waiting...'));
  }

  Widget _buildRollingState(DiceBattleState state, bool isDark) {
    final notifier = ref.read(diceBattleGameProvider.notifier);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '准备投掷骰子',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? WoodenColors.darkTextPrimary
                  : WoodenColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${state.currentPlayer.name} 的回合',
            style: TextStyle(
              fontSize: 18,
              color: isDark
                  ? WoodenColors.darkTextSecondary
                  : WoodenColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 32),
          WoodenButton(
            text: '投掷骰子',
            icon: Icons.casino,
            variant: WoodenButtonVariant.accent,
            size: WoodenButtonSize.large,
            onPressed: () => notifier.rollDice(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectingState(DiceBattleState state, bool isDark) {
    final isAttack = state.status == GameStatus.attacking;
    final maxDice = isAttack
        ? state.currentPlayer.diceSet.maxAttackDice
        : state.currentPlayer.diceSet.maxDefenseDice;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? WoodenColors.darkCard : WoodenColors.lightCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? WoodenColors.darkBorder
                    : WoodenColors.lightBorder,
              ),
            ),
            child: Text(
              isAttack ? '选择进攻骰子 (最多$maxDice个)' : '选择防守骰子 (最多$maxDice个)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? WoodenColors.darkTextPrimary
                    : WoodenColors.lightTextPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: DiceSelector(
              player: state.currentPlayer,
              isAttackPhase: isAttack,
              maxSelectable: maxDice,
              onDiceToggled: (index) {
                ref
                    .read(diceBattleGameProvider.notifier)
                    .toggleDiceSelection(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRerollState(DiceBattleState state, bool isDark) {
    final notifier = ref.read(diceBattleGameProvider.notifier);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '重新投掷阶段',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? WoodenColors.darkTextPrimary
                  : WoodenColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '剩余次数: ${2 - state.rerollCount} / 2',
            style: TextStyle(
              fontSize: 16,
              color: isDark
                  ? WoodenColors.darkTextSecondary
                  : WoodenColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 24),
          if (state.canReroll)
            WoodenButton(
              text: '重新投掷',
              icon: Icons.casino,
              variant: WoodenButtonVariant.accent,
              size: WoodenButtonSize.large,
              onPressed: () => notifier.rerollSelected(),
            ),
          const SizedBox(height: 16),
          WoodenButton(
            text: '完成进攻',
            icon: Icons.check,
            variant: WoodenButtonVariant.primary,
            size: WoodenButtonSize.large,
            onPressed: () => notifier.finishAttack(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '计算伤害中...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? WoodenColors.darkTextPrimary
                  : WoodenColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(color: WoodenColors.accentAmber),
        ],
      ),
    );
  }

  Widget _buildActionButtons(DiceBattleState state, bool isDark) {
    final notifier = ref.read(diceBattleGameProvider.notifier);

    if (state.phase == GamePhase.selectingDice) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: WoodenButton(
          text: '确认选择',
          icon: Icons.check,
          variant: WoodenButtonVariant.primary,
          size: WoodenButtonSize.large,
          expandWidth: true,
          onPressed: state.currentPlayer.selectedDiceCount > 0
              ? () => notifier.confirmDiceSelection()
              : null,
        ),
      );
    }

    if (state.status == GameStatus.defending &&
        state.phase == GamePhase.selectingDice) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: WoodenButton(
          text: '确认防守',
          icon: Icons.shield,
          variant: WoodenButtonVariant.primary,
          size: WoodenButtonSize.large,
          expandWidth: true,
          onPressed: state.currentPlayer.selectedDiceCount > 0
              ? () => notifier.finishDefense()
              : null,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showGameOverDialog(DiceBattleState state) {
    final winner = state.winner;
    if (winner == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 64, color: WoodenColors.accentGold),
            const SizedBox(height: 16),
            Text(
              '${winner.name} Wins!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Rounds: ${state.roundNumber}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(diceBattleGameProvider.notifier).resetGame();
              ref
                  .read(diceBattleGameProvider.notifier)
                  .startGame(
                    aiDifficulty: widget.aiDifficulty,
                    player1Set: widget.player1Set,
                    player2Set: widget.player2Set,
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WoodenColors.accentAmber,
            ),
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _showRestartConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restart Game?'),
        content: const Text('Are you sure you want to restart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(diceBattleGameProvider.notifier).resetGame();
              ref
                  .read(diceBattleGameProvider.notifier)
                  .startGame(
                    aiDifficulty: widget.aiDifficulty,
                    player1Set: widget.player1Set,
                    player2Set: widget.player2Set,
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WoodenColors.accentAmber,
            ),
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
