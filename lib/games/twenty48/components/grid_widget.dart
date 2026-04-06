import 'package:flutter/material.dart';
import '../../../ui/theme/theme_colors.dart';
import '../models/twenty48_tile.dart';
import 'tile_widget.dart';

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
    final themeColors = ThemeColors.getColors(isDark, context.colorSchemeType);

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
            color: themeColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: themeColors.border, width: 2),
            boxShadow: [
              BoxShadow(
                color: themeColors.shadow.withAlpha(150),
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
                // Background cells
                ..._buildBackgroundCells(tileSize, themeColors),
                // Tiles
                ..._buildTiles(tileSize),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildBackgroundCells(
    double tileSize,
    ThemeColorSet themeColors,
  ) {
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
                color: themeColors.card.withAlpha(150),
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
