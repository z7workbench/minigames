import 'package:minigames/games/dices/dice.dart';

typedef Dices = List<DiceCount>;

class DiceEngine {
  int size;

  // each element in `board` is a 12-size int List initialized with -1
  late List<List<int>> board;
  late List predict;
  late List totals;
  late List bonus;
  late List<int> stats;

  int currentPlayer = 0;

  DiceEngine({required this.size}) {
    board = List.generate(size, (_) => List.generate(12, (_) => -1));
    predict = List.generate(12, (_) => -1);
    totals = List.generate(size, (index) => 0);
    bonus = List.generate(size, (index) => false);
    stats = List.generate(6, (index) => 0);
  }

  confirmPredict(int index) {
    board[currentPlayer][index] = predict[index];
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      if (board[currentPlayer][i] > 0) {
        sum += board[currentPlayer][i];
      }
    }
    bonus[currentPlayer] = checkBonus();
    if (bonus[currentPlayer]) {
      sum += 35;
    }
    totals[currentPlayer] = sum;
    if (++currentPlayer >= board.length) {
      currentPlayer = 0;
    }
    predict = List.generate(12, (i) => board[currentPlayer][i]);
  }

  bool checkBonus() {
    int sum = 0;
    for (int i = 0; i < 6; i++) {
      if (board[currentPlayer][i] >= 0) {
        sum += board[currentPlayer][i];
      }
    }
    if (sum >= 63) {
      return true;
    } else {
      return false;
    }
  }

  updatePredict(Dices dices) {
    stats = List.generate(6, (index) => 0);
    for (DiceCount dice in dices) {
      stats[dice - 1] += 1;
    }

    for (int i = 0; i < 12; i++) {
      switch (i) {
        case 6:
          {
            predict[i] = sumDices(dices);
          }
          break;
        case 7:
          {
            if (stats.indexOf(4) > 0 || stats.indexOf(5) > 0) {
              predict[i] = sumDices(dices);
            } else {
              predict[i] = 0;
            }
          }
          break;
        case 8:
          {
            if (stats.indexOf(3) > 0 && stats.indexOf(2) > 0) {
              predict[i] = sumDices(dices);
            } else {
              predict[i] = 0;
            }
          }
          break;
        case 9:
          {
            if (stats[0] > 0 && stats[1] > 0 && stats[2] > 0 && stats[3] > 0) {
              predict[i] = 15;
            } else if (stats[4] > 0 &&
                stats[1] > 0 &&
                stats[2] > 0 &&
                stats[3] > 0) {
              predict[i] = 15;
            } else if (stats[4] > 0 &&
                stats[5] > 0 &&
                stats[2] > 0 &&
                stats[3] > 0) {
              predict[i] = 15;
            } else {
              predict[i] = 0;
            }
          }
          break;
        case 10:
          {
            if (stats[0] > 0 &&
                stats[1] > 0 &&
                stats[2] > 0 &&
                stats[3] > 0 &&
                stats[4] > 0) {
              predict[i] = 30;
            } else if (stats[5] > 0 &&
                stats[1] > 0 &&
                stats[2] > 0 &&
                stats[3] > 0 &&
                stats[4] > 0) {
              predict[i] = 30;
            } else {
              predict[i] = 0;
            }
          }
          break;
        case 11:
          {
            if (stats.indexOf(5) > 0) {
              predict[i] = 50;
            } else {
              predict[i] = 0;
            }
          }
          break;
        default:
          predict[i] = stats[i] * (i + 1);
      }
    }
  }

  int sumDices(Dices dices) {
    int c = 0;
    for (DiceCount dice in dices) {
      c += dice;
    }
    return c;
  }
}
