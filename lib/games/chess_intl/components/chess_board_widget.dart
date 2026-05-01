import 'package:flutter/material.dart';

import '../../../ui/theme/theme_colors.dart';
import '../models/chess_move.dart';
import '../models/chess_state.dart';
import '../models/enums.dart';

class ChessBoardWidget extends StatelessWidget {
  final ChessState state;
  final PieceColor playerColor;
  final Function(int row, int col) onSquareTap;
  final int? selectedRow;
  final int? selectedCol;
  final List<ChessMove> legalMoves;
  final PieceStyle pieceStyle;

  const ChessBoardWidget({
    super.key,
    required this.state,
    required this.playerColor,
    required this.onSquareTap,
    this.selectedRow,
    this.selectedCol,
    this.legalMoves = const [],
    this.pieceStyle = PieceStyle.filled,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: context.themeBorder,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: context.themeShadow.withAlpha(100),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Column(
            children: List.generate(8, (r) {
              final displayRow =
                  playerColor == PieceColor.white ? r : 7 - r;
              return Expanded(
                child: Row(
                  children: List.generate(8, (c) {
                    final displayCol =
                        playerColor == PieceColor.white ? c : 7 - c;
                    return Expanded(
                      child: _buildSquare(
                        context,
                        isDark,
                        displayRow,
                        displayCol,
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildSquare(
      BuildContext context, bool isDark, int row, int col) {
    final isLight = (row + col) % 2 == 0;
    final piece = state.pieceAt(row, col);

    final isSelected =
        row == selectedRow && col == selectedCol;

    final isLastMoveFrom = row == state.lastMoveFromRow &&
        col == state.lastMoveFromCol;
    final isLastMoveTo =
        row == state.lastMoveToRow && col == state.lastMoveToCol;
    final isLastMove = isLastMoveFrom || isLastMoveTo;

    final isLegalTarget = legalMoves.any(
      (m) => m.toRow == row && m.toCol == col,
    );

    final isCheck = state.status == GameStatus.check &&
        piece != null &&
        piece.type == PieceType.king &&
        piece.color == state.currentTurn;

    Color squareColor;
    if (isSelected) {
      squareColor = isDark
          ? Colors.yellow.withAlpha(150)
          : Colors.yellow.withAlpha(180);
    } else if (isCheck) {
      squareColor = Colors.red.withAlpha(180);
    } else if (isLastMove) {
      squareColor = isDark
          ? Colors.amber.withAlpha(80)
          : Colors.amber.withAlpha(100);
    } else if (isLight) {
      squareColor = isDark
          ? const Color(0xFF769656)
          : const Color(0xFFEEEED2);
    } else {
      squareColor = isDark
          ? const Color(0xFF3B7A57)
          : const Color(0xFF769656);
    }

    return GestureDetector(
      onTap: () => onSquareTap(row, col),
      child: Container(
        color: squareColor,
        child: Stack(
          children: [
            if (isLegalTarget)
              Center(
                child: Container(
                  width: piece != null ? null : 14,
                  height: piece != null ? null : 14,
                  decoration: piece != null
                      ? BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withAlpha(80),
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                        )
                      : BoxDecoration(
                          color: Colors.black.withAlpha(60),
                          shape: BoxShape.circle,
                        ),
                ),
              ),
            if (piece != null)
              Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      piece.unicodeStyled(pieceStyle),
                      style: TextStyle(
                        fontSize: 40,
                        color: piece.color == PieceColor.white
                            ? (isDark ? Colors.white : Colors.white)
                            : (isDark ? Colors.black : Colors.black),
                        shadows: piece.color == PieceColor.white
                            ? [
                                Shadow(
                                  color: Colors.black.withAlpha(100),
                                  offset: const Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ]
                            : [
                                Shadow(
                                  color: Colors.white.withAlpha(60),
                                  offset: const Offset(0.5, 0.5),
                                  blurRadius: 1,
                                ),
                              ],
                      ),
                    ),
                  ),
                ),
              ),
            if (col == (playerColor == PieceColor.white ? 0 : 7))
              Positioned(
                top: 2,
                left: 2,
                child: Text(
                  '${8 - row}',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isLight
                        ? const Color(0xFF3B7A57)
                        : const Color(0xFFEEEED2),
                  ),
                ),
              ),
            if (row == (playerColor == PieceColor.white ? 7 : 0))
              Positioned(
                bottom: 1,
                right: 2,
                child: Text(
                  String.fromCharCode(
                      97 + (playerColor == PieceColor.white ? col : 7 - col)),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isLight
                        ? const Color(0xFF3B7A57)
                        : const Color(0xFFEEEED2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
