import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../ui/theme/theme_colors.dart';
import '../../ui/widgets/wooden_button.dart';
import '../../ui/widgets/wooden_app_bar.dart';
import 'models/dice_battle_state.dart';
import 'models/dice_battle_player.dart';
import 'models/dice_set.dart';
import 'models/battle_effect.dart';
import 'components/battle_log.dart';
import 'components/dice_selector.dart';
import 'dice_battle_provider.dart';

// Helper functions for keyword parsing (moved from keyword_popup.dart for this screen)
List<InlineSpan> parseKeywords(
  BuildContext context,
  String text,
  AppLocalizations l10n,
  bool isDark,
  TextStyle? baseStyle,
) {
  final spans = <InlineSpan>[];
  final regex = RegExp(r'\*\*(\w+)\*\*');

  int lastEnd = 0;
  for (final match in regex.allMatches(text)) {
    // Add normal text before keyword
    if (match.start > lastEnd) {
      spans.add(
        TextSpan(
          text: text.substring(lastEnd, match.start),
          style: baseStyle ?? TextStyle(color: context.themeTextPrimary),
        ),
      );
    }

    // Add keyword with special styling
    final keywordText = match.group(1)!;

    // If keyword not recognized, just add bold text
    spans.add(
      TextSpan(
        text: keywordText,
        style: (baseStyle ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.bold,
          color: context.themeAccent,
        ),
      ),
    );

    lastEnd = match.end;
  }

  // Add remaining text
  if (lastEnd < text.length) {
    spans.add(
      TextSpan(
        text: text.substring(lastEnd),
        style: baseStyle ?? TextStyle(color: context.themeTextPrimary),
      ),
    );
  }

  return spans;
}

