import 'package:flutter/material.dart';
import '../../../ui/theme/wooden_colors.dart';
import '../models/twenty48_tile.dart';

/// A widget that displays a single 2048 tile with animations.
class TileWidget extends StatefulWidget {
  /// The tile to display.
  final Twenty48Tile tile;

  /// The size of the tile in pixels.
  final double size;

  const TileWidget({super.key, required this.tile, required this.size});

  @override
  State<TileWidget> createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    // Start spawn animation for new tiles
    if (widget.tile.isNew) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(TileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger spawn animation for newly created tiles
    if (widget.tile.isNew && !oldWidget.tile.isNew) {
      _controller.forward(from: 0.0);
    }

    // Trigger merge animation
    if (widget.tile.isMerged && !oldWidget.tile.isMerged) {
      _controller.forward(from: 0.0);
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
    final tileColor = _getTileColor(widget.tile.value, isDark);
    final textColor = _getTextColor(widget.tile.value, isDark);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(6),
          // Light subtle border
          border: Border.all(
            color: tileColor.withAlpha(isDark ? 80 : 60),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? WoodenColors.darkShadow.withAlpha(80)
                  : WoodenColors.lightShadow.withAlpha(60),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '${widget.tile.value}',
            style: TextStyle(
              fontSize: _getFontSize(widget.tile.value),
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Color _getTileColor(int value, bool isDark) {
    // Color gradient based on tile value
    final colors = isDark ? _darkTileColors : _lightTileColors;
    return colors[value] ??
        (isDark ? const Color(0xFF3B5998) : const Color(0xFF3B5998));
  }

  Color _getTextColor(int value, bool isDark) {
    // Higher value tiles have lighter text
    if (value >= 8) {
      return Colors.white;
    }
    // Low value tiles: dark text for light mode, light text for dark mode
    return isDark ? const Color(0xFFE0D8CF) : const Color(0xFF776E65);
  }

  double _getFontSize(int value) {
    if (value < 100) return widget.size * 0.5;
    if (value < 1000) return widget.size * 0.4;
    return widget.size * 0.35;
  }

  static const Map<int, Color> _lightTileColors = {
    2: Color(0xFFEEE4DA),
    4: Color(0xFFEDE0C8),
    8: Color(0xFFF2B179),
    16: Color(0xFFF59563),
    32: Color(0xFFF67C5F),
    64: Color(0xFFF65E3B),
    128: Color(0xFFEDCF72),
    256: Color(0xFFEDCC61),
    512: Color(0xFFEDC850),
    1024: Color(0xFFEDC53F),
    2048: Color(0xFFEDC22E),
    4096: Color(0xFF3C3A32),
    8192: Color(0xFF3C3A32),
  };

  static const Map<int, Color> _darkTileColors = {
    2: Color(0xFF6B6359),
    4: Color(0xFF6D6557),
    8: Color(0xFFE09A50),
    16: Color(0xFFD98048),
    32: Color(0xFFD66A48),
    64: Color(0xFFD64A28),
    128: Color(0xFFC9A848),
    256: Color(0xFFC99E38),
    512: Color(0xFFC99530),
    1024: Color(0xFFC98C28),
    2048: Color(0xFFC98220),
    4096: Color(0xFF2C2A25),
    8192: Color(0xFF2C2A25),
  };
}
