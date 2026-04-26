import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/generated/app_localizations.dart';

import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/dice_battle_player.dart';
import '../models/dice_set.dart';
import '../models/dice_type.dart';
import '../dice_battle_screen.dart';

enum _SelectionStep {
  modeSelect,
  player1Select,
  player2Select,
}

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

  Widget _buildGameIcon(bool isDark, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.themeCard, context.themeSurface],
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(color: context.themeBorder, width: 2),
        boxShadow: [
          BoxShadow(
            color: context.themeShadow.withAlpha(80),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(child: Text('🎲', style: TextStyle(fontSize: size * 0.5))),
    );
  }

  Widget _buildTitleSection(bool isDark, AppLocalizations l10n, bool isLandscape) {
    return Column(
      crossAxisAlignment: isLandscape ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.game_dice_battle,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.themeTextPrimary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.db_gameDescription,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: TextStyle(fontSize: 14, color: context.themeTextSecondary),
        ),
      ],
    );
  }

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            final padding = isLandscape
                ? const EdgeInsets.symmetric(horizontal: 24, vertical: 8)
                : const EdgeInsets.all(24);

            return Center(
              child: SingleChildScrollView(
                padding: padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGameIcon(isDark, 80),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTitleSection(isDark, l10n, true)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildCurrentStep(context, isDark, l10n, isLandscape),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentStep(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    bool isLandscape,
  ) {
    switch (_currentStep) {
      case _SelectionStep.modeSelect:
        return _buildModeSelection(context, isDark, l10n, isLandscape);
      case _SelectionStep.player1Select:
        return _buildPlayer1Selection(context, isDark, l10n);
      case _SelectionStep.player2Select:
        return _buildPlayer2Selection(context, isDark, l10n);
    }
  }

  Widget _buildModeSelection(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    bool isLandscape,
  ) {
    final buttons = <Widget>[
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
      WoodenButton(
        text: l10n.db_easyAI,
        icon: Icons.computer,
        size: WoodenButtonSize.large,
        variant: WoodenButtonVariant.secondary,
        expandWidth: true,
        onPressed: () {
          setState(() {
            _aiDifficulty = AiDifficulty.easy;
            _currentStep = _SelectionStep.player1Select;
          });
        },
      ),
      WoodenButton(
        text: l10n.db_mediumAI,
        icon: Icons.psychology,
        size: WoodenButtonSize.large,
        variant: WoodenButtonVariant.secondary,
        expandWidth: true,
        onPressed: () {
          setState(() {
            _aiDifficulty = AiDifficulty.medium;
            _currentStep = _SelectionStep.player1Select;
          });
        },
      ),
      WoodenButton(
        text: l10n.db_hardAI,
        icon: Icons.smart_toy,
        size: WoodenButtonSize.large,
        variant: WoodenButtonVariant.accent,
        expandWidth: true,
        onPressed: () {
          setState(() {
            _aiDifficulty = AiDifficulty.hard;
            _currentStep = _SelectionStep.player1Select;
          });
        },
      ),
    ];

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
          if (isLandscape)
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 3.0,
              children: buttons,
            )
          else ...[
            for (int i = 0; i < buttons.length; i++) ...[
              buttons[i],
              if (i < buttons.length - 1) const SizedBox(height: 12),
            ],
          ],
          const SizedBox(height: 24),
          WoodenButton(
            text: l10n.db_gameRules,
            icon: Icons.help_outline,
            variant: WoodenButtonVariant.outlined,
            expandWidth: true,
            onPressed: () => _showRulesDialog(context, isDark, l10n),
          ),
          const SizedBox(height: 16),
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
          if (_aiDifficulty == null) {
            Future.delayed(const Duration(milliseconds: 200), () {
              setState(() => _currentStep = _SelectionStep.player2Select);
            });
          } else {
            final aiSet =
                DiceSets.all[DateTime.now().millisecondsSinceEpoch %
                    DiceSets.all.length];
            _startGame(aiSet);
          }
        } else {
          setState(() => _player2Set = set);
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