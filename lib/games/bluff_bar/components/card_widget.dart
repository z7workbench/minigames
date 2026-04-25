import 'package:flutter/material.dart';

import '../../guess_arrangement/models/playing_card.dart';
import '../../../ui/theme/theme_colors.dart';

/// Displays a single playing card with theme-aware styling.
class CardWidget extends StatelessWidget {
  final PlayingCard card;
  final bool isSelected;
  final bool isFaceDown;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final CardRank? targetRank;  // 目标牌rank，用于高亮显示

  const CardWidget({
    super.key,
    required this.card,
    this.isSelected = false,
    this.isFaceDown = false,
    this.width = 60,
    this.height = 90,
    this.onTap,
    this.targetRank,  // 新增参数
  });

  @override
  Widget build(BuildContext context) {
    // 判断是否是有效牌（目标牌或Joker）
    final isTargetCard = targetRank != null && card.rank == targetRank;
    final isValidCard = isTargetCard || card.isJoker;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isFaceDown 
              ? context.themeAccent 
              : (isValidCard ? null : context.themeCard),  // 有效牌用渐变，其他用普通背景
          gradient: isValidCard && !isFaceDown 
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.themeAccent.withAlpha(200),
                    context.themeAccentSecondary.withAlpha(200),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? context.themeSuccess
                : (isValidCard ? context.themeAccent : context.themeBorder),
            width: isSelected ? 3 : (isValidCard ? 2 : 1),
          ),
          boxShadow: [
            BoxShadow(
              color: isValidCard 
                  ? context.themeAccent.withAlpha(100)
                  : context.themeShadow,
              blurRadius: isSelected ? 8 : (isValidCard ? 6 : 4),
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isFaceDown
            ? _buildBack(context)
            : _buildFront(context),
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.themePrimary, context.themeSecondary],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Container(
          width: width * 0.8,
          height: height * 0.8,
          decoration: BoxDecoration(
            border: Border.all(
              color: context.themeOnAccent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Icon(
              Icons.diamond,
              color: context.themeOnAccent,
              size: width * 0.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFront(BuildContext context) {
    // Joker cards show special symbol
    if (card.isJoker) {
      return _buildJokerCard(context);
    }

    // 判断是否是目标牌
    final isTargetCard = targetRank != null && card.rank == targetRank;
    final isValidCard = isTargetCard || card.isJoker;
    
    // 有效牌使用OnAccent颜色，其他使用普通颜色
    final isRed = card.suit.isRed;
    final textColor = isValidCard 
        ? context.themeOnAccent
        : (isRed
            ? (Theme.of(context).brightness == Brightness.dark
                ? Colors.red.shade400
                : Colors.red.shade700)
            : context.themeTextPrimary);

    // Use simpler layout for small cards to prevent overflow
    // Lower threshold to catch more landscape cases
    final isSmallCard = width < 55 || height < 85;

    if (isSmallCard) {
      // Compact layout for small cards - just rank and suit centered
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              card.rank.symbol,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              card.suit.symbol,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top-left rank and suit
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  card.rank.symbol,
                  style: TextStyle(
                    color: textColor,
                    fontSize: width * 0.25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  card.suit.symbol,
                  style: TextStyle(
                    color: textColor,
                    fontSize: width * 0.2,
                  ),
                ),
              ],
            ),
          ),

          // Center suit (large)
          Center(
            child: Text(
              card.suit.symbol,
              style: TextStyle(
                color: textColor,
                fontSize: width * 0.4,
              ),
            ),
          ),

          // Bottom-right rank and suit (inverted)
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.rotate(
              angle: 3.14159, // 180 degrees
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.rank.symbol,
                    style: TextStyle(
                      color: textColor,
                      fontSize: width * 0.25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    card.suit.symbol,
                    style: TextStyle(
                      color: textColor,
                      fontSize: width * 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Joker card display (special card that counts as any rank)
  Widget _buildJokerCard(BuildContext context) {
    final isSmallCard = width < 55 || height < 85;
    
    // Joker background - slightly different from regular cards
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.themeAccent.withAlpha(200),
            context.themeAccentSecondary.withAlpha(200),
          ],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: isSmallCard
            ? Text(
                '🃏',
                style: TextStyle(
                  fontSize: 24,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🃏',
                    style: TextStyle(
                      fontSize: width * 0.35,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Joker',
                    style: TextStyle(
                      color: context.themeOnAccent,
                      fontSize: width * 0.15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
