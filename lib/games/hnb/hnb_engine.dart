import 'dart:collection';
import 'dart:math';

class HitAndBlowEngine {
  bool allowDuplicate;
  int balls;
  List<int> answer = [];
  int numberRange = 6;
  HashMap<int, int> stats = HashMap();

  HitAndBlowEngine(this.balls, this.allowDuplicate) {
    var random = Random();
    var index = -1;
    for (var i = 0; i < balls; i++) {
      do {
        index = random.nextInt(numberRange) + 1;
      } while (!allowDuplicate && answer.contains(index));
      answer.add(index);
      if (stats.containsKey(index)) {
        stats[index] = stats[index]! + 1;
      } else {
        stats[index] = 1;
      }
    }
    numberRange = balls + 2;
  }

  HitAndBlowResult check(List<int> candidate) {
    var allRight = [];
    var halfRight = [];
    var map = Map.of(stats);
    for (var i = 0; i < balls; i++) {
      if (map.containsKey(candidate[i]) &&
          map[candidate[i]]! > 0 &&
          candidate[i] == answer[i]) {
        map[candidate[i]] = map[candidate[i]]! - 1;
        allRight.add(i);
      }
    }

    for (var i = 0; i < balls; i++) {
      if (!allRight.contains(i)) {
        if (map.containsKey(candidate[i]) && map[candidate[i]]! > 0) {
          halfRight.add(i);
        }
      }
    }

    return HitAndBlowResult(allRight.length, halfRight.length);
  }
}

class HitAndBlowResult {
  int allCorrect = 0;
  int halfCorrect = 0;

  HitAndBlowResult(this.allCorrect, this.halfCorrect);
}
