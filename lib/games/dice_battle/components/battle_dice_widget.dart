import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../ui/theme/theme_colors.dart';
import '../models/dice_type.dart';

/// An animated dice widget for dice battle with multi-sided dice support.
class BattleDiceWidget extends StatefulWidget {
  /// Current dice value.
  final int value;

  /// Dice type (determines max value).
  final DiceType type;

  /// Whether this dice is selected.
  final bool isSelected;

  /// Whether the rolling animation should play.
  final bool isRolling;

  /// Whether this dice is selectable.
  final bool isSelectable;

  /// Callback when the dice is tapped.
  final VoidCallback? onTap;

  /// Size of the dice.
  final double size;

  const BattleDiceWidget({
    super.key,
    required this.value,
    required this.type,
    this.isSelected = false,
    this.isRolling = false,
    this.isSelectable = true,
    this.onTap,
    this.size = 60,
  });

  @override
  State<BattleDiceWidget> createState() => _BattleDiceWidgetState();
}

class _BattleDiceWidgetState extends State<BattleDiceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late final Random _random;

  int _displayValue = 1;
  Timer? _flashTimer;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _random = Random();
    _displayValue = widget.value;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 6.0 * pi,
    ).animate(curvedAnimation);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.9), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(curvedAnimation);

    _controller.addStatusListener(_onAnimationStatusChanged);
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _isAnimating = false;
        _displayValue = widget.value;
      });
      _stopFlashTimer();
    }
  }

  void _startFlashTimer() {
    _stopFlashTimer();
    _flashTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (mounted && _isAnimating) {
        setState(() {
          _displayValue = _random.nextInt(widget.type.faces) + 1;
        });
      }
    });
  }

  void _stopFlashTimer() {
    _flashTimer?.cancel();
    _flashTimer = null;
  }

  void _startAnimation() {
    if (!_isAnimating) {
      _isAnimating = true;
      _startFlashTimer();
      _controller.forward(from: 0.0);
    } else {
      _controller.stop();
      _controller.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(BattleDiceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isRolling &&
        !oldWidget.isRolling &&
        widget.value != oldWidget.value) {
      setState(() {
        _displayValue = widget.value;
      });
    }

    if (widget.isRolling && !oldWidget.isRolling) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _stopFlashTimer();
    _controller.removeStatusListener(_onAnimationStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  Color _getBackgroundColor(BuildContext context) {
    if (widget.isSelected) {
      return context.themeAccent;
    }
    return context.themeCard;
  }

  Color _getBorderColor(BuildContext context) {
    if (widget.isSelected) {
      return context.themeAccent;
    }
    if (!widget.isSelectable) {
      return context.themeDisabled;
    }
    return context.themeSecondary;
  }

  Color _getTextColor(BuildContext context) {
    if (widget.isSelected) {
      return Colors.black;
    }
    if (!widget.isSelectable) {
      return context.themeDisabled;
    }
    return Colors.white;
  }

  Color _getShadowColor(BuildContext context) {
    return context.themeShadow.withAlpha(100);
  }

  String _getDiceLabel() {
    return widget.type.displayName;
  }

  @override
  Widget build(BuildContext context) {
    // isDark available but unused in build

    return GestureDetector(
      onTap: widget.isSelectable ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateZ(_rotationAnimation.value)
              ..scale(_scaleAnimation.value),
            child: child,
          );
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _getBackgroundColor(context),
            borderRadius: BorderRadius.circular(widget.size * 0.15),
            border: Border.all(
              color: _getBorderColor(context),
              width: widget.isSelected ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _getShadowColor(context),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_displayValue',
                style: TextStyle(
                  fontSize: widget.size * 0.4,
                  fontWeight: FontWeight.bold,
                  color: _getTextColor(context),
                ),
              ),
              Text(
                _getDiceLabel(),
                style: TextStyle(
                  fontSize: widget.size * 0.18,
                  color: _getTextColor(context).withAlpha(200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
