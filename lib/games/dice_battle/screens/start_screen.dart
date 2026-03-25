import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ui/theme/wooden_colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? WoodenColors.darkBackground
          : WoodenColors.lightBackground,
      appBar: AppBar(
        title: const Text('Dice Battle'),
        backgroundColor: isDark
            ? WoodenColors.darkPrimary
            : WoodenColors.lightPrimary,
        foregroundColor: isDark
            ? WoodenColors.darkOnPrimary
            : WoodenColors.lightOnPrimary,
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
                _buildTitleSection(isDark),
                const SizedBox(height: 48),

                // Current step content
                _buildCurrentStep(context, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context, bool isDark) {
    switch (_currentStep) {
      case _SelectionStep.modeSelect:
        return _buildModeSelection(context, isDark);
      case _SelectionStep.player1Select:
        return _buildPlayer1Selection(context, isDark);
      case _SelectionStep.player2Select:
        return _buildPlayer2Selection(context, isDark);
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
            colors: isDark
                ? [WoodenColors.darkCard, WoodenColors.darkSurface]
                : [WoodenColors.lightCard, WoodenColors.lightSurface],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? WoodenColors.darkShadow
                  : WoodenColors.lightShadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(child: Text('🎲', style: TextStyle(fontSize: 50))),
      ),
    );
  }

  Widget _buildTitleSection(bool isDark) {
    return Column(
      children: [
        Text(
          '骰子对战',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark
                ? WoodenColors.darkTextPrimary
                : WoodenColors.lightTextPrimary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Dice Battle',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: isDark
                ? WoodenColors.darkTextSecondary
                : WoodenColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '投掷骰子，制定策略，击败对手！',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: isDark
                ? WoodenColors.darkTextSecondary
                : WoodenColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  /// 模式选择步骤
  Widget _buildModeSelection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? WoodenColors.darkSurface : WoodenColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? WoodenColors.darkShadow : WoodenColors.lightShadow)
                .withAlpha(128),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '选择游戏模式',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? WoodenColors.darkTextPrimary
                  : WoodenColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // 双人对战模式
          WoodenButton(
            text: '双人对战',
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
            text: '简单AI',
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
            text: '中等AI',
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
            text: '困难AI',
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
            text: '游戏规则',
            icon: Icons.help_outline,
            variant: WoodenButtonVariant.outlined,
            expandWidth: true,
            onPressed: () => _showRulesDialog(context, isDark),
          ),
          const SizedBox(height: 16),

          // 返回按钮
          WoodenButton(
            text: '返回',
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
  Widget _buildPlayer1Selection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? WoodenColors.darkSurface : WoodenColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '玩家1选择组合',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? WoodenColors.darkTextPrimary
                  : WoodenColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ...DiceSets.all.map((set) => _buildDiceSetCard(set, isDark, true)),
          const SizedBox(height: 16),
          WoodenButton(
            text: '返回',
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
  Widget _buildPlayer2Selection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? WoodenColors.darkSurface : WoodenColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '玩家2选择组合',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? WoodenColors.darkTextPrimary
                  : WoodenColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '玩家1已选择: ${_player1Set?.name ?? ""}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? WoodenColors.darkTextSecondary
                  : WoodenColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ...DiceSets.all.map((set) => _buildDiceSetCard(set, isDark, false)),
          const SizedBox(height: 16),
          WoodenButton(
            text: '返回',
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

  Widget _buildDiceSetCard(DiceSet set, bool isDark, bool isPlayer1) {
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
              ? WoodenColors.accentAmber.withAlpha(30)
              : (isDark ? WoodenColors.darkCard : WoodenColors.lightCard),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? WoodenColors.accentAmber
                : (isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder),
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
                    set.name,
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
                    '进攻: ${set.attackPoints} | 防守: ${set.defensePoints}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? WoodenColors.darkTextSecondary
                          : WoodenColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    set.diceTypes.map((t) => t.displayName).join(', '),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? WoodenColors.darkTextSecondary
                          : WoodenColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: WoodenColors.accentAmber),
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

  void _showRulesDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDark ? WoodenColors.darkSurface : Colors.white,
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
                    '游戏规则',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? WoodenColors.darkTextPrimary
                          : WoodenColors.lightTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRuleItem('1. 游戏目标', '将对手的生命值降为0即可获胜！', isDark),
              const SizedBox(height: 12),
              _buildRuleItem(
                '2. 骰子组合',
                '选择不同的组合，每种组合有特定的进攻/防守点数和骰子配置。',
                isDark,
              ),
              const SizedBox(height: 12),
              _buildRuleItem(
                '3. 进攻阶段',
                '投掷所有骰子，选择不超过进攻点数的骰子作为进攻筹码。可以重新投掷2次！',
                isDark,
              ),
              const SizedBox(height: 12),
              _buildRuleItem(
                '4. 防守阶段',
                '投掷所有骰子，选择不超过防守点数的骰子作为防守筹码。不能重新投掷！',
                isDark,
              ),
              const SizedBox(height: 12),
              _buildRuleItem(
                '5. 伤害计算',
                '进攻点数 - 防守点数 = 造成的伤害。效果可能会改变这个数值！',
                isDark,
              ),
              const SizedBox(height: 12),
              _buildRuleItem('6. 战斗效果', '每2个回合会随机激活一个效果，请仔细阅读效果说明！', isDark),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WoodenColors.accentAmber,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('明白了！'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleItem(String title, String description, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: WoodenColors.accentAmber,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 13,
            color: isDark
                ? WoodenColors.darkTextSecondary
                : WoodenColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
