import 'package:flutter/material.dart';

import '../../../ui/theme/theme_colors.dart';
import '../models/connect_four_state.dart';
import '../models/enums.dart';

class ConnectFourBoard extends StatefulWidget {
  final ConnectFourState state;
  final void Function(int col) onColumnTap;
  final int? hoverCol;

  const ConnectFourBoard({
    super.key,
    required this.state,
    required this.onColumnTap,
    this.hoverCol,
  });

  @override
  State<ConnectFourBoard> createState() => _ConnectFourBoardState();
}

class _ConnectFourBoardState extends State<ConnectFourBoard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        const labelSize = 20.0;

        final boardAreaWidth = availableWidth - labelSize;
        final boardAreaHeight = availableHeight - labelSize;

        final cellSizeByWidth = boardAreaWidth / ConnectFourState.cols;
        final cellSizeByHeight = boardAreaHeight / ConnectFourState.rows;
        final cellSize = cellSizeByWidth < cellSizeByHeight
            ? cellSizeByWidth
            : cellSizeByHeight;

        final boardWidth = cellSize * ConnectFourState.cols;
        final boardHeight = cellSize * ConnectFourState.rows;
        final pieceRadius = cellSize * 0.38;
        final holeRadius = cellSize * 0.35;

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: labelSize,
                    height: boardHeight,
                    child: _buildRowLabels(cellSize, labelSize),
                  ),
                  SizedBox(
                    width: boardWidth,
                    height: boardHeight,
                    child: Stack(
                      children: [
                        _buildBoardBackground(
                            boardWidth, boardHeight, cellSize, holeRadius),
                        _buildPieces(cellSize, pieceRadius),
                        _buildTapZones(cellSize, boardWidth, boardHeight),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: labelSize + boardWidth,
                height: labelSize,
                child: Padding(
                  padding: EdgeInsets.only(left: labelSize),
                  child: _buildColLabels(cellSize, labelSize),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRowLabels(double cellSize, double labelSize) {
    return Column(
      children: List.generate(ConnectFourState.rows, (r) {
        return SizedBox(
          width: labelSize,
          height: cellSize,
          child: Center(
            child: Text(
              ConnectFourState.rowLabel(r),
              style: TextStyle(
                color: context.themeTextSecondary,
                fontSize: cellSize * 0.22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildColLabels(double cellSize, double labelSize) {
    return Row(
      children: List.generate(ConnectFourState.cols, (c) {
        return SizedBox(
          width: cellSize,
          height: labelSize,
          child: Center(
            child: Text(
              ConnectFourState.colLabel(c),
              style: TextStyle(
                color: context.themeTextSecondary,
                fontSize: cellSize * 0.25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBoardBackground(
      double width, double height, double cellSize, double holeRadius) {
    return CustomPaint(
      size: Size(width, height),
      painter: _BoardPainter(
        cellSize: cellSize,
        holeRadius: holeRadius,
        boardColor: context.themeAccent.withAlpha(180),
        holeColor: context.themeBackground,
        borderColor: context.themeBorder,
      ),
    );
  }

  Widget _buildPieces(double cellSize, double pieceRadius) {
    return Stack(
      children: [
        for (int r = 0; r < ConnectFourState.rows; r++)
          for (int c = 0; c < ConnectFourState.cols; c++)
            if (widget.state.board[r][c] != CellState.empty)
              Positioned(
                left: c * cellSize + (cellSize - pieceRadius * 2) / 2,
                top: r * cellSize + (cellSize - pieceRadius * 2) / 2,
                child: _buildPiece(
                    widget.state.board[r][c], pieceRadius, false),
              ),
        if (widget.state.winningCells != null)
          for (int r = 0; r < ConnectFourState.rows; r++)
            for (int c = 0; c < ConnectFourState.cols; c++)
              if (widget.state.winningCells![r][c])
                Positioned(
                  left: c * cellSize + (cellSize - pieceRadius * 2) / 2,
                  top: r * cellSize + (cellSize - pieceRadius * 2) / 2,
                  child: Container(
                    width: pieceRadius * 2,
                    height: pieceRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.yellow.withAlpha(200),
                        width: 3,
                      ),
                    ),
                  ),
                ),
      ],
    );
  }

  Widget _buildPiece(CellState piece, double radius, bool isGhost) {
    final isPlayer = piece == CellState.player;
    final color = isPlayer ? Colors.red : Colors.yellow;
    final borderColor =
        isPlayer ? Colors.red.shade800 : Colors.orange.shade700;

    return Opacity(
      opacity: isGhost ? 0.4 : 1.0,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withAlpha(230),
              color.withAlpha(180),
              borderColor,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(60),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isGhost
            ? null
            : Center(
                child: Container(
                  width: radius * 0.8,
                  height: radius * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withAlpha(100),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTapZones(double cellSize, double boardWidth, double boardHeight) {
    return Positioned.fill(
      child: Row(
        children: List.generate(ConnectFourState.cols, (col) {
          final isFull = widget.state.isColumnFull(col);
          final canTap = widget.state.phase == GamePhase.playing &&
              widget.state.currentTurn == CellState.player &&
              !isFull;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: canTap ? () => widget.onColumnTap(col) : null,
            child: SizedBox(
              width: cellSize,
              height: boardHeight,
              child: canTap && widget.hoverCol == col
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: cellSize * 0.1),
                        child: _buildPiece(
                          widget.state.currentTurn,
                          cellSize * 0.3,
                          true,
                        ),
                      ),
                    )
                  : null,
            ),
          );
        }),
      ),
    );
  }
}

class _BoardPainter extends CustomPainter {
  final double cellSize;
  final double holeRadius;
  final Color boardColor;
  final Color holeColor;
  final Color borderColor;

  _BoardPainter({
    required this.cellSize,
    required this.holeRadius,
    required this.boardColor,
    required this.holeColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final boardPaint = Paint()
      ..color = boardColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final holePaint = Paint()
      ..color = holeColor
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(8),
    );
    canvas.drawRRect(rrect, boardPaint);
    canvas.drawRRect(rrect, borderPaint);

    for (int r = 0; r < ConnectFourState.rows; r++) {
      for (int c = 0; c < ConnectFourState.cols; c++) {
        final cx = c * cellSize + cellSize / 2;
        final cy = r * cellSize + cellSize / 2;
        canvas.drawCircle(Offset(cx, cy), holeRadius, holePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) {
    return oldDelegate.boardColor != boardColor ||
        oldDelegate.holeColor != holeColor;
  }
}
