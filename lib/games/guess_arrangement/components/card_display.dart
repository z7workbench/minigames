import 'package:flutter/material.dart';
import '../models/playing_card.dart';
import '../../../ui/theme/theme_colors.dart';

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
                  color: _getBackgroundColor(context, showFrontNow),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.isSelected
                        ? context.themeAccent
                        : context.themeBorder,
                    width: widget.isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(100),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    if (showFrontNow && widget.card != null)
                      _buildRevealedCard()
                    else if (!showFrontNow)
                      _buildHiddenCard(context),
                    if (widget.showMinIndicator)
                      Positioned(
                        left: 2,
                        top: 0,
                        bottom: 0,
                        child: _buildIndicator(context, 'MIN'),
                      ),
                    if (widget.showMaxIndicator)
                      Positioned(
                        right: 2,
                        top: 0,
                        bottom: 0,
                        child: _buildIndicator(context, 'MAX'),
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

  Color _getBackgroundColor(BuildContext context, bool isFront) {
    if (isFront) {
      return context.themeSurface;
    }
    return context.themePrimary;
  }

  Widget _buildRevealedCard() {
    if (widget.card == null) return const SizedBox();

    final textColor = widget.card!.suit.isRed ? Colors.red : Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: context.themeCard,
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

  Widget _buildHiddenCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.themePrimary,
            context.themeSecondary,
            context.themePrimary,
          ],
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: CustomPaint(
          size: Size(widget.width * 0.6, widget.height * 0.6),
          painter: _CardBackPainterSimple(color: context.themePattern),
        ),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, String text) {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: context.themeAccent.withAlpha(200),
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