// Extension for BattleEffect localization
extension BattleEffectL10n on BattleEffect {
  String getLocalizedDescription(AppLocalizations l10n) {
    switch (this) {
      case BattleEffect.oddBonus:
        return l10n.db_effectOddBonusDesc;
      case BattleEffect.evenBonus:
        return l10n.db_effectEvenBonusDesc;
      case BattleEffect.comboOnLowDamage:
        return l10n.db_effectComboLowDesc;
      case BattleEffect.diceUpgrade:
        return l10n.db_effectDiceUpgradeDesc;
      case BattleEffect.perfectBlockInstant:
        return l10n.db_effectPerfectInstantDesc;
      case BattleEffect.comboOnHighAttack:
        return l10n.db_effectComboHighDesc;
      case BattleEffect.lifeSyncBonus:
        return l10n.db_effectLifeSyncDesc;
      case BattleEffect.doubleDamage:
        return l10n.db_keywordComboDesc;
      case BattleEffect.diceSwap:
        return l10n.db_keywordComboDesc;
    }
  }
}

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.themeBackground,
      appBar: WoodenAppBar(
        titleText: l10n.game_dice_battle,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _showRestartConfirmation(context, l10n),
          ),
        ],
      ),
      body: _buildBody(context, state, isDark, l10n),
    );
  }

  Widget _buildBody(
    BuildContext context,
    DiceBattleState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    if (state.status == GameStatus.idle) {
      return _buildLoadingState(context, isDark, l10n);
    }

    if (state.isGameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameOverDialog(state, l10n);
      });
    }

    return SafeArea(
      child: Column(
        children: [
          // Player cards (expandable, contains health + info)
          _buildPlayerCards(context, state, isDark, l10n),

          // Game phase indicator
          _buildPhaseIndicator(context, state, isDark, l10n),
          const SizedBox(height: 8),

          // Main game area
          Expanded(
            child: Stack(
              children: [
                _buildGameArea(context, state, isDark, l10n),
                // Damage animation overlay
                if (state.status == GameStatus.damageAnimation)
                  _buildDamageOverlay(context, state, isDark, l10n),
              ],
            ),
          ),

          // Battle log
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BattleLog(messages: state.battleLog, maxHeight: 100),
          ),
          const SizedBox(height: 8),

          // Action buttons
          if (!state.isGameOver && !state.shouldAiAct())
            _buildActionButtons(context, state, isDark, l10n),
        ],
      ),
    );
  }

  Widget _buildLoadingState(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: context.themeAccent),
          const SizedBox(height: 16),
          Text(
            l10n.loading,
            style: TextStyle(fontSize: 18, color: context.themeTextSecondary),
          ),
        ],
      ),
    );
  }

  /// Build expandable player cards with health and info
  Widget _buildPlayerCards(
    BuildContext context,
    DiceBattleState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final effect = state.currentEffect;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        children: [
          // Two player cards side by side
          Row(
            children: [
              Expanded(
                child: _PlayerCard(
                  player: state.players[0],
                  isActive: state.currentPlayerIndex == 0,
                  isDark: isDark,
                  l10n: l10n,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PlayerCard(
                  player: state.players[1],
                  isActive: state.currentPlayerIndex == 1,
                  isDark: isDark,
                  l10n: l10n,
                ),
              ),
            ],
          ),
          // Field effect (from round 2 onwards)
          if (!state.isFirstRound && effect != null) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showEffectDialog(context, effect, l10n, isDark),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [context.themeAccent, context.themeAccentSecondary],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: context.themeAccent.withAlpha(100),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getEffectIcon(effect), color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.db_fieldEffect}: ${_getLocalizedEffectName(effect, l10n)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getLocalizedEffectName(BattleEffect effect, AppLocalizations l10n) {
    switch (effect) {
      case BattleEffect.oddBonus:
        return l10n.db_effectOddBonus;
      case BattleEffect.evenBonus:
        return l10n.db_effectEvenBonus;
      case BattleEffect.comboOnLowDamage:
        return l10n.db_effectComboLow;
      case BattleEffect.diceUpgrade:
        return l10n.db_effectDiceUpgrade;
      case BattleEffect.perfectBlockInstant:
        return l10n.db_effectPerfectInstant;
      case BattleEffect.comboOnHighAttack:
        return l10n.db_effectComboHigh;
      case BattleEffect.lifeSyncBonus:
        return l10n.db_effectLifeSync;
      case BattleEffect.doubleDamage:
        return l10n.db_keywordCombo;
      case BattleEffect.diceSwap:
        return l10n.db_keywordCombo;
    }
  }

  IconData _getEffectIcon(BattleEffect effect) {
    switch (effect) {
      case BattleEffect.oddBonus:
        return Icons.exposure_plus_1;
      case BattleEffect.evenBonus:
        return Icons.shield;
      case BattleEffect.diceUpgrade:
        return Icons.upgrade;
      case BattleEffect.perfectBlockInstant:
        return Icons.shield_moon;
      case BattleEffect.comboOnLowDamage:
      case BattleEffect.comboOnHighAttack:
        return Icons.repeat;
      case BattleEffect.lifeSyncBonus:
        return Icons.favorite;
      case BattleEffect.doubleDamage:
        return Icons.flash_on;
      case BattleEffect.diceSwap:
        return Icons.swap_horiz;
    }
  }

  void _showEffectDialog(
    BuildContext context,
    BattleEffect effect,
    AppLocalizations l10n,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.themeCard,
        title: Row(
          children: [
            Icon(_getEffectIcon(effect), color: context.themeAccent, size: 28),
            const SizedBox(width: 12),
            Text(
              _getLocalizedEffectName(effect, l10n),
              style: TextStyle(
                color: context.themeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            children: parseKeywords(
              context,
              effect.getLocalizedDescription(l10n),
              l10n,
              isDark,
              TextStyle(fontSize: 16, color: context.themeTextPrimary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseIndicator(
    BuildContext context,
    DiceBattleState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    String phaseText;
    IconData phaseIcon;

    // Support all new GameStatus states
    switch (state.status) {
      // Attack phase states
      case GameStatus.attackRolling:
      case GameStatus.attackSelecting:
        phaseText = '${state.currentPlayer.name} ${l10n.db_attacking}';
        phaseIcon = Icons.sports_mma;
        break;
      // Defense phase states
      case GameStatus.defenseRolling:
      case GameStatus.defenseSelecting:
        phaseText = '${state.currentPlayer.name} ${l10n.db_defending}';
        phaseIcon = Icons.shield;
        break;
      // Resolution phase states
      case GameStatus.damageCalculating:
      case GameStatus.damageAnimation:
        phaseText = l10n.db_calculating;
        phaseIcon = Icons.calculate;
        break;
      // Special states
      case GameStatus.coinFlip:
        phaseText = l10n.db_coinFlip;
        phaseIcon = Icons.flip;
        break;
      case GameStatus.gameOver:
        phaseText = l10n.gameOver;
        phaseIcon = Icons.flag;
        break;
      default:
        phaseText = l10n.db_roundNumber(state.roundNumber);
        phaseIcon = Icons.numbers;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.themeAccent.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.themeAccent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(phaseIcon, color: context.themeAccent, size: 20),
          const SizedBox(width: 8),
          Text(
            phaseText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.themeAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea(
    BuildContext context,
    DiceBattleState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    // Support all new game status states
    switch (state.status) {
      case GameStatus.attackRolling:
      case GameStatus.defenseRolling:
        return _buildRollingState(context, state, isDark, l10n);
      case GameStatus.attackSelecting:
        return _buildAttackSelectingState(context, state, isDark, l10n);
      case GameStatus.defenseSelecting:
        return _buildDefenseSelectingState(context, state, isDark, l10n);
      case GameStatus.damageCalculating:
      case GameStatus.damageAnimation:
      case GameStatus.defenseEffectApply:
      case GameStatus.finalEffectApply:
        return _buildCalculatingState(context, isDark, l10n);
      case GameStatus.turnEnd:
        return _buildTurnEndState(context, isDark, l10n);
      case GameStatus.coinFlip:
        return _buildCoinFlipState(context, isDark, l10n);
      default:
        return Center(child: Text(l10n.loading));
    }
  }

  Widget _buildCoinFlipState(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flip, size: 80, color: context.themeAccent),
          const SizedBox(height: 24),
          Text(
            l10n.db_coinFlip,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: context.themeTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRollingState(
    BuildContext context,
    DiceBattleState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final notifier = ref.read(diceBattleGameProvider.notifier);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.db_playerTurn(state.currentPlayer.name),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: context.themeTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.db_rollDice,
            style: TextStyle(fontSize: 18, color: context.themeTextSecondary),
          ),
          const SizedBox(height: 32),
          WoodenButton(
            text: l10n.db_rollDice,
            icon: Icons.casino,
            variant: WoodenButtonVariant.accent,
            size: WoodenButtonSize.large,
            onPressed: () => notifier.rollDice(),
          ),
        ],
      ),
    );
  }

  /// Attack selecting state - shows dice selector with reroll option
  Widget _buildAttackSelectingState(
    BuildContext context,
    DiceBattleState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final maxDice = state.currentPlayer.diceSet.attackPoints;
    final remainingRerolls = 2 - state.rerollsUsed;
    final selectedCount = state.currentPlayer.selectedDiceCount;
    final isOverLimit = selectedCount > maxDice;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Reroll info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: context.themeAccent.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.themeAccent),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, color: context.themeAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.db_rerollsRemaining(remainingRerolls),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.themeAccent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Selection hint with warning if over limit
          Text(
            isOverLimit
                ? '⚠️ 已选择 $selectedCount 个，超过上限 $maxDice 个！'
                : l10n.db_selectAttackDice(maxDice),
            style: TextStyle(
              fontSize: 14,
              color: (isDark
                  ? context.themeTextSecondary
                  : context.themeTextSecondary),
            ),
          ),
          const SizedBox(height: 12),
          // Dice selector - allow unlimited selection for reroll
          Expanded(
            child: DiceSelector(
              player: state.currentPlayer,
              isAttackPhase: true,
              maxSelectable:
                  state.currentPlayer.dice.length, // Allow all dice for reroll
              allowUnlimitedSelection: true,
              validationLimit: maxDice, // Show attack dice limit
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

  /// Defense selecting state - shows attacker's points and dice selector
  Widget _buildDefenseSelectingState(
    BuildContext context,
    DiceBattleState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final maxDice = state.currentPlayer.diceSet.defensePoints;
    final attackValue = state.attacker.attackValue;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Show attacker's points
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withAlpha(100)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sports_mma, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  '进攻方: $attackValue 点',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.db_selectDefenseDice(maxDice),
            style: TextStyle(fontSize: 14, color: context.themeTextSecondary),
          ),
          const SizedBox(height: 12),
          // Dice selector
          Expanded(
            child: DiceSelector(
              player: state.currentPlayer,
              isAttackPhase: false,
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

  Widget _buildCalculatingState(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.db_calculating,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: context.themeTextPrimary,
            ),
          ),
          const SizedBox(height: 24),
          CircularProgressIndicator(color: context.themeAccent),
        ],
      ),
    );
  }

  Widget _buildTurnEndState(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.db_roundEnd,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: context.themeTextPrimary,
            ),
          ),
          const SizedBox(height: 24),
          CircularProgressIndicator(color: context.themeAccent),
        ],
      ),
    );
  }

  /// Damage animation overlay widget
  Widget _buildDamageOverlay(
    BuildContext context,
    DiceBattleState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final damage = state.calculatedDamage;

    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1000),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 1.0 + (value * 0.5),
            child: Opacity(
              opacity: 1.0 - value,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(200),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withAlpha(100),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '-$damage',
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (state.comboDamage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${l10n.db_comboHit(state.comboDamage!)}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    DiceBattleState state,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final notifier = ref.read(diceBattleGameProvider.notifier);

    // Attack selecting phase - show reroll and confirm buttons
    if (state.status == GameStatus.attackSelecting) {
      final maxDice = state.currentPlayer.diceSet.attackPoints;
      final selectedCount = state.currentPlayer.selectedDiceCount;
      final isValidSelection = selectedCount > 0 && selectedCount <= maxDice;
      final canReroll = state.canReroll && selectedCount > 0;

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Reroll button
            Expanded(
              child: WoodenButton(
                text: l10n.db_reroll,
                icon: Icons.casino,
                variant: WoodenButtonVariant.accent,
                size: WoodenButtonSize.large,
                expandWidth: true,
                onPressed: canReroll ? () => notifier.rerollSelected() : null,
              ),
            ),
            const SizedBox(width: 16),
            // Confirm attack button
            Expanded(
              child: WoodenButton(
                text: l10n.db_finishAttack,
                icon: Icons.check,
                variant: WoodenButtonVariant.primary,
                size: WoodenButtonSize.large,
                expandWidth: true,
                onPressed: isValidSelection
                    ? () => notifier.finishAttackPhase()
                    : null,
              ),
            ),
          ],
        ),
      );
    }

    // Defense selecting phase - show confirm button only
    if (state.status == GameStatus.defenseSelecting) {
      final maxDice = state.currentPlayer.diceSet.defensePoints;
      final selectedCount = state.currentPlayer.selectedDiceCount;
      final isValidSelection = selectedCount > 0 && selectedCount <= maxDice;

      return Padding(
        padding: const EdgeInsets.all(16),
        child: WoodenButton(
          text: l10n.confirm,
          icon: Icons.check,
          variant: WoodenButtonVariant.primary,
          size: WoodenButtonSize.large,
          expandWidth: true,
          onPressed: isValidSelection
              ? () => notifier.confirmDefenseSelection()
              : null,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showGameOverDialog(DiceBattleState state, AppLocalizations l10n) {
    final winner = state.winner;
    if (winner == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.gameOver),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 64, color: context.themeAccent),
            const SizedBox(height: 16),
            Text(
              l10n.db_victory(winner.name),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.db_roundNumber(state.roundNumber),
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
            child: Text(l10n.db_exit),
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
              backgroundColor: context.themeAccent,
            ),
            child: Text(l10n.db_playAgain),
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
        content: Text('Are you sure you want to restart the game?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
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
              backgroundColor: context.themeAccent,
            ),
            child: Text(l10n.restart),
          ),
        ],
      ),
    );
  }
}

