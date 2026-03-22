import 'package:flutter/material.dart';
import '../../../ui/theme/wooden_colors.dart';
import '../models/playing_card.dart';

/// 带翻牌动画的卡牌显示组件
class AnimatedCardDisplay extends StatefulWidget {
  final PlayingCard? card;
  final bool isRevealed;
  final bool isHidden;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showMinIndicator;
  final bool showMaxIndicator;
  final Duration animationDuration;

  const AnimatedCardDisplay({
    super.key,
    this.card,
    this.isRevealed = false,
    this.isHidden = false,
    this.width = 60,
    this.height = 84,
    this.onTap,
    this.isSelected = false,
    this.showMinIndicator = false,
    this.showMaxIndicator = false,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedCardDisplay> createState() => _AnimatedCardDisplayState();
}

class _AnimatedCardDisplayState extends State<AnimatedCardDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _showFront = widget.isRevealed || !widget.isHidden;
  }

  @override
  void didUpdateWidget(AnimatedCardDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 检测从隐藏到显示的变化
    if ((widget.isRevealed && !oldWidget.isRevealed) ||
        (!widget.isHidden && oldWidget.isHidden)) {
      // 触发翻牌动画
      _controller.forward(from: 0).then((_) {
        setState(() {
          _showFront = true;
        });
      });
    } else if (!widget.isRevealed && oldWidget.isRevealed) {
      // 重置
      setState(() {
        _showFront = false;
      });
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final value = _animation.value;
          final isFlipping = value > 0 && value < 1;
          final showFrontNow = _showFront || (value > 0.5 && isFlipping);

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // 透视效果
              ..rotateY(value * 3.14159), // 翻转
            alignment: Alignment.center,
            child: Transform(
              transform: Matrix4.identity()
                ..scale(showFrontNow ? -1.0 : 1.0, 1.0), // 镜像翻转
              alignment: Alignment.center,
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: _getBackgroundColor(isDark, showFrontNow),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.isSelected
                        ? WoodenColors.accentAmber
                        : _getBorderColor(isDark, showFrontNow),
                    width: widget.isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? WoodenColors.darkShadow.withAlpha(100)
                          : WoodenColors.lightShadow.withAlpha(100),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    if (showFrontNow && widget.card != null)
                      _buildRevealedCard(isDark)
                    else if (!showFrontNow)
                      _buildHiddenCard(isDark),
                    if (widget.showMinIndicator)
                      Positioned(
                        left: 2,
                        top: 0,
                        bottom: 0,
                        child: _buildIndicator('MIN', isDark),
                      ),
                    if (widget.showMaxIndicator)
                      Positioned(
                        right: 2,
                        top: 0,
                        bottom: 0,
                        child: _buildIndicator('MAX', isDark),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRevealedCard(bool isDark) {
    if (widget.card == null) return const SizedBox();

    final textColor = widget.card!.suit.isRed ? Colors.red : Colors.black;
    final bgColor = isDark ? WoodenColors.darkSurface : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCorner(widget.card!, textColor),
          Expanded(
            child: Center(
              child: Text(
                widget.card!.suit.symbol,
                style: TextStyle(
                  fontSize: widget.width * 0.4,
                  color: textColor,
                ),
              ),
            ),
          ),
          Transform.rotate(
            angle: 3.14159,
            child: _buildCorner(widget.card!, textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(PlayingCard card, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          card.rank.symbol,
          style: TextStyle(
            fontSize: widget.width * 0.22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          card.suit.symbol,
          style: TextStyle(fontSize: widget.width * 0.18, color: color),
        ),
      ],
    );
  }

  Widget _buildHiddenCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  WoodenColors.darkPrimary,
                  WoodenColors.darkSecondary,
                  WoodenColors.darkPrimary,
                ]
              : [
                  WoodenColors.lightPrimary,
                  WoodenColors.lightSecondary,
                  WoodenColors.lightPrimary,
                ],
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: CustomPaint(
          size: Size(widget.width * 0.6, widget.height * 0.6),
          painter: _CardBackPainter(
            color: isDark
                ? WoodenColors.accentGold.withAlpha(150)
                : Colors.white.withAlpha(180),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(String text, bool isDark) {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: WoodenColors.accentAmber.withAlpha(200),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(bool isDark, bool isFront) {
    if (isFront) {
      return isDark ? WoodenColors.darkSurface : Colors.white;
    }
    return isDark ? WoodenColors.darkPrimary : WoodenColors.lightPrimary;
  }

  Color _getBorderColor(bool isDark, bool isFront) {
    if (isFront) {
      return isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder;
    }
    return isDark ? WoodenColors.darkSecondary : WoodenColors.lightSecondary;
  }
}

class _CardBackPainter extends CustomPainter {
  final Color color;

  _CardBackPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    final step = size.width / 4;

    for (var i = 0; i <= 4; i++) {
      canvas.drawLine(
        Offset(step * i, 0),
        Offset(step * i, size.height),
        paint,
      );
      canvas.drawLine(Offset(0, step * i), Offset(size.width, step * i), paint);
    }

    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 不带动画的简单卡牌显示组件
class CardDisplay extends StatelessWidget {
  final PlayingCard? card;
  final bool isRevealed;
  final bool isHidden;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showMinIndicator;
  final bool showMaxIndicator;

  const CardDisplay({
    super.key,
    this.card,
    this.isRevealed = false,
    this.isHidden = false,
    this.width = 60,
    this.height = 84,
    this.onTap,
    this.isSelected = false,
    this.showMinIndicator = false,
    this.showMaxIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: _getBackgroundColor(isDark, isRevealed || !isHidden),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? WoodenColors.accentAmber
                : _getBorderColor(isDark, isRevealed || !isHidden),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? WoodenColors.darkShadow.withAlpha(100)
                  : WoodenColors.lightShadow.withAlpha(100),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (isRevealed || !isHidden && card != null)
              _buildRevealedCard(isDark)
            else
              _buildHiddenCard(isDark),
            if (showMinIndicator)
              Positioned(
                left: 2,
                top: 0,
                bottom: 0,
                child: _buildIndicator('MIN', isDark),
              ),
            if (showMaxIndicator)
              Positioned(
                right: 2,
                top: 0,
                bottom: 0,
                child: _buildIndicator('MAX', isDark),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevealedCard(bool isDark) {
    if (card == null) return const SizedBox();

    final textColor = card!.suit.isRed ? Colors.red : Colors.black;
    final bgColor = isDark ? WoodenColors.darkSurface : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCorner(card!, textColor),
          Expanded(
            child: Center(
              child: Text(
                card!.suit.symbol,
                style: TextStyle(fontSize: width * 0.4, color: textColor),
              ),
            ),
          ),
          Transform.rotate(
            angle: 3.14159,
            child: _buildCorner(card!, textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(PlayingCard card, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          card.rank.symbol,
          style: TextStyle(
            fontSize: width * 0.22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          card.suit.symbol,
          style: TextStyle(fontSize: width * 0.18, color: color),
        ),
      ],
    );
  }

  Widget _buildHiddenCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  WoodenColors.darkPrimary,
                  WoodenColors.darkSecondary,
                  WoodenColors.darkPrimary,
                ]
              : [
                  WoodenColors.lightPrimary,
                  WoodenColors.lightSecondary,
                  WoodenColors.lightPrimary,
                ],
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: CustomPaint(
          size: Size(width * 0.6, height * 0.6),
          painter: _CardBackPainterSimple(
            color: isDark
                ? WoodenColors.accentGold.withAlpha(150)
                : Colors.white.withAlpha(180),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(String text, bool isDark) {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: WoodenColors.accentAmber.withAlpha(200),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(bool isDark, bool isFront) {
    if (isFront) {
      return isDark ? WoodenColors.darkSurface : Colors.white;
    }
    return isDark ? WoodenColors.darkPrimary : WoodenColors.lightPrimary;
  }

  Color _getBorderColor(bool isDark, bool isFront) {
    if (isFront) {
      return isDark ? WoodenColors.darkBorder : WoodenColors.lightBorder;
    }
    return isDark ? WoodenColors.darkSecondary : WoodenColors.lightSecondary;
  }
}

class _CardBackPainterSimple extends CustomPainter {
  final Color color;

  _CardBackPainterSimple({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    final step = size.width / 4;

    for (var i = 0; i <= 4; i++) {
      canvas.drawLine(
        Offset(step * i, 0),
        Offset(step * i, size.height),
        paint,
      );
      canvas.drawLine(Offset(0, step * i), Offset(size.width, step * i), paint);
    }

    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
