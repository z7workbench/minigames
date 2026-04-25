import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../l10n/generated/app_localizations.dart';
import '../../../ui/theme/theme_colors.dart';

/// Russian roulette animation widget for Bluff Bar.
/// Displays a chamber with 6 slots and animated drawing.
class RouletteWidget extends StatefulWidget {
  final int remainingCards;
  final bool isDrawing;
  final bool showResult;
  final bool survived;
  final VoidCallback? onDraw;
  final AppLocalizations l10n;

  const RouletteWidget({
    super.key,
    required this.remainingCards,
    required this.l10n,
    this.isDrawing = false,
    this.showResult = false,
    this.survived = false,
    this.onDraw,
  });

  @override
  State<RouletteWidget> createState() => _RouletteWidgetState();
}

class _RouletteWidgetState extends State<RouletteWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 6.28318, // 360 degrees
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(RouletteWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isDrawing && !oldWidget.isDrawing) {
      _controller.forward(from: 0);
    }

    if (!widget.isDrawing && oldWidget.isDrawing) {
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
    final size = MediaQuery.of(context).size;
    final chamberSize = size.shortestSide < 400 ? 150.0 : 200.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Roulette chamber visualization
        Container(
          width: chamberSize,
          height: chamberSize,
          decoration: BoxDecoration(
            color: context.themeSurface.withAlpha(50),
            shape: BoxShape.circle,
            border: Border.all(
              color: context.themeBorder,
              width: 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Chamber chambers (6 slots in circle)
              ...List.generate(6, (index) {
                final angle = (index * 60 - 90) * (math.pi / 180);
                final radius = chamberSize * 0.3;

                return Positioned(
                  left: chamberSize / 2 + radius * math.cos(angle) - 15,
                  top: chamberSize / 2 + radius * math.sin(angle) - 15,
                  child: Transform.rotate(
                    angle: angle + math.pi / 2,
                    child: Container(
                      width: 30,
                      height: 40,
                      decoration: BoxDecoration(
                        color: index == 0
                            ? context.themeWarning.withAlpha(200)
                            : context.themeCard,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: context.themeBorder,
                          width: 1,
                        ),
                      ),
                      child: index == 0
                          ? Icon(
                              Icons.bolt,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                );
              }),

              // Rotating indicator
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: widget.isDrawing ? _rotationAnimation.value : 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: context.themeAccent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.themeOnAccent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Center decoration - remaining cards count
              Container(
                width: chamberSize * 0.3,
                height: chamberSize * 0.3,
                decoration: BoxDecoration(
                  color: context.themePrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.themeBorder, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${widget.remainingCards}',
                    style: TextStyle(
                      color: context.themeOnPrimary,
                      fontSize: chamberSize * 0.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Result display
        if (widget.showResult) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: widget.survived
                  ? context.themeSuccess.withAlpha(200)
                  : context.themeError.withAlpha(200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.survived ? Icons.check_circle : Icons.dangerous,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.survived ? widget.l10n.bb_survived : widget.l10n.bb_eliminated,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],

        // Draw button
        if (widget.onDraw != null && !widget.isDrawing && !widget.showResult) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: widget.onDraw,
            icon: const Icon(Icons.touch_app),
            label: Text(widget.l10n.bb_draw_card),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.themeAccent,
              foregroundColor: context.themeOnAccent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],

        // Status text
        const SizedBox(height: 8),
        Text(
          widget.isDrawing
              ? widget.l10n.bb_drawing
              : widget.l10n.bb_cards_remaining(widget.remainingCards),
          style: TextStyle(
            color: context.themeTextSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}