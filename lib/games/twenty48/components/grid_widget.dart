import 'package:flutter/material.dart';
import '../models/twenty48_tile.dart';
import 'tile_widget.dart';

/// 2048 grid background colors - classic design, only light/dark mode distinction
class _GridColors {
  // Light mode - classic 2048 background
  static const backgroundColor = Color(0xFFBBADA0); // Warm gray-brown
  static const emptyCellColor = Color(0xFFCDC1B4);  // Light beige

  // Dark mode - adjusted for visibility
  static const darkBackgroundColor = Color(0xFF3C3A32); // Dark brown-gray
  static const darkEmptyCellColor = Color(0xFF4A4640);  // Slightly lighter gray
}

/// A 4x4 grid widget for the 2048 game.
class GridWidget extends StatelessWidget {
  /// The 4x4 grid of tiles.
  final List<List<Twenty48Tile?>> grid;

  /// The spacing between tiles.
  final double spacing;

  /// Padding around the grid.
  final double padding;

  const GridWidget({
    super.key,
    required this.grid,
    this.spacing = 8.0,
    this.padding = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark 
        ? _GridColors.darkBackgroundColor 
        : _GridColors.backgroundColor;
    final emptyCellColor = isDark 
        ? _GridColors.darkEmptyCellColor 
        : _GridColors.emptyCellColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridSize = constraints.maxWidth;
        // Calculate tile size ensuring no rounding issues
        final totalSpacing = spacing * 3; // 3 gaps between 4 tiles
        final totalPadding = padding * 2;
        final tileSize = ((gridSize - totalPadding - totalSpacing) / 4)
            .floorToDouble();

        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? Colors.black.withAlpha(80)
                    : bgColor.withAlpha(60),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // Background cells (empty slots)
                ..._buildBackgroundCells(tileSize, emptyCellColor),
                // Tiles
                ..._buildTiles(tileSize),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildBackgroundCells(double tileSize, Color emptyCellColor) {
    final cells = <Widget>[];
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        final left = col * (tileSize + spacing);
        final top = row * (tileSize + spacing);

        cells.add(
          Positioned(
            left: left,
            top: top,
            child: Container(
              width: tileSize,
              height: tileSize,
              decoration: BoxDecoration(
                color: emptyCellColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        );
      }
    }
    return cells;
  }

  List<Widget> _buildTiles(double tileSize) {
    final tiles = <Widget>[];
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        final tile = grid[row][col];
        if (tile != null) {
          final left = col * (tileSize + spacing);
          final top = row * (tileSize + spacing);

          tiles.add(
            AnimatedPositioned(
              key: ValueKey(tile.id),
              left: left,
              top: top,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              child: TileWidget(tile: tile, size: tileSize),
            ),
          );
        }
      }
    }
    return tiles;
  }
}