/// Player card widget - shows health, attack, defense. Tap to see full details.
class _PlayerCard extends StatelessWidget {
  final DiceBattlePlayer player;
  final bool isActive;
  final bool isDark;
  final AppLocalizations l10n;

  const _PlayerCard({
    required this.player,
    required this.isActive,
    required this.isDark,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final diceSet = player.diceSet;
    final healthPercent = player.health / player.maxHealth;

    return GestureDetector(
      onTap: () => _showPlayerDetailsDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    context.themeAccent.withAlpha(50),
                    context.themeAccentSecondary.withAlpha(30),
                  ],
                )
              : null,
          color: isActive ? null : context.themeCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? context.themeAccent : context.themeBorder,
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: context.themeAccent.withAlpha(50),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row: name and player icon
            Row(
              children: [
                // Player icon
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isActive
                        ? context.themeAccent
                        : context.themeSurface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    player.isAi ? Icons.smart_toy : Icons.person,
                    size: 18,
                    color: isActive ? Colors.black : context.themeTextPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                // Name
                Expanded(
                  child: Text(
                    player.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? context.themeAccent
                          : context.themeTextPrimary,
                    ),
                  ),
                ),
                // HP text
                Text(
                  '${player.health}/${player.maxHealth}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: context.themeTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Health bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Container(
                    height: 6,
                    color: context.themeDisabled.withAlpha(100),
                  ),
                  FractionallySizedBox(
                    widthFactor: healthPercent.clamp(0.0, 1.0),
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _getHealthColors(healthPercent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Attack and Defense values
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Attack
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sports_mma, size: 14, color: Colors.red[400]),
                    const SizedBox(width: 4),
                    Text(
                      '${diceSet.attackPoints}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: context.themeTextSecondary,
                      ),
                    ),
                  ],
                ),
                Container(width: 1, height: 12, color: context.themeBorder),
                // Defense
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield, size: 14, color: Colors.blue[400]),
                    const SizedBox(width: 4),
                    Text(
                      '${diceSet.defensePoints}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: context.themeTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPlayerDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          _PlayerDetailsDialog(player: player, isDark: isDark, l10n: l10n),
    );
  }

  List<Color> _getHealthColors(double percent) {
    if (percent > 0.6) {
      return [Colors.green, Colors.lightGreen];
    } else if (percent > 0.3) {
      return [Colors.orange, Colors.amber];
    } else {
      return [Colors.red, Colors.redAccent];
    }
  }
}

