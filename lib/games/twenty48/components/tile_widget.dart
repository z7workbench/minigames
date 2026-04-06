import 'package:flutter/material.dart';
import '../../../ui/theme/theme_colors.dart';
import '../../../ui/theme/theme_provider.dart';
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
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);
    final tileColor = _getTileColor(
      widget.tile.value,
      isDark,
      context.colorSchemeType,
    );
    final textColor = _getTextColor(
      widget.tile.value,
      isDark,
      context.colorSchemeType,
    );

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
              color: themeColors.shadow.withAlpha(isDark ? 80 : 60),
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

  Color _getTileColor(int value, bool isDark, ColorSchemeType schemeType) {
    // Color gradient based on tile value and theme
    final colors = _getTileColorsForScheme(value, isDark, schemeType);
    return colors ?? defaultTileColor(isDark, schemeType);
  }

  Color _getTextColor(int value, bool isDark, ColorSchemeType schemeType) {
    // Higher value tiles have lighter text
    if (value >= 8) {
      return isDark ? Colors.white : const Color(0xFF311B92);
    }
    // Low value tiles: dark text for light mode, light text for dark mode
    return isDark ? const Color(0xFFE8EAF6) : const Color(0xFF311B92);
  }

  Color? _getTileColorsForScheme(
    int value,
    bool isDark,
    ColorSchemeType schemeType,
  ) {
    if (schemeType == ColorSchemeType.starlight) {
      // Starlight theme - cooler, bluer tones for 2048 tiles
      final starlightColors = <int, Color>{
        2: Color(0xFFC5CAE9),
        4: Color(0xFF9FA8DA),
        8: Color(0xFF7986CB),
        16: Color(0xFF5C6BC0),
        32: Color(0xFF3F51B5),
        64: Color(0xFF303F9F),
        128: Color(0xFF5C6BC0),
        256: Color(0xFF536DFE),
        512: Color(0xFF448AFF),
        1024: Color(0xFF448AFF),
        2048: Color(0xFF2962FF),
        4096: Color(0xFF283593),
        8192: Color(0xFF1A237E),
      };
      return starlightColors[value];
    } else {
      // Wooden theme - warmer, gold/amber tones (original 2048 colors)
      final woodenColors = <int, Color>{
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
      return woodenColors[value];
    }
  }

  Color defaultTileColor(bool isDark, ColorSchemeType schemeType) {
    if (schemeType == ColorSchemeType.starlight) {
      return isDark ? const Color(0xFF303F9F) : const Color(0xFF5C6BC0);
    }
    return const Color(0xFF3B5998);
  }

  double _getFontSize(int value) {
    if (value < 100) return widget.size * 0.5;
    if (value < 1000) return widget.size * 0.4;
    return widget.size * 0.35;
  }
}
