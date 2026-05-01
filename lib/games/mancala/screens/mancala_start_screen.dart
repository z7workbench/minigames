import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/widgets/wooden_button.dart';
import '../models/mancala_state.dart';
import '../mancala_screen.dart';

class MancalaStartScreen extends ConsumerStatefulWidget {
  const MancalaStartScreen({super.key});

  @override
  ConsumerState<MancalaStartScreen> createState() => _MancalaStartScreenState();
}

class _MancalaStartScreenState extends ConsumerState<MancalaStartScreen> {
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
      child: Center(child: Text('🌾', style: TextStyle(fontSize: size * 0.5))),
    );
  }

  Widget _buildTitleSection(AppLocalizations l10n, bool isLandscape) {
    return Column(
      crossAxisAlignment: isLandscape ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.game_mancala,
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
          l10n.createdByGlm,
          textAlign: isLandscape ? TextAlign.start : TextAlign.center,
          style: TextStyle(fontSize: 12, color: context.themeAccent),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.mc_gameDescription,
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
        title: Text(l10n.game_mancala),
        backgroundColor: context.themePrimary,
        foregroundColor: context.themeOnPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
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
                        Expanded(child: _buildTitleSection(l10n, true)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildModeSelection(context, l10n, true),
                    const SizedBox(height: 24),
                    WoodenButton(
                      text: l10n.mc_howToPlay,
                      icon: Icons.help_outline,
                      variant: WoodenButtonVariant.outlined,
                      expandWidth: true,
                      onPressed: () => _showRulesDialog(context, l10n),
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
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModeSelection(BuildContext context, AppLocalizations l10n, bool isLandscape) {
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
            '选择游戏模式',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.themeTextPrimary,
            ),
          ),
          const SizedBox(height: 24),
          WoodenButton(
            text: l10n.mc_twoPlayers,
            icon: Icons.people,
            size: WoodenButtonSize.large,
            variant: WoodenButtonVariant.primary,
            expandWidth: true,
            onPressed: () => _startGame(null),
          ),
          const SizedBox(height: 12),
          WoodenButton(
            text: l10n.mc_easyAI,
            icon: Icons.computer,
            size: WoodenButtonSize.large,
            variant: WoodenButtonVariant.secondary,
            expandWidth: true,
            onPressed: () => _startGame(AiDifficulty.easy),
          ),
          const SizedBox(height: 8),
          WoodenButton(
            text: l10n.mc_mediumAI,
            icon: Icons.psychology,
            size: WoodenButtonSize.large,
            variant: WoodenButtonVariant.secondary,
            expandWidth: true,
            onPressed: () => _startGame(AiDifficulty.medium),
          ),
          const SizedBox(height: 8),
          WoodenButton(
            text: l10n.mc_hardAI,
            icon: Icons.smart_toy,
            size: WoodenButtonSize.large,
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

  void _showRulesDialog(BuildContext context, AppLocalizations l10n) {
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
                    l10n.mc_howToPlay,
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
                '1. 播种',
                '从你的一个坑中取出所有种子，按逆时针方向逐个播撒到后面的坑中。',
                context,
              ),
              const SizedBox(height: 12),
              _buildRuleItem('2. 跳过对手大坑', '播种时跳过对手的大坑，只播撒到小坑和自己的大坑中。', context),
              const SizedBox(height: 12),
              _buildRuleItem('3. 额外回合', '如果最后一粒种子落入你的大坑，你可以再玩一次！', context),
              const SizedBox(height: 12),
              _buildRuleItem(
                '4. 捕获',
                '如果最后一粒种子落入你那边的空坑，你可以捕获该粒种子和对面坑中所有的种子！',
                context,
              ),
              const SizedBox(height: 12),
              _buildRuleItem(
                '5. 游戏结束',
                '当一方所有小坑都空了，游戏结束。剩余种子归对手所有。种子多者获胜！',
                context,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.themeAccent,
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

  Widget _buildRuleItem(
    String title,
    String description,
    BuildContext context,
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