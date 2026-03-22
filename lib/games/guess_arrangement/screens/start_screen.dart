import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ui/theme/wooden_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/guess_arrangement_state.dart';
import '../guess_arrangement_screen.dart';

/// Pre-game start screen for Guess Arrangement with mode selection and rules.
class GuessArrangementStartScreen extends ConsumerStatefulWidget {
  const GuessArrangementStartScreen({super.key});

  @override
  ConsumerState<GuessArrangementStartScreen> createState() =>
      _GuessArrangementStartScreenState();
}

class _GuessArrangementStartScreenState
    extends ConsumerState<GuessArrangementStartScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? WoodenColors.darkBackground
          : WoodenColors.lightBackground,
      appBar: AppBar(
        title: const Text('猜排列'),
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
                _buildTitleSection(isDark),
                const SizedBox(height: 48),

                // Mode selection
                _buildModeSelection(context, isDark),
                const SizedBox(height: 24),

                // Rules button
                WoodenButton(
                  text: '游戏规则',
                  icon: Icons.help_outline,
                  variant: WoodenButtonVariant.outlined,
                  expandWidth: true,
                  onPressed: () => _showRulesDialog(context, isDark),
                ),
                const SizedBox(height: 16),

                // Back button
                WoodenButton(
                  text: '返回',
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
        child: const Center(child: Text('🃏', style: TextStyle(fontSize: 50))),
      ),
    );
  }

  Widget _buildTitleSection(bool isDark) {
    return Column(
      children: [
        Text(
          '猜排列',
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
          'Guess Arrangement',
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
          '猜测对手隐藏的牌面，考验你的推理能力！',
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

          // 2 Player mode
          WoodenButton(
            text: '双人对战',
            icon: Icons.people,
            size: WoodenButtonSize.large,
            variant: WoodenButtonVariant.primary,
            expandWidth: true,
            onPressed: () => _startGame(null),
          ),
          const SizedBox(height: 12),

          // AI modes
          WoodenButton(
            text: '简单AI',
            icon: Icons.computer,
            size: WoodenButtonSize.medium,
            variant: WoodenButtonVariant.secondary,
            expandWidth: true,
            onPressed: () => _startGame(AiDifficulty.easy),
          ),
          const SizedBox(height: 8),
          WoodenButton(
            text: '中等AI',
            icon: Icons.psychology,
            size: WoodenButtonSize.medium,
            variant: WoodenButtonVariant.secondary,
            expandWidth: true,
            onPressed: () => _startGame(AiDifficulty.medium),
          ),
          const SizedBox(height: 8),
          WoodenButton(
            text: '困难AI',
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
        builder: (context) =>
            GuessArrangementScreen(aiDifficulty: aiDifficulty),
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
              _buildRuleItem(
                '1. 发牌',
                '每位玩家从52张牌中抽取8张，按从小到大（A=1最小，K=13最大）面朝下排列。',
                isDark,
              ),
              const SizedBox(height: 12),
              _buildRuleItem(
                '2. 猜测',
                '双方轮流猜对方的牌。例如："第3张是7"。只需猜数字，不用猜花色。',
                isDark,
              ),
              const SizedBox(height: 12),
              _buildRuleItem('3. 猜对', '翻开对方的牌！你可以继续猜测，连击数+1。', isDark),
              const SizedBox(height: 12),
              _buildRuleItem('4. 猜错', '轮到对方猜测。你的连击数重置。', isDark),
              const SizedBox(height: 12),
              _buildRuleItem('5. 胜负', '谁的牌先被全部翻开，谁就输了！', isDark),
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
          style: TextStyle(
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
