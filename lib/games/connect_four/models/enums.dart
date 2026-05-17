enum CellState { empty, player, ai }

enum GamePhase { idle, playing, animating, gameOver }

enum AiDifficulty { easy, medium, hard }

enum GameResult { none, playerWin, aiWin, draw }

extension CellStateExtension on CellState {
  int get value {
    switch (this) {
      case CellState.empty:
        return 0;
      case CellState.player:
        return 1;
      case CellState.ai:
        return 2;
    }
  }

  CellState get opposite {
    switch (this) {
      case CellState.empty:
        return CellState.empty;
      case CellState.player:
        return CellState.ai;
      case CellState.ai:
        return CellState.player;
    }
  }

  static CellState fromValue(int v) {
    switch (v) {
      case 1:
        return CellState.player;
      case 2:
        return CellState.ai;
      default:
        return CellState.empty;
    }
  }
}

extension AiDifficultyExtension on AiDifficulty {
  String get depthLabel {
    switch (this) {
      case AiDifficulty.easy:
        return '1';
      case AiDifficulty.medium:
        return '4';
      case AiDifficulty.hard:
        return '6';
    }
  }
}
