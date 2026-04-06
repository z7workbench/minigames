import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/generated/app_localizations.dart';

import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/dice_battle_player.dart';
import '../models/dice_set.dart';
import '../models/dice_type.dart';
import '../dice_battle_screen.dart';

/// 选择步骤枚举
enum _SelectionStep {
  modeSelect, // 选择游戏模式
  player1Select, // 玩家1选择组合
  player2Select, // 玩家2选择组合（仅双人对战）
}

/// Pre-game start screen for Dice Battle with mode selection and dice set selection.
class DiceBattleStartScreen extends ConsumerStatefulWidget {
  const DiceBattleStartScreen({super.key});

  @override
  ConsumerState<DiceBattleStartScreen> createState() =>
      _DiceBattleStartScreenState();
}

class _DiceBattleStartScreenState extends ConsumerState<DiceBattleStartScreen> {
  _SelectionStep _currentStep = _SelectionStep.modeSelect;
  AiDifficulty? _aiDifficulty;
  DiceSet? _player1Set;
  DiceSet? _player2Set;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.themeBackground,
      appBar: AppBar(
        title: Text(l10n.game_dice_battle),
        backgroundColor: context.themePrimary,
        foregroundColor: context.themeOnPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep == _SelectionStep.player2Select) {
              setState(() => _currentStep = _SelectionStep.player1Select);
            } else if (_currentStep == _SelectionStep.player1Select) {
              setState(() => _currentStep = _SelectionStep.modeSelect);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Game icon
                _buildGameIcon(isDark),
                const SizedBox(height: 32),

                // Game title and description
                _buildTitleSection(isDark, l10n),
                const SizedBox(height: 48),

                // Current step content
                _buildCurrentStep(context, isDark, l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    switch (_currentStep) {
      case _SelectionStep.modeSelect:
        return _buildModeSelection(context, isDark, l10n);
      case _SelectionStep.player1Select:
        return _buildPlayer1Selection(context, isDark, l10n);
      case _SelectionStep.player2Select:
        return _buildPlayer2Selection(context, isDark, l10n);
    }
  }

  Widget _buildGameIcon(bool isDark) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [context.themeCard, context.themeSurface],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.themeBorder, width: 2),
          boxShadow: [
            BoxShadow(
              color: context.themeShadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(child: Text('🎲', style: TextStyle(fontSize: 50))),
      ),
    );
  }

  Widget _buildTitleSection(bool isDark, AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.game_dice_battle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: context.themeTextPrimary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.db_gameDescription,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: context.themeTextSecondary),
        ),
      ],
    );
  }

  /// 模式选择步骤
  Widget _buildModeSelection(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.themeBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: context.themeShadow.withAlpha(128),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.yd_selectPlayers,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.themeTextPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // 双人对战模式
          WoodenButton(
            text: l10n.db_twoPlayers,
            icon: Icons.people,
            size: WoodenButtonSize.large,
            variant: WoodenButtonVariant.primary,
            expandWidth: true,
            onPressed: () {
              setState(() {
                _aiDifficulty = null;
                _currentStep = _SelectionStep.player1Select;
              });
            },
          ),
          const SizedBox(height: 12),

          // AI模式
          WoodenButton(
            text: l10n.db_easyAI,
            icon: Icons.computer,
            size: WoodenButtonSize.medium,
            variant: WoodenButtonVariant.secondary,
            expandWidth: true,
            onPressed: () {
              setState(() {
                _aiDifficulty = AiDifficulty.easy;
                _currentStep = _SelectionStep.player1Select;
              });
            },
          ),
          const SizedBox(height: 8),
          WoodenButton(
            text: l10n.db_mediumAI,
            icon: Icons.psychology,
            size: WoodenButtonSize.medium,
            variant: WoodenButtonVariant.secondary,
            expandWidth: true,
            onPressed: () {
              setState(() {
                _aiDifficulty = AiDifficulty.medium;
                _currentStep = _SelectionStep.player1Select;
              });
            },
          ),
          const SizedBox(height: 8),
          WoodenButton(
            text: l10n.db_hardAI,
            icon: Icons.smart_toy,
            size: WoodenButtonSize.medium,
            variant: WoodenButtonVariant.accent,
            expandWidth: true,
            onPressed: () {
              setState(() {
                _aiDifficulty = AiDifficulty.hard;
                _currentStep = _SelectionStep.player1Select;
              });
            },
          ),
          const SizedBox(height: 24),

          // 规则按钮
          WoodenButton(
            text: l10n.db_gameRules,
            icon: Icons.help_outline,
            variant: WoodenButtonVariant.outlined,
            expandWidth: true,
            onPressed: () => _showRulesDialog(context, isDark, l10n),
          ),
          const SizedBox(height: 16),

          // 返回按钮
          WoodenButton(
            text: l10n.back,
            icon: Icons.arrow_back,
            variant: WoodenButtonVariant.ghost,
            expandWidth: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// 玩家1选择组合
  Widget _buildPlayer1Selection(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.themeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.db_player1Select,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.themeTextPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ...DiceSets.all.map(
            (set) => _buildDiceSetCard(context, set, isDark, true, l10n),
          ),
          const SizedBox(height: 16),
          WoodenButton(
            text: l10n.back,
            icon: Icons.arrow_back,
            variant: WoodenButtonVariant.ghost,
            expandWidth: true,
            onPressed: () {
              setState(() => _currentStep = _SelectionStep.modeSelect);
            },
          ),
        ],
      ),
    );
  }

  /// 玩家2选择组合（仅双人对战）
  Widget _buildPlayer2Selection(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.themeSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.themeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.db_player2Select,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.themeTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.db_player1Select}: ${_getLocalizedName(_player1Set?.id ?? '', l10n)}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: context.themeTextSecondary),
          ),
          const SizedBox(height: 24),
          ...DiceSets.all.map(
            (set) => _buildDiceSetCard(context, set, isDark, false, l10n),
          ),
          const SizedBox(height: 16),
          WoodenButton(
            text: l10n.back,
            icon: Icons.arrow_back,
            variant: WoodenButtonVariant.ghost,
            expandWidth: true,
            onPressed: () {
              setState(() => _currentStep = _SelectionStep.player1Select);
            },
          ),
        ],
      ),
    );
  }

  String _getLocalizedName(String setId, AppLocalizations l10n) {
    switch (setId) {
      case 'set1':
        return l10n.db_set1Name;
      case 'set2':
        return l10n.db_set2Name;
      case 'set3':
        return l10n.db_set3Name;
      case 'set4':
        return l10n.db_set4Name;
      case 'set5':
        return l10n.db_set5Name;
      default:
        return '';
    }
  }

  Widget _buildDiceSetCard(
    BuildContext context,
    DiceSet set,
    bool isDark,
    bool isPlayer1,
    AppLocalizations l10n,
  ) {
    final isSelected = isPlayer1
        ? _player1Set?.id == set.id
        : _player2Set?.id == set.id;

    return GestureDetector(
      onTap: () {
        if (isPlayer1) {
          setState(() => _player1Set = set);
          // 如果是双人对战，进入玩家2选择；如果是AI对战，直接开始
          if (_aiDifficulty == null) {
            Future.delayed(const Duration(milliseconds: 200), () {
              setState(() => _currentStep = _SelectionStep.player2Select);
            });
          } else {
            // AI模式：AI随机选择一个组合
            final aiSet =
                DiceSets.all[DateTime.now().millisecondsSinceEpoch %
                    DiceSets.all.length];
            _startGame(aiSet);
          }
        } else {
          setState(() => _player2Set = set);
          // 玩家2选择后，延迟开始游戏
          Future.delayed(const Duration(milliseconds: 200), () {
            _startGame(null);
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? context.themeAccent.withAlpha(30)
              : context.themeCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? context.themeAccent : context.themeBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getLocalizedName(set.id, l10n),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: context.themeTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.db_attackPoints}: ${set.attackPoints} | ${l10n.db_defensePoints}: ${set.defensePoints}',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.themeTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${l10n.db_diceConfig}: ${set.diceTypes.map((t) => t.displayName).join(', ')}',
                    style: TextStyle(
                      fontSize: 11,
                      color: context.themeTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: context.themeAccent),
          ],
        ),
      ),
    );
  }

  void _startGame(DiceSet? aiSet) {
    final p1Set = _player1Set!;
    final p2Set = _aiDifficulty != null ? aiSet! : _player2Set!;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DiceBattleScreen(
          aiDifficulty: _aiDifficulty,
          player1Set: p1Set,
          player2Set: p2Set,
        ),
      ),
    );
  }

  void _showRulesDialog(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
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
                    l10n.db_gameRules,
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
              _buildRuleItem(
                context,
                '1. ${l10n.db_gameRules}',
                l10n.db_gameDescription,
                isDark,
              ),
              const SizedBox(height: 12),
              _buildRuleItem(
                context,
                '2. ${l10n.db_selectDiceSet}',
                '${l10n.db_attackPoints}: ${l10n.db_defensePoints}',
                isDark,
              ),
              const SizedBox(height: 12),
              _buildRuleItem(
                context,
                '3. ${l10n.db_attacking}',
                '${l10n.db_rollDice} (2 ${l10n.db_reroll})',
                isDark,
              ),
              const SizedBox(height: 12),
              _buildRuleItem(
                context,
                '4. ${l10n.db_defending}',
                l10n.db_finishDefense,
                isDark,
              ),
              const SizedBox(height: 12),
              _buildRuleItem(
                context,
                '5. ${l10n.db_damageDealt}',
                '${l10n.db_attack} - ${l10n.db_defense} = ${l10n.db_damageDealt}',
                isDark,
              ),
              const SizedBox(height: 12),
              _buildRuleItem(
                context,
                '6. ${l10n.db_fieldEffect}',
                l10n.db_noActiveEffect,
                isDark,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.themeAccent,
                    foregroundColor: Colors.white,
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

  Widget _buildRuleItem(
    BuildContext context,
    String title,
    String description,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: context.themeAccent,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 13, color: context.themeTextSecondary),
        ),
      ],
    );
  }
}
