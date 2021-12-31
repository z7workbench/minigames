import 'dart:math';

class Block {
  Status _status = Status.none;
  int _value = 0;

  changeToMine() => _value = -1;
  inc() => ++_value;
  changeStatus(Status s) => _status = s;
  Status getStatus() => _status;
  bool isBoom() => _value < 0;
}

enum Status {
  none, opened, flagged, unknown
}

class MineField {
  late int x, y, mineSize;
  late List<List<Block>> field;

  MineField(int mineSize, this.x, this.y) {
    field = List.filled(x, List.filled(y, Block()));
    setMines(mineSize);
  }

  setMines(int mineSize) {
    var mines = List.empty(growable: true);
    var random = Random();
    for (var i = 0; i < 5; i++) {
      int ranX = -1;
      int ranY = -1;
      do {
        ranX = random.nextInt(x);
        ranY = random.nextInt(y);
      } while(mines.contains("$ranX,$ranY"));
      mines.add("$ranX,$ranY");
      field[ranX][ranY].changeToMine();
      setHint(ranX, ranY);
    }
  }

  setHint(int x, int y) {
    var directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]];
    for (var d in directions) {
      int subX = d[0] + x;
      int subY = d[1] + y;
      if (subX >= 0 && subX < x && subY >= 0 && subY < y) {
        field[subX][subY].inc();
      }
    }
  }
}