import 'package:minigames/games/dices/dice.dart';

typedef Dices = List<DiceCount>;

class DiceEngine {
  int size;

  // each element in `board` is a 12-size int List initialized with -1
  late List<List<int>> board;
  late List predict;
  int currentPlayer = 0;

  DiceEngine({required this.size}) {
    board = List.generate(size, (_) => List.generate(12, (_) => -1));
    predict = List.generate(12, (_) => -1);
  }

  changePlayer(int index) {
    predict = List.generate(12, (i) => board[index][i]);
    currentPlayer = index;
  }

  updatePredict(Dices dices) {
    var stats = List.generate(6, (index) => 0);

    for (DiceCount dice in dices) {
      stats[dice] += 1;
    }

    for (int i = 0; i < 12; i++) {
      switch (i) {
        case 6:
          {
            if (stats.indexOf(4) > 0 || stats.indexOf(5) > 0) {
              predict[i] = sumDices(dices);
            } else {
              predict[i] = 0;
            }
          }
          break;
        case 7:
          {

          }
          break;
        default:
          predict[i] = stats[i];
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