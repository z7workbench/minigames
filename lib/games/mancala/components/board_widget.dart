import 'package:flutter/material.dart';

import '../../../ui/theme/theme_colors.dart';
import '../models/mancala_state.dart';
import 'pit_widget.dart';
import 'sowing_animation_widget.dart';

/// Responsive board widget for Mancala game.
///
/// Layout:
/// - 2 rows of 6 pits each
/// - 2 stores on the sides
/// - Responsive sizing for phone/tablet
class BoardWidget extends StatelessWidget {
  /// Current game state.
  final MancalaState state;

  /// Callback when a pit is selected.
  final void Function(int pitIndex)? onPitSelected;

  const BoardWidget({super.key, required this.state, this.onPitSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive sizing
        final isWide = constraints.maxWidth > 600;
        final boardHeight = constraints.maxHeight;
        final boardWidth = constraints.maxWidth;

        // Store width: about 10% of board width or min 60px
        final storeWidth = (boardWidth * 0.1).clamp(50.0, 80.0);

        // Pit size: fit 6 pits in remaining width
        final pitAreaWidth = boardWidth - (storeWidth * 2) - 32;
        final pitSize = (pitAreaWidth / 6).clamp(40.0, 70.0);

        final boardSize = Size(boardWidth, boardHeight);

        return Stack(
          children: [
            // Main board container
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [context.themeSurface, context.themeCard],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.themeBorder, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: context.themeShadow.withAlpha(150),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Main board area
                  Expanded(
                    child: Row(
                      children: [
                        // Player 2's store (left side)
                        StoreWidget(
                          seeds: state.player2Store,
                          isCurrentPlayer: state.currentPlayer == 1,
                        ),

                        // Pits area
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Player 2's pits (top row, indices 12-7, displayed right to left)
                              _buildPitRow(
                                isDark: isDark,
                                pitIndices: [12, 11, 10, 9, 8, 7],
                                pitSize: pitSize,
                                isPlayer2Row: true,
                              ),

                              // Divider
                              Container(
                                height: 2,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: context.themeBorder,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),

                              // Player 1's pits (bottom row, indices 0-5, displayed left to right)
                              _buildPitRow(
                                isDark: isDark,
                                pitIndices: [0, 1, 2, 3, 4, 5],
                                pitSize: pitSize,
                                isPlayer2Row: false,
                              ),
                            ],
                          ),
                        ),

                        // Player 1's store (right side)
                        StoreWidget(
                          seeds: state.player1Store,
                          isCurrentPlayer: state.currentPlayer == 0,
                        ),
                      ],
                    ),
                  ),

                  // Turn indicator
                  _buildTurnIndicator(context, isDark),
                ],
              ),
            ),

            // Animation overlay
            if (state.sowingAnimation != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: SowingOverlayWidget(
                    state: state,
                    boardSize: boardSize,
                  ),
                ),
              ),

            // Game message overlay (positioned at top, doesn't affect layout)
            if (state.animationMessage != null)
              Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.themeCard.withAlpha(230),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: context.themeAccent, width: 2),
                    ),
                    child: Text(
                      state.animationMessage!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.themeAccent,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPitRow({
    required bool isDark,
    required List<int> pitIndices,
    required double pitSize,
    required bool isPlayer2Row,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: pitIndices.map((pitIndex) {
        final seeds = state.board[pitIndex];
        final isCurrentPlayerPit = isPlayer2Row
            ? state.currentPlayer == 1
            : state.currentPlayer == 0;
        final isPlayable =
            isCurrentPlayerPit &&
            seeds > 0 &&
            state.status == MancalaStatus.playing &&
            !state.isAiTurn;

        // Highlight logic for animation
        bool isHighlighted = false;
        if (state.sowingAnimation != null) {
          // Highlight the pit where seeds were picked from
          if (pitIndex == state.sowingAnimation!.sourcePitIndex) {
            isHighlighted = true;
          }
          // Highlight the pit where the last seed was dropped
          if (state.sowingAnimation!.seedsDropped > 0 &&
              state.sowingAnimation!.seedsInHand == 0 &&
              pitIndex == state.sowingAnimation!.currentDropIndex) {
            isHighlighted = true;
          }
        }

        return SizedBox(
          width: pitSize,
          height: pitSize,
          child: PitWidget(
            seeds: seeds,
            isPlayable: isPlayable,
            isCurrentPlayerPit: isCurrentPlayerPit,
            pitIndex: pitIndex,
            highlight: isHighlighted,
            onTap: () => onPitSelected?.call(pitIndex),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTurnIndicator(BuildContext context, bool isDark) {
    String turnText;
    IconData turnIcon;

    if (state.status == MancalaStatus.gameOver) {
      final winner = state.winner;
      if (winner == null) {
        turnText = "It's a Draw!";
      } else if (state.aiDifficulty != null) {
        turnText = winner == 0 ? "You Win!" : "AI Wins!";
      } else {
        turnText = "Player ${winner + 1} Wins!";
      }
      turnIcon = Icons.emoji_events;
    } else if (state.isAiTurn) {
      turnText = "AI Thinking...";
      turnIcon = Icons.psychology;
    } else if (state.aiDifficulty != null) {
      turnText = state.currentPlayer == 0 ? "Your Turn" : "AI's Turn";
      turnIcon = state.currentPlayer == 0 ? Icons.person : Icons.computer;
    } else {
      turnText = "Player ${state.currentPlayer + 1}'s Turn";
      turnIcon = Icons.person;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.themeCard.withAlpha(200),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.themeBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(turnIcon, size: 20, color: context.themeAccent),
          const SizedBox(width: 8),
          Text(
            turnText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.themeTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
