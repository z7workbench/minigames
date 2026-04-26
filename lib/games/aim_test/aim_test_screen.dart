import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../ui/theme/theme_colors.dart';
import '../../ui/widgets/wooden_button.dart';
import 'aim_test_provider.dart';
import 'models/aim_test_state.dart';
import 'components/bubble_widget.dart';

class AimTestScreen extends ConsumerStatefulWidget {
  const AimTestScreen({super.key});

  @override
  ConsumerState<AimTestScreen> createState() => _AimTestScreenState();
}

class _AimTestScreenState extends ConsumerState<AimTestScreen>
    with TickerProviderStateMixin {
  late AnimationController _bubbleAppearController;
  late Animation<double> _bubbleAppearAnimation;
  late AnimationController _countdownController;
  late Animation<double> _countdownScale;
  late Animation<double> _countdownFade;
  int _lastCountdownValue = 3;

  @override
  void initState() {
    super.initState();
    _bubbleAppearController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bubbleAppearAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bubbleAppearController, curve: Curves.easeOut),
    );

    _countdownController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _countdownScale = Tween<double>(begin: 1.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _countdownController,
        curve: Curves.elasticOut,
      ),
    );
    _countdownFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _countdownController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _bubbleAppearController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  void _triggerBubbleAppear() {
    _bubbleAppearController.forward(from: 0.0);
  }

  void _triggerCountdownAnimation() {
    _countdownController.forward(from: 0.0);
  }

  void _showResultsDialog(AimTestState state) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: themeColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: themeColors.border, width: 2),
        ),
        title: Text(
          l10n.at_gameOver,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: themeColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              state.score >= state.bubblesSpawned * 0.8
                  ? Icons.emoji_events
                  : Icons.touch_app,
              size: 60,
              color: themeColors.accent,
            ),
            const SizedBox(height: 20),
            _ResultRow(
              label: l10n.score,
              value: '${state.score}',
              themeColors: themeColors,
            ),
            const SizedBox(height: 12),
            _ResultRow(
              label: l10n.at_accuracy,
              value: '${(state.accuracy * 100).toStringAsFixed(1)}%',
              themeColors: themeColors,
            ),
            const SizedBox(height: 12),
            _ResultRow(
              label: l10n.at_bubblesSpawned,
              value: '${state.bubblesSpawned}',
              themeColors: themeColors,
            ),
            if (state.bestScore > 0) ...[
              const SizedBox(height: 12),
              _ResultRow(
                label: l10n.highScore,
                value: '${state.bestScore}',
                themeColors: themeColors,
              ),
            ],
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: WoodenButton(
                  text: l10n.at_playAgain,
                  icon: Icons.replay,
                  size: WoodenButtonSize.medium,
                  variant: WoodenButtonVariant.secondary,
                  onPressed: () {
                    Navigator.of(context).pop();
                    ref.read(aimTestGameProvider.notifier).startGame();
                    _triggerBubbleAppear();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WoodenButton(
                  text: l10n.quit,
                  icon: Icons.exit_to_app,
                  size: WoodenButtonSize.medium,
                  variant: WoodenButtonVariant.ghost,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aimTestGameProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);
    final size = MediaQuery.of(context).size;
    final deadZone = state.bubbleConfig.deadZonePercentage;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final gameAreaTop = safeAreaTop;
    final gameAreaHeight = size.height - safeAreaTop - safeAreaBottom;

    // Trigger countdown animation on value change
    if (state.status == AimTestStatus.countdown &&
        state.countdownValue != _lastCountdownValue) {
      _lastCountdownValue = state.countdownValue;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerCountdownAnimation();
      });
    }

    ref.listen(aimTestGameProvider, (prev, next) {
      // Trigger bubble appear animation when:
      // 1. Status transitions to playing with a bubble already spawned
      // 2. A new bubble spawns while already playing (prev had no bubble, next has bubble)
      final shouldAnimateBubble = 
          (prev?.status != AimTestStatus.playing &&
              next.status == AimTestStatus.playing &&
              next.hasActiveBubble) ||
          (prev?.status == AimTestStatus.playing &&
              !prev!.hasActiveBubble &&
              next.hasActiveBubble);
      
      if (shouldAnimateBubble) {
        _triggerBubbleAppear();
      }
      if (prev?.status == AimTestStatus.playing &&
          next.status == AimTestStatus.completed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showResultsDialog(next);
        });
      }
    });

    final activeLeft = size.width * deadZone;
    final activeRight = size.width * (1 - deadZone);
    final activeTop = gameAreaTop + gameAreaHeight * deadZone;
    final activeBottom = gameAreaTop + gameAreaHeight * (1 - deadZone);

    return Scaffold(
      backgroundColor: themeColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: themeColors.background),
            _buildActiveAreaBorder(
              size,
              deadZone,
              gameAreaTop,
              gameAreaHeight,
              activeTop,
              activeBottom,
              themeColors,
            ),
            // Miss detection layer - below bubble, above decorations
            if (state.status == AimTestStatus.playing)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    ref.read(aimTestGameProvider.notifier).onMiss();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(color: Colors.transparent),
                ),
              ),
            if (state.status == AimTestStatus.playing && state.hasActiveBubble)
              _buildBubble(
                state,
                activeLeft,
                activeTop,
                activeRight,
                activeBottom,
              ),
            // OSD - ignore pointer so clicks pass through to miss detector
            IgnorePointer(
              child: _buildOSD(state, themeColors, size, safeAreaTop, safeAreaBottom),
            ),
            _buildCloseButton(themeColors),
            if (state.status == AimTestStatus.countdown)
              _buildCountdownOverlay(state, themeColors),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveAreaBorder(
    Size size,
    double deadZone,
    double gameAreaTop,
    double gameAreaHeight,
    double activeTop,
    double activeBottom,
    ThemeColorSet themeColors,
  ) {
    final activeLeft = size.width * deadZone;
    final activeWidth = size.width * (1 - 2 * deadZone);
    final activeHeight = activeBottom - activeTop;

    return Positioned(
      left: activeLeft,
      top: activeTop,
      width: activeWidth,
      height: activeHeight,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: themeColors.accent.withAlpha(100),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildBubble(
    AimTestState state,
    double activeLeft,
    double activeTop,
    double activeRight,
    double activeBottom,
  ) {
    final bubbleSize =
        (state.bubbleConfig.minSize + state.bubbleConfig.maxSize) / 2;
    final bubbleX = activeLeft + (activeRight - activeLeft) * state.currentBubbleX!;
    final bubbleY = activeTop + (activeBottom - activeTop) * state.currentBubbleY!;

    // Determine bubble color
    final selectedColor = state.bubbleConfig.selectedColor;
    final bubbleColor = selectedColor == BubbleColor.random
        ? BubbleConfig.allColors[state.bubblesSpawned % BubbleConfig.allColors.length]
        : selectedColor;

    final enableAnimation = state.bubbleConfig.enableAppearAnimation;

    return Positioned(
      left: bubbleX - bubbleSize / 2,
      top: bubbleY - bubbleSize / 2,
      child: enableAnimation
          ? AnimatedBuilder(
              animation: _bubbleAppearAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _bubbleAppearAnimation.value,
                  child: BubbleWidget(
                    key: ValueKey('${state.currentBubbleX}_${state.currentBubbleY}_${state.bubblesSpawned}'),
                    size: bubbleSize,
                    color: bubbleColor,
                    onTap: () {
                      ref.read(aimTestGameProvider.notifier).onBubbleTap();
                      _triggerBubbleAppear();
                    },
                  ),
                );
              },
            )
          : BubbleWidget(
              key: ValueKey('${state.currentBubbleX}_${state.currentBubbleY}_${state.bubblesSpawned}'),
              size: bubbleSize,
              color: bubbleColor,
              onTap: () {
                ref.read(aimTestGameProvider.notifier).onBubbleTap();
              },
            ),
    );
  }

  Widget _buildOSD(
    AimTestState state,
    ThemeColorSet themeColors,
    Size size,
    double safeAreaTop,
    double safeAreaBottom,
  ) {
    final osdTop = safeAreaTop + 16;
    const osdRight = 60.0; // Leave room for close button

    return Stack(
      children: [
        // Time OSD - top-left
        Positioned(
          left: 16,
          top: osdTop,
          child: _OSDContainer(
            themeColors: themeColors,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  color: themeColors.onPrimary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '${state.timeRemainingSeconds}s',
                  style: TextStyle(
                    color: themeColors.onPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Hits OSD - top-right (left of close button)
        Positioned(
          right: osdRight,
          top: osdTop,
          child: _OSDContainer(
            themeColors: themeColors,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app,
                  color: themeColors.onPrimary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '${state.score}',
                  style: TextStyle(
                    color: themeColors.onPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Misses OSD - below hits
        Positioned(
          right: osdRight,
          top: osdTop + 50,
          child: _OSDContainer(
            themeColors: themeColors,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.close,
                  color: themeColors.error,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  '${state.missedCount}',
                  style: TextStyle(
                    color: themeColors.error,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCloseButton(ThemeColorSet themeColors) {
    return Positioned(
      right: 16,
      top: 16,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(150),
            shape: BoxShape.circle,
            border: Border.all(
              color: themeColors.accent.withAlpha(100),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.close,
            color: themeColors.onPrimary,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownOverlay(AimTestState state, ThemeColorSet themeColors) {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {}, // Block taps during countdown
        child: AnimatedBuilder(
          animation: _countdownController,
          builder: (context, child) {
            return Center(
              child: Transform.scale(
                scale: _countdownScale.value,
                child: Opacity(
                  opacity: _countdownFade.value,
                  child: Text(
                    state.countdownDisplay,
                    style: TextStyle(
                      fontSize: 96,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(180),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OSDContainer extends StatelessWidget {
  final ThemeColorSet themeColors;
  final Widget child;

  const _OSDContainer({
    required this.themeColors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(180),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeColors.accent.withAlpha(100),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeColorSet themeColors;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.themeColors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: themeColors.textSecondary,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: themeColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
