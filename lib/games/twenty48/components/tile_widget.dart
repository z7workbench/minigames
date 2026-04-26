import 'package:flutter/material.dart';
import '../models/twenty48_tile.dart';

/// 2048 tile colors - classic design, only light/dark mode distinction
/// These colors are intentionally NOT theme-aware to ensure readability
class _TileColors {
  // Light mode colors - classic 2048 palette extended to 65536
  static const lightColors = <int, Color>{
    2: Color(0xFFEEE4DA),    // Light beige
    4: Color(0xFFEDE0C8),    // Cream
    8: Color(0xFFF2B179),    // Orange
    16: Color(0xFFF59563),   // Dark orange
    32: Color(0xFFF67C5F),   // Red-orange
    64: Color(0xFFF65E3B),   // Bright red
    128: Color(0xFFEDCF72),  // Gold
    256: Color(0xFFEDCC61),  // Yellow-gold
    512: Color(0xFFEDC850),  // Bright yellow
    1024: Color(0xFFEDC53F), // Brighter yellow
    2048: Color(0xFFEDC22E), // Golden yellow (winning tile!)
    // Beyond 2048 - cooler tones for higher achievements
    4096: Color(0xFF5D536B), // Deep purple-gray
    8192: Color(0xFF4A4A6B), // Dark blue-gray
    16384: Color(0xFF2F4F6B), // Deep teal
    32768: Color(0xFF1E3A5F), // Navy blue
    65536: Color(0xFF1A1A2E), // Very dark blue
  };

  // Dark mode colors - adjusted for dark background visibility
  static const darkColors = <int, Color>{
    2: Color(0xFF5C554A),    // Darker warm gray (more contrast)
    4: Color(0xFF7D7668),    // Lighter warm gray (distinct from 2)
    8: Color(0xFFD49A5D),    // Warm orange
    16: Color(0xFFD97B4D),   // Orange
    32: Color(0xFFD95E45),   // Red-orange
    64: Color(0xFFD94432),   // Red
    128: Color(0xFFC9A654),  // Gold
    256: Color(0xFFC9963D),  // Yellow-gold
    512: Color(0xFFC98528),  // Bright yellow
    1024: Color(0xFFC97518), // Brighter yellow
    2048: Color(0xFFC9660A), // Golden yellow (winning tile!)
    // Beyond 2048 - cooler tones for higher achievements
    4096: Color(0xFF8B7D8B), // Light purple-gray
    8192: Color(0xFF7A7A9B), // Light blue-gray
    16384: Color(0xFF5F8F9B), // Teal
    32768: Color(0xFF4A6A8F), // Steel blue
    65536: Color(0xFF3A5A7E), // Medium blue
  };

  // Light mode text colors
  static const lightTextColors = <int, Color>{
    // Low value tiles (2, 4): dark text
    2: Color(0xFF776E65),
    4: Color(0xFF776E65),
    // Higher values: white text for contrast
    // All tiles >= 8 use white text
  };

  // Dark mode text colors
  static const darkTextColors = <int, Color>{
    // Low value tiles (2, 4): light text
    2: Color(0xFFE8E4E0),
    4: Color(0xFFE8E4E0),
    // Higher values: white text
  };

  static Color getTileColor(int value, bool isDark) {
    final colors = isDark ? darkColors : lightColors;
    // If we have a specific color for this value, use it
    if (colors.containsKey(value)) {
      return colors[value]!;
    }
    // For values beyond 65536, use the darkest color with slight variation
    if (value > 65536) {
      return isDark 
          ? const Color(0xFF2A4A6A) // Medium blue for dark mode
          : const Color(0xFF0F0F1E); // Very dark for light mode
    }
    // Default fallback
    return isDark ? const Color(0xFF1F1D1B) : const Color(0xFFCDC1B4);
  }

  static Color getTextColor(int value, bool isDark) {
    // Tiles >= 8 always have white text for visibility
    if (value >= 8) {
      return Colors.white;
    }
    // Low value tiles (2, 4): dark text in light mode, light text in dark mode
    if (isDark) {
      return darkTextColors[value] ?? const Color(0xFFE8E4E0);
    }
    return lightTextColors[value] ?? const Color(0xFF776E65);
  }
}

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
    final tileColor = _TileColors.getTileColor(widget.tile.value, isDark);
    final textColor = _TileColors.getTextColor(widget.tile.value, isDark);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(6),
          // Subtle inner border effect
          border: Border.all(
            color: tileColor.withAlpha(isDark ? 120 : 80),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark 
                  ? Colors.black.withAlpha(60)
                  : tileColor.withAlpha(40),
              blurRadius: 2,
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

  double _getFontSize(int value) {
    // Adjust font size based on number of digits
    if (value < 100) return widget.size * 0.5;       // 1-2 digits: 2, 4, 8, 16, 32, 64
    if (value < 1000) return widget.size * 0.4;      // 3 digits: 128, 256, 512
    if (value < 10000) return widget.size * 0.35;    // 4 digits: 1024, 2048, 4096, 8192
    if (value < 100000) return widget.size * 0.28;   // 5 digits: 16384, 32768, 65536
    return widget.size * 0.22;                        // 6+ digits: 131072, etc.
  }
}