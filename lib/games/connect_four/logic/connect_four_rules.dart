import '../models/connect_four_state.dart';
import '../models/enums.dart';

class ConnectFourRules {
  static bool isValidMove(ConnectFourState state, int col) {
    return col >= 0 &&
        col < ConnectFourState.cols &&
        !state.isColumnFull(col);
  }

  static ConnectFourState applyMove(ConnectFourState state, int col) {
    final row = state.getDropRow(col);
    final newBoard = state.board.map((r) => List<CellState>.from(r)).toList();
    newBoard[row][col] = state.currentTurn;

    final newColHeight = List<int>.from(state.colHeight);
    newColHeight[col]++;

    final newHistory = List<int>.from(state.moveHistory)..add(col);

    final newState = state.copyWith(
      board: newBoard,
      colHeight: newColHeight,
      currentTurn: state.currentTurn.opposite,
      moveCount: state.moveCount + 1,
      moveHistory: newHistory,
      lastMoveRow: row,
      lastMoveCol: col,
    );

    return newState;
  }

  static ConnectFourState checkGameResult(ConnectFourState state) {
    if (state.lastMoveRow == null || state.lastMoveCol == null) return state;

    final winning = findWinningCells(state, state.lastMoveRow!, state.lastMoveCol!);
    if (winning != null) {
      final lastPiece = state.cellAt(state.lastMoveRow!, state.lastMoveCol!);
      final result = lastPiece == CellState.player
          ? GameResult.playerWin
          : GameResult.aiWin;
      return state.copyWith(
        phase: GamePhase.gameOver,
        result: result,
        winningCells: winning,
      );
    }

    if (state.isBoardFull) {
      return state.copyWith(
        phase: GamePhase.gameOver,
        result: GameResult.draw,
      );
    }

    return state;
  }

  static List<List<bool>>? findWinningCells(
      ConnectFourState state, int row, int col) {
    final piece = state.cellAt(row, col);
    if (piece == CellState.empty) return null;

    const directions = [
      [0, 1],
      [1, 0],
      [1, 1],
      [1, -1],
    ];

    for (final dir in directions) {
      final cells = <List<int>>[];
      cells.add([row, col]);

      for (int sign = -1; sign <= 1; sign += 2) {
        for (int i = 1; i < ConnectFourState.connectCount; i++) {
          final r = row + dir[0] * i * sign;
          final c = col + dir[1] * i * sign;
          if (r < 0 ||
              r >= ConnectFourState.rows ||
              c < 0 ||
              c >= ConnectFourState.cols) break;
          if (state.cellAt(r, c) != piece) break;
          cells.add([r, c]);
        }
      }

      if (cells.length >= ConnectFourState.connectCount) {
        final winning = List.generate(
          ConnectFourState.rows,
          (_) => List.filled(ConnectFourState.cols, false),
        );
        for (final cell in cells) {
          winning[cell[0]][cell[1]] = true;
        }
        return winning;
      }
    }

    return null;
  }

  static int countThreats(ConnectFourState state, int col, CellState piece) {
    final row = state.getDropRow(col);
    final testBoard = state.board.map((r) => List<CellState>.from(r)).toList();
    testBoard[row][col] = piece;

    int threats = 0;
    const directions = [
      [0, 1],
      [1, 0],
      [1, 1],
      [1, -1],
    ];

    for (final dir in directions) {
      for (int startOffset = -(ConnectFourState.connectCount - 1);
          startOffset <= 0;
          startOffset++) {
        int count = 0;
        int empty = 0;
        for (int i = 0; i < ConnectFourState.connectCount; i++) {
          final r = row + dir[0] * (startOffset + i);
          final c = col + dir[1] * (startOffset + i);
          if (r < 0 ||
              r >= ConnectFourState.rows ||
              c < 0 ||
              c >= ConnectFourState.cols) {
            count = -1;
            break;
          }
          if (testBoard[r][c] == piece) {
            count++;
          } else if (testBoard[r][c] == CellState.empty) {
            empty++;
          } else {
            count = -1;
            break;
          }
        }
        if (count >= 0 && count + empty == ConnectFourState.connectCount) {
          if (count >= 3) threats += count * 2;
          threats += count;
        }
      }
    }

    return threats;
  }

