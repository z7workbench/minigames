import 'dart:math';

import 'package:flutter/material.dart';

import '../models/aim_test_state.dart';

class BubbleWidget extends StatefulWidget {
  final double size;
  final BubbleColor color;
  final VoidCallback onTap;

  const BubbleWidget({
    super.key,
    this.size = 60,
    required this.color,
    required this.onTap,
  });

  @override
  State<BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget>
    with TickerProviderStateMixin {
  late AnimationController _popController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _popController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_popController);

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _popController, curve: Curves.easeIn),
    );

    _popController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _generateParticles();
        _particleController.forward();
      }
    });

    _particleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _particles.clear();
      }
    });
  }

  void _generateParticles() {
    _particles.clear();
    final particleCount = 8;
    for (int i = 0; i < particleCount; i++) {
      final angle = (2 * pi / particleCount) * i + _random.nextDouble() * 0.5;
      final speed = widget.size * 0.3 + _random.nextDouble() * widget.size * 0.3;
      _particles.add(_Particle(
        angle: angle,
        speed: speed,
        size: widget.size * 0.08 + _random.nextDouble() * widget.size * 0.06,
      ));
    }
  }

  @override
  void dispose() {
    _popController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _popController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.onTap();
    });
  }

  (Color, Color) _getBubbleColors() {
    switch (widget.color) {
      case BubbleColor.random:
        // Random should never be passed to BubbleWidget directly
        // The screen picks a specific color before creating the widget
        return (const Color(0xFFFF69B4), const Color(0xFFFFB6C1));
      case BubbleColor.bubbleGumPink:
        return (const Color(0xFFFF69B4), const Color(0xFFFFB6C1));
      case BubbleColor.skyBlue:
        return (const Color(0xFF87CEEB), const Color(0xFFB0E0E6));
      case BubbleColor.mintGreen:
        return (const Color(0xFF98FF98), const Color(0xFFCCFFCC));
      case BubbleColor.lavender:
        return (const Color(0xFFE6E6FA), const Color(0xFFFFFFFF));
      case BubbleColor.peach:
        return (const Color(0xFFFFDAB9), const Color(0xFFFFE5CC));
      case BubbleColor.coral:
        return (const Color(0xFFFF7F50), const Color(0xFFFFB4A0));
      case BubbleColor.turquoise:
        return (const Color(0xFF40E0D0), const Color(0xFFAFEEEE));
      case BubbleColor.lemonYellow:
        return (const Color(0xFFFFFACD), const Color(0xFFFFFF99));
    }
  }

  @override
  Widget build(BuildContext context) {
    final (darkColor, lightColor) = _getBubbleColors();

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([_popController, _particleController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: const Alignment(-0.3, -0.3),
                          radius: 0.8,
                          colors: [
                            lightColor.withAlpha(200),
                            darkColor.withAlpha(180),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: darkColor.withAlpha(100),
                            blurRadius: widget.size * 0.15,
                            offset: Offset(
                              widget.size * 0.1,
                              widget.size * 0.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: widget.size * 0.12,
                      left: widget.size * 0.15,
                      child: Transform.rotate(
                        angle: -0.4,
                        child: Container(
                          width: widget.size * 0.25,
                          height: widget.size * 0.12,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(widget.size),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withAlpha(220),
                                Colors.white.withAlpha(80),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ..._buildParticles(darkColor),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildParticles(Color color) {
    return _particles.map((particle) {
      final progress = _particleController.value;
      final dx = cos(particle.angle) * particle.speed * progress;
      final dy = sin(particle.angle) * particle.speed * progress;
      final opacity = (1 - progress).clamp(0.0, 1.0);
      final scale = (1 - progress * 0.5).clamp(0.0, 1.0);

      return Positioned(
        left: widget.size / 2 + dx - particle.size / 2,
        top: widget.size / 2 + dy - particle.size / 2,
        child: Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: particle.size,
              height: particle.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withAlpha(150),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _Particle {
  final double angle;
  final double speed;
  final double size;

  _Particle({
    required this.angle,
    required this.speed,
    required this.size,
  });
}
