import 'package:flutter/material.dart';

import '../../../ui/theme/wooden_colors.dart';
import '../models/mancala_state.dart';

/// A widget that overlays on the board to show seed-by-seed sowing animation.
///
/// Shows:
/// - A "hand" carrying seeds
/// - Seeds being dropped one-by-one into pits
/// - Visual feedback for the current drop position
class SowingAnimationWidget extends StatefulWidget {
  /// The sowing animation state.
  final SowingAnimationState animationState;

  /// The current player (0 or 1).
  final int currentPlayer;

  /// Size of the board area.
  final Size boardSize;

  /// Callback when a seed is dropped.
  final VoidCallback? onSeedDropped;

  /// Callback when animation completes.
  final VoidCallback? onAnimationComplete;

  const SowingAnimationWidget({
    super.key,
    required this.animationState,
    required this.currentPlayer,
    required this.boardSize,
    this.onSeedDropped,
    this.onAnimationComplete,
  });

  @override
  State<SowingAnimationWidget> createState() => _SowingAnimationWidgetState();
}

class _SowingAnimationWidgetState extends State<SowingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;

  // Current position of the "hand" (pit index)
  int _currentPosition = 0;

  // Seeds remaining in hand (visual)
  int _seedsInHand = 0;

  // Flag to track if we're animating
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _positionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener(_onAnimationStatusChanged);

    // Initialize from widget
    _currentPosition = widget.animationState.currentDropIndex;
    _seedsInHand = widget.animationState.seedsInHand;
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Seed has been dropped
      widget.onSeedDropped?.call();

      if (_seedsInHand > 0) {
        // Continue to next position
        _animateToNextPosition();
      } else {
        // Animation complete
        _isAnimating = false;
        widget.onAnimationComplete?.call();
      }
    }
  }

  void _animateToNextPosition() {
    if (!mounted) return;

    setState(() {
      _isAnimating = true;
    });
    _controller.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(SowingAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update seeds in hand
    if (widget.animationState.seedsInHand !=
        oldWidget.animationState.seedsInHand) {
      setState(() {
        _seedsInHand = widget.animationState.seedsInHand;
      });
    }

    // Start animation when position changes
    if (widget.animationState.currentDropIndex !=
        oldWidget.animationState.currentDropIndex) {
      setState(() {
        _currentPosition = widget.animationState.currentDropIndex;
      });

      if (!_isAnimating && widget.animationState.seedsDropped > 0) {
        _animateToNextPosition();
      }
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onAnimationStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  /// Get the position of a pit on the board.
  Offset _getPitPosition(int pitIndex, Size boardSize) {
    // Board layout:
    // - Player 2's pits: indices 12-7 (top row, left to right on screen)
    // - Player 2's store: index 13 (left side)
    // - Player 1's pits: indices 0-5 (bottom row, left to right on screen)
    // - Player 1's store: index 6 (right side)

    final storeWidth = boardSize.width * 0.1;
    final pitAreaWidth = boardSize.width - (storeWidth * 2);
    final pitWidth = pitAreaWidth / 6;
    final rowHeight = boardSize.height / 2;

    double x, y;

    if (pitIndex == 13) {
      // Player 2's store (left side)
      x = storeWidth / 2;
      y = boardSize.height / 2;
    } else if (pitIndex == 6) {
      // Player 1's store (right side)
      x = boardSize.width - storeWidth / 2;
      y = boardSize.height / 2;
    } else if (pitIndex >= 7 && pitIndex <= 12) {
      // Player 2's pits (top row)
      // Display order: 12, 11, 10, 9, 8, 7 (left to right)
      final displayIndex = 12 - pitIndex;
      x = storeWidth + (displayIndex + 0.5) * pitWidth;
      y = rowHeight / 2;
    } else {
      // Player 1's pits (bottom row)
      // Display order: 0, 1, 2, 3, 4, 5 (left to right)
      x = storeWidth + (pitIndex + 0.5) * pitWidth;
      y = boardSize.height - rowHeight / 2;
    }

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get source and current positions
    final sourcePos = _getPitPosition(
      widget.animationState.sourcePitIndex,
      widget.boardSize,
    );
    final currentPos = _getPitPosition(
      widget.animationState.currentDropIndex,
      widget.boardSize,
    );

    // Interpolate position during animation
    final handPos =
        Offset.lerp(sourcePos, currentPos, _positionAnimation.value) ??
        currentPos;

    return Stack(
      children: [
        // Highlight current drop position
        Positioned(
          left: currentPos.dx - 30,
          top: currentPos.dy - 30,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: WoodenColors.accentAmber.withAlpha(150),
                width: 3,
              ),
              color: WoodenColors.accentAmber.withAlpha(30),
            ),
          ),
        ),

        // Hand with seeds
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          left: handPos.dx - 20,
          top: handPos.dy - 20,
          child: _buildHandWithSeeds(isDark),
        ),
      ],
    );
  }

  Widget _buildHandWithSeeds(bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? WoodenColors.darkCard.withAlpha(200)
            : WoodenColors.lightCard.withAlpha(200),
        border: Border.all(color: WoodenColors.accentAmber, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Seed icon
          if (_seedsInHand > 0)
            Icon(Icons.grain, color: WoodenColors.accentAmber, size: 24),
          // Seed count
          Positioned(
            bottom: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: WoodenColors.accentAmber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$_seedsInHand',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A simpler animation overlay that uses the provider's animation state
/// and doesn't manage its own animation timing.
class SowingOverlayWidget extends StatelessWidget {
  /// Current game state.
  final MancalaState state;

  /// Size of the board area.
  final Size boardSize;

  const SowingOverlayWidget({
    super.key,
    required this.state,
    required this.boardSize,
  });

  @override
  Widget build(BuildContext context) {
    final animation = state.sowingAnimation;
    if (animation == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentPos = _getPitPosition(animation.currentDropIndex, boardSize);

    return Stack(
      children: [
        // Highlight current drop position
        Positioned(
          left: currentPos.dx - 35,
          top: currentPos.dy - 35,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: WoodenColors.accentAmber.withAlpha(180),
                width: 3,
              ),
              color: WoodenColors.accentAmber.withAlpha(40),
            ),
          ),
        ),

        // Hand cursor with seeds
        Positioned(
          left: currentPos.dx - 20,
          top: currentPos.dy - 20,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 200),
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: _buildHandWidget(animation.seedsInHand, isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildHandWidget(int seedsInHand, bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? WoodenColors.darkCard.withAlpha(220)
            : WoodenColors.lightCard.withAlpha(220),
        border: Border.all(color: WoodenColors.accentAmber, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(120),
            blurRadius: 10,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (seedsInHand > 0)
            Icon(Icons.grain, color: WoodenColors.accentAmber, size: 22),
          Positioned(
            bottom: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: WoodenColors.accentAmber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$seedsInHand',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get the position of a pit on the board.
  Offset _getPitPosition(int pitIndex, Size boardSize) {
    final storeWidth = boardSize.width * 0.1;
    final pitAreaWidth = boardSize.width - (storeWidth * 2);
    final pitWidth = pitAreaWidth / 6;
    final rowHeight = boardSize.height / 2;

    double x, y;

    if (pitIndex == 13) {
      // Player 2's store (left side)
      x = storeWidth / 2;
      y = boardSize.height / 2;
    } else if (pitIndex == 6) {
      // Player 1's store (right side)
      x = boardSize.width - storeWidth / 2;
      y = boardSize.height / 2;
    } else if (pitIndex >= 7 && pitIndex <= 12) {
      // Player 2's pits (top row)
      // Display order: 12, 11, 10, 9, 8, 7 (left to right)
      final displayIndex = 12 - pitIndex;
      x = storeWidth + (displayIndex + 0.5) * pitWidth;
      y = rowHeight / 2;
    } else {
      // Player 1's pits (bottom row)
      // Display order: 0, 1, 2, 3, 4, 5 (left to right)
      x = storeWidth + (pitIndex + 0.5) * pitWidth;
      y = boardSize.height - rowHeight / 2;
    }

    return Offset(x, y);
  }
}
