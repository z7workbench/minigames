import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';

import '../../../ui/theme/wooden_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/mancala_state.dart';
import '../mancala_screen.dart';

/// Pre-game start screen for Mancala with mode selection and rules.
class MancalaStartScreen extends ConsumerStatefulWidget {
  const MancalaStartScreen({super.key});

  @override
  ConsumerState<MancalaStartScreen> createState() => _MancalaStartScreenState();
}

class _MancalaStartScreenState extends ConsumerState<MancalaStartScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark
          ? WoodenColors.darkBackground
          : WoodenColors.lightBackground,
      appBar: AppBar(
        title: Text(l10n.game_mancala),
        backgroundColor: isDark
            ? WoodenColors.darkPrimary
            : WoodenColors.lightPrimary,
        foregroundColor: isDark
            ? WoodenColors.darkOnPrimary
            : WoodenColors.lightOnPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
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

                // Mode selection
                _buildModeSelection(context, isDark, l10n),
                const SizedBox(height: 24),

                // Rules button
                WoodenButton(
                  text: l10n.mc_howToPlay,
                  icon: Icons.help_outline,
                  variant: WoodenButtonVariant.outlined,
                  expandWidth: true,
                  onPressed: () => _showRulesDialog(context, isDark, l10n),
                ),
                const SizedBox(height: 16),

                // Back button
                WoodenButton(
                  text: l10n.back,
                  icon: Icons.arrow_back,
                  variant: WoodenButtonVariant.ghost,
                  expandWidth: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
        child: const Center(child: Text('🌾', style: TextStyle(fontSize: 50))),
      ),
    );
  }

  Widget _buildTitleSection(bool isDark, AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.game_mancala,
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
          'Mancala',
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
          l10n.mc_gameDescription,
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

  Widget _buildModeSelection(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
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

          // 2 Player mode
          WoodenButton(
            text: l10n.mc_twoPlayers,
            icon: Icons.people,
            size: WoodenButtonSize.large,
            variant: WoodenButtonVariant.primary,
            expandWidth: true,
            onPressed: () => _startGame(null),
          ),
          const SizedBox(height: 12),

          // AI modes
          WoodenButton(
            text: l10n.mc_easyAI,
            icon: Icons.computer,
            size: WoodenButtonSize.medium,
            variant: WoodenButtonVariant.secondary,
            expandWidth: true,
            onPressed: () => _startGame(AiDifficulty.easy),
          ),
          const SizedBox(height: 8),
          WoodenButton(
            text: l10n.mc_mediumAI,
            icon: Icons.psychology,
            size: WoodenButtonSize.medium,
            variant: WoodenButtonVariant.secondary,
            expandWidth: true,
            onPressed: () => _startGame(AiDifficulty.medium),
          ),
          const SizedBox(height: 8),
          WoodenButton(
            text: l10n.mc_hardAI,
            icon: Icons.smart_toy,
            size: WoodenButtonSize.medium,
            variant: WoodenButtonVariant.accent,
            expandWidth: true,
            onPressed: () => _startGame(AiDifficulty.hard),
          ),
        ],
      ),
    );
  }

  void _startGame(AiDifficulty? aiDifficulty) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MancalaScreen(aiDifficulty: aiDifficulty),
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
                    l10n.mc_howToPlay,
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
              _buildRuleItem(
                '1. 播种',
                '从你的一个坑中取出所有种子，按逆时针方向逐个播撒到后面的坑中。',
                isDark,
              ),
              const SizedBox(height: 12),
              _buildRuleItem('2. 跳过对手大坑', '播种时跳过对手的大坑，只播撒到小坑和自己的大坑中。', isDark),
              const SizedBox(height: 12),
              _buildRuleItem('3. 额外回合', '如果最后一粒种子落入你的大坑，你可以再玩一次！', isDark),
              const SizedBox(height: 12),
              _buildRuleItem(
                '4. 捕获',
                '如果最后一粒种子落入你那边的空坑，你可以捕获该粒种子和对面坑中所有的种子！',
                isDark,
              ),
              const SizedBox(height: 12),
              _buildRuleItem(
                '5. 游戏结束',
                '当一方所有小坑都空了，游戏结束。剩余种子归对手所有。种子多者获胜！',
                isDark,
              ),
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