  static bool wouldWin(ConnectFourState state, int col, CellState piece) {
    final row = state.getDropRow(col);
    final testBoard = state.board.map((r) => List<CellState>.from(r)).toList();
    testBoard[row][col] = piece;

    const directions = [
      [0, 1],
      [1, 0],
      [1, 1],
      [1, -1],
    ];

    for (final dir in directions) {
      int count = 1;
      for (int sign = -1; sign <= 1; sign += 2) {
        for (int i = 1; i < ConnectFourState.connectCount; i++) {
          final r = row + dir[0] * i * sign;
          final c = col + dir[1] * i * sign;
          if (r < 0 ||
              r >= ConnectFourState.rows ||
              c < 0 ||
              c >= ConnectFourState.cols) break;
          if (testBoard[r][c] != piece) break;
          count++;
        }
      }
      if (count >= ConnectFourState.connectCount) return true;
    }

    return false;
  }

  static int evaluateBoard(ConnectFourState state, CellState aiPiece) {
    int score = 0;
    final playerPiece = aiPiece.opposite;

    const centerCol = ConnectFourState.cols ~/ 2;
    for (int r = 0; r < ConnectFourState.rows; r++) {
      if (state.board[r][centerCol] == aiPiece) {
        score += 3;
      } else if (state.board[r][centerCol] == playerPiece) {
        score -= 3;
      }
    }

    score += _evaluateLines(state, aiPiece);

    return score;
  }

  static int _evaluateLines(ConnectFourState state, CellState aiPiece) {
    int score = 0;
    final playerPiece = aiPiece.opposite;

    for (int r = 0; r < ConnectFourState.rows; r++) {
      for (int c = 0; c <= ConnectFourState.cols - ConnectFourState.connectCount; c++) {
        score += _evaluateWindow(state, r, c, 0, 1, aiPiece, playerPiece);
      }
    }

    for (int c = 0; c < ConnectFourState.cols; c++) {
      for (int r = 0; r <= ConnectFourState.rows - ConnectFourState.connectCount; r++) {
        score += _evaluateWindow(state, r, c, 1, 0, aiPiece, playerPiece);
      }
    }

    for (int r = 0; r <= ConnectFourState.rows - ConnectFourState.connectCount; r++) {
      for (int c = 0; c <= ConnectFourState.cols - ConnectFourState.connectCount; c++) {
        score += _evaluateWindow(state, r, c, 1, 1, aiPiece, playerPiece);
      }
    }

    for (int r = 0; r <= ConnectFourState.rows - ConnectFourState.connectCount; r++) {
      for (int c = ConnectFourState.connectCount - 1; c < ConnectFourState.cols; c++) {
        score += _evaluateWindow(state, r, c, 1, -1, aiPiece, playerPiece);
      }
    }

    return score;
  }

  static int _evaluateWindow(
    ConnectFourState state,
    int startRow,
    int startCol,
    int dr,
    int dc,
    CellState aiPiece,
    CellState playerPiece,
  ) {
    int aiCount = 0;
    int playerCount = 0;
    int emptyCount = 0;

    for (int i = 0; i < ConnectFourState.connectCount; i++) {
      final r = startRow + dr * i;
      final c = startCol + dc * i;
      final cell = state.board[r][c];
      if (cell == aiPiece) {
        aiCount++;
      } else if (cell == playerPiece) {
        playerCount++;
      } else {
        emptyCount++;
      }
    }

    if (aiCount > 0 && playerCount > 0) return 0;

    if (aiCount == 4) return 100000;
    if (aiCount == 3 && emptyCount == 1) return 100;
    if (aiCount == 2 && emptyCount == 2) return 10;

    if (playerCount == 4) return -100000;
    if (playerCount == 3 && emptyCount == 1) return -120;
    if (playerCount == 2 && emptyCount == 2) return -10;

    return 0;
  }
}