/// Dialog showing full player details
class _PlayerDetailsDialog extends StatelessWidget {
  final DiceBattlePlayer player;
  final bool isDark;
  final AppLocalizations l10n;

  const _PlayerDetailsDialog({
    required this.player,
    required this.isDark,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final diceSet = player.diceSet;
    final healthPercent = player.health / player.maxHealth;

    return Dialog(
      backgroundColor: context.themeCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.themeAccent, width: 2),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.themeAccent,
                          context.themeAccentSecondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      player.isAi ? Icons.smart_toy : Icons.person,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: context.themeAccent,
                          ),
                        ),
                        Text(
                          player.isAi ? 'AI' : 'Player',
                          style: TextStyle(
                            fontSize: 12,
                            color: context.themeTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Close button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: context.themeTextSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Health section
              _buildSectionTitle('生命值', Icons.favorite, Colors.red),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          Container(
                            height: 20,
                            color: context.themeDisabled.withAlpha(100),
                          ),
                          FractionallySizedBox(
                            widthFactor: healthPercent.clamp(0.0, 1.0),
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _getHealthColors(healthPercent),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${player.health} / ${player.maxHealth}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.themeAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Attack/Defense section
              _buildSectionTitle('攻防属性', Icons.shield, Colors.blue),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      '进攻点数',
                      '${diceSet.attackPoints}',
                      Icons.sports_mma,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      '防守点数',
                      '${diceSet.defensePoints}',
                      Icons.shield,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dice configuration section
              _buildSectionTitle('骰子配置', Icons.casino, context.themeAccent),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: diceSet.diceTypes.map((type) {
                  final name = type.toString().split('.').last;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.themeAccent.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.themeAccent),
                    ),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: context.themeAccent,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Special effects section
              _buildSectionTitle('特殊效果', Icons.auto_awesome, Colors.purple),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.themeSurface.withAlpha(50),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.themeBorder),
                ),
                child: Text(
                  '无', // 目前组合中没有特殊效果
                  style: TextStyle(
                    fontSize: 14,
                    color: context.themeTextSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              // AI difficulty (if AI)
              if (player.isAi) ...[
                const SizedBox(height: 16),
                _buildSectionTitle(
                  'AI难度',
                  Icons.psychology,
                  context.themeAccent,
                ),
                const SizedBox(height: 8),
                Text(
                  player.aiDifficulty?.name ?? 'N/A',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.themeAccent,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getHealthColors(double percent) {
    if (percent > 0.6) {
      return [Colors.green, Colors.lightGreen];
    } else if (percent > 0.3) {
      return [Colors.orange, Colors.amber];
    } else {
      return [Colors.red, Colors.redAccent];
    }
  }
}
