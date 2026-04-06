import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_provider.dart';
import '../theme/theme_colors.dart';

/// An animated theme toggle widget with sun/moon icons.
///
/// This widget provides a smooth animated transition between light and dark themes,
/// with sun and moon icons that rotate and fade during the transition.
/// It follows the wooden board game aesthetic with warm accent colors.
class ThemeToggle extends ConsumerWidget {
  /// The size of the toggle button.
  final double size;

  /// Optional custom callback when theme is toggled.
  /// If not provided, uses the default theme toggle from provider.
  final VoidCallback? onToggle;

  const ThemeToggle({super.key, this.size = 56.0, this.onToggle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeNotifierProvider);
    final colorSchemeAsync = ref.watch(colorSchemeNotifierProvider);

    return themeModeAsync.when(
      data: (themeMode) {
        final isDark = _isDarkMode(themeMode, context);
        final colorSchemeType =
            colorSchemeAsync.value ?? ColorSchemeType.wooden;
        return _ThemeToggleInternal(
          isDark: isDark,
          size: size,
          onToggle: onToggle ?? () => _handleToggle(ref, themeMode),
          colorSchemeType: colorSchemeType,
        );
      },
      loading: () => _buildLoadingPlaceholder(),
      error: (e, st) => _buildErrorPlaceholder(),
    );
  }

  bool _isDarkMode(ThemeMode mode, BuildContext context) {
    if (mode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return mode == ThemeMode.dark;
  }

  void _handleToggle(WidgetRef ref, ThemeMode currentMode) {
    ThemeMode newMode;
    switch (currentMode) {
      case ThemeMode.light:
        newMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newMode = ThemeMode.light;
        break;
      case ThemeMode.system:
        // Toggle based on current system brightness
        newMode = ThemeMode.dark;
        break;
    }
    ref.read(themeModeNotifierProvider.notifier).setTheme(newMode);
  }

  Widget _buildLoadingPlaceholder() {
    return SizedBox(
      width: size,
      height: size,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorPlaceholder() {
    return SizedBox(
      width: size,
      height: size,
      child: const Center(child: Icon(Icons.error)),
    );
  }
}

/// Internal animated widget that handles the sun/moon transition.
class _ThemeToggleInternal extends StatefulWidget {
  final bool isDark;
  final double size;
  final VoidCallback onToggle;
  final ColorSchemeType colorSchemeType;

  const _ThemeToggleInternal({
    required this.isDark,
    required this.size,
    required this.onToggle,
    required this.colorSchemeType,
  });

  @override
  State<_ThemeToggleInternal> createState() => _ThemeToggleInternalState();
}

class _ThemeToggleInternalState extends State<_ThemeToggleInternal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _sunOpacityAnimation;
  late Animation<double> _moonOpacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _setupAnimations();

    // Set initial state
    if (widget.isDark) {
      _controller.value = 1.0;
    }
  }

  void _setupAnimations() {
    _rotationAnimation = Tween<double>(begin: 0.0, end: 180.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _sunOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _moonOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.8,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 70,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(_ThemeToggleInternal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark != widget.isDark) {
      if (widget.isDark) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(widget.size / 2),
            shadowColor: context.themeShadow,
            child: InkWell(
              onTap: widget.onToggle,
              borderRadius: BorderRadius.circular(widget.size / 2),
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  gradient: _buildBackgroundGradient(),
                  borderRadius: BorderRadius.circular(widget.size / 2),
                  border: Border.all(color: context.themeBorder, width: 2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Sun icon
                    Opacity(
                      opacity: _sunOpacityAnimation.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value * 3.14159 / 180,
                        child: Icon(
                          Icons.wb_sunny_rounded,
                          color: context.themeAccent,
                          size: widget.size * 0.5,
                        ),
                      ),
                    ),
                    // Moon icon
                    Opacity(
                      opacity: _moonOpacityAnimation.value,
                      child: Transform.rotate(
                        angle: (_rotationAnimation.value - 180) * 3.14159 / 180,
                        child: Icon(
                          Icons.nightlight_round,
                          color: context.themeAccent,
                          size: widget.size * 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  LinearGradient _buildBackgroundGradient() {
    // Use theme-aware colors
    final surfaceColor = context.themeSurface;
    final cardColor = context.themeCard;

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [surfaceColor, cardColor],
    );
  }
}

/// A compact version of the theme toggle for use in app bars or tight spaces.
class ThemeToggleCompact extends ConsumerWidget {
  final double size;

  const ThemeToggleCompact({super.key, this.size = 40.0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeNotifierProvider);

    return themeModeAsync.when(
      data: (themeMode) {
        final isDark = _isDarkMode(themeMode, context);
        return IconButton(
          onPressed: () => _handleToggle(ref, themeMode),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              key: ValueKey<bool>(isDark),
              color: context.themeAccent,
            ),
          ),
          tooltip: isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
        );
      },
      loading: () => SizedBox(width: size, height: size),
      error: (e, st) => IconButton(
        onPressed: null,
        icon: Icon(Icons.error, size: size * 0.6),
      ),
    );
  }

  bool _isDarkMode(ThemeMode mode, BuildContext context) {
    if (mode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return mode == ThemeMode.dark;
  }

  void _handleToggle(WidgetRef ref, ThemeMode currentMode) {
    final newMode = currentMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    ref.read(themeModeNotifierProvider.notifier).setTheme(newMode);
  }
}
