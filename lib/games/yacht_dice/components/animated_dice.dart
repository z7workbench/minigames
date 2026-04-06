import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/theme/theme_provider.dart';
import '../../../ui/theme/starlight_colors.dart';

/// A reusable animated dice widget with spin animation.
///
/// Shows a spinning animation when rolling, with random values
/// flashing before settling to the final value.
/// Value of 0 indicates the dice has not been rolled yet.
class AnimatedDice extends StatefulWidget {
  /// Current dice value (0-6, where 0 means not rolled)
  final int value;

  /// Whether this die is kept
  final bool isKept;

  /// Whether the rolling animation should play
  final bool isRolling;

  /// Callback when the dice is tapped
  final VoidCallback? onTap;

  /// Duration of the roll animation
  final Duration rollDuration;

  /// Interval for flashing random values during animation
  final Duration flashInterval;

  /// Size of the dice (width and height)
  final double size;

  /// Creates an animated dice widget.
  const AnimatedDice({
    super.key,
    required this.value,
    required this.isKept,
    required this.isRolling,
    this.onTap,
    this.rollDuration = const Duration(milliseconds: 400),
    this.flashInterval = const Duration(milliseconds: 50),
    this.size = 60,
  }) : assert(value >= 0 && value <= 6, 'Dice value must be between 0 and 6');

  @override
  State<AnimatedDice> createState() => _AnimatedDiceState();
}

class _AnimatedDiceState extends State<AnimatedDice>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late final Random _random;

  // Display value shown during animation
  int _displayValue = 1;
  Timer? _flashTimer;
  bool _isAnimating = false;

  static const Map<int, String> _diceEmojis = {
    0: '?', // Not rolled yet
    1: '⚀',
    2: '⚁',
    3: '⚂',
    4: '⚃',
    5: '⚄',
    6: '⚅',
  };

  @override
  void initState() {
    super.initState();
    _random = Random();
    _displayValue = widget.value;

    _controller = AnimationController(
      duration: widget.rollDuration,
      vsync: this,
    );

    // Curved animation for smooth spin
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // Rotation: multiple spins (3 full rotations)
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 6.0 * pi, // 3 full rotations
    ).animate(curvedAnimation);

    // Scale animation for bounce effect
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 0.9), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(curvedAnimation);

    // Listen for animation status
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
    _flashTimer = Timer.periodic(widget.flashInterval, (_) {
      if (mounted && _isAnimating) {
        setState(() {
          _displayValue = _random.nextInt(6) + 1;
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
      // Restart animation if already animating (handles rapid state changes)
      _controller.stop();
      _controller.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(AnimatedDice oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update display value when not animating
    if (!widget.isRolling &&
        !oldWidget.isRolling &&
        widget.value != oldWidget.value) {
      setState(() {
        _displayValue = widget.value;
      });
    }

    // Start animation when isRolling becomes true
    if (widget.isRolling && !oldWidget.isRolling) {
      _startAnimation();
    }

    // Handle animation completion
    if (!widget.isRolling && oldWidget.isRolling) {
      // Animation should complete naturally, but if stopped early, update display
      if (_controller.status == AnimationStatus.dismissed ||
          _controller.status == AnimationStatus.completed) {
        setState(() {
          _isAnimating = false;
          _displayValue = widget.value;
        });
        _stopFlashTimer();
      }
    }
  }

  @override
  void dispose() {
    _stopFlashTimer();
    _controller.removeStatusListener(_onAnimationStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  String _getDiceEmoji(int value) {
    return _diceEmojis[value] ?? '●';
  }

  Color _getAccentColor(BuildContext context, ColorSchemeType scheme) {
    if (scheme == ColorSchemeType.starlight) {
      return StarlightColors.accentStar;
    }
    return context.themeAccent;
  }

  Color _getCardColor(
    BuildContext context,
    bool isDark,
    ColorSchemeType scheme,
  ) {
    if (scheme == ColorSchemeType.starlight) {
      return isDark ? StarlightColors.darkCard : StarlightColors.lightCard;
    }
    return context.themeCard;
  }

  Color _getSecondaryColor(
    BuildContext context,
    bool isDark,
    ColorSchemeType scheme,
  ) {
    if (scheme == ColorSchemeType.starlight) {
      return isDark
          ? StarlightColors.darkSecondary
          : StarlightColors.lightSecondary;
    }
    return context.themeSecondary;
  }

  Color _getShadowColor(
    BuildContext context,
    bool isDark,
    ColorSchemeType scheme,
  ) {
    if (scheme == ColorSchemeType.starlight) {
      return isDark ? StarlightColors.darkShadow : StarlightColors.lightShadow;
    }
    return context.themeShadow;
  }

  ColorSchemeType _getColorSchemeType(Color primaryColor) {
    if (primaryColor == StarlightColors.lightPrimary ||
        primaryColor == StarlightColors.darkPrimary) {
      return ColorSchemeType.starlight;
    }
    return ColorSchemeType.wooden;
  }

  Color _getBackgroundColor(BuildContext context, ColorSchemeType scheme) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.isKept) {
      return _getAccentColor(context, scheme);
    }
    return _getCardColor(context, isDark, scheme);
  }

  Color _getBorderColor(BuildContext context, ColorSchemeType scheme) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.isKept) {
      return _getAccentColor(context, scheme);
    }
    return _getSecondaryColor(context, isDark, scheme);
  }

  Color _getTextColor(bool isDark) {
    if (widget.isKept) {
      return Colors.black;
    }
    return isDark ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final scheme = _getColorSchemeType(Theme.of(context).primaryColor);

    return GestureDetector(
      onTap: widget.onTap,
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
            color: _getBackgroundColor(context, scheme),
            borderRadius: BorderRadius.circular(widget.size * 0.15),
            border: Border.all(
              color: _getBorderColor(context, scheme),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _getShadowColor(context, isDark, scheme).withAlpha(100),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _getDiceEmoji(_displayValue),
              style: TextStyle(
                fontSize: widget.size * 0.55,
                color: _getTextColor(isDark),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
