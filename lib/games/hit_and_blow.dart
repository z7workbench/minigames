import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:minigames/styles.dart';
import 'package:minigames/widgets/codeboard.dart';
import 'package:minigames/widgets/dropdown.dart';
import 'package:minigames/widgets/result_board.dart';

class HitAndBlowHome extends StatefulWidget {
  const HitAndBlowHome({Key? key}) : super(key: key);

  @override
  State<HitAndBlowHome> createState() => _HitAndBlowState();
}

class _HitAndBlowState extends State<HitAndBlowHome> {
  bool allowDuplicate = false;
  late HitAndBlowEngine _engine;
  bool notShowGame = true;
  bool finished = true;
  String answerText = "x x x x";
  int times = 1;
  List results = [];

  List<Widget> items = [];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(S.of(context).hnb_title)),
        body: SingleChildScrollView(
            child: Padding(
          padding: containerPadding,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                DropdownWidget(children: [
                  Text(
                    S.of(context).hnb_desc,
                    style: docTextStyle,
                  ),
                ], title: S.of(context).description),
                margin,
                DropdownWidget(
                    children: const [], title: S.of(context).leaderboard),
                margin,
                MaterialButton(
                  onPressed: () => {
                    setState(() {
                      if (notShowGame) notShowGame = false;
                      _engine = HitAndBlowEngine(4, allowDuplicate);
                      finished = false;
                      times = 1;
                      items.clear();
                      items.add(addCodeBoard());
                    })
                  },
                  child: Text(finished
                      ? S.of(context).start_game
                      : S.of(context).restart_game),
                ),
                margin,
                Offstage(
                  offstage: notShowGame,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            S.of(context).hnb_answer,
                            textAlign: TextAlign.start,
                            style: subtitleTextStyleRed,
                          ),
                          margin,
                          Text(
                            answerText,
                            style: subtitleTextStyleBlack,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 8.0,
                        runSpacing: 4.0,
                        alignment: WrapAlignment.start,
                        children: items,
                      )
                    ],
                  ),
                )
              ]),
        )),
      );

  CodeBoard addCodeBoard() {
    return CodeBoard(
      times: times,
      count: _engine.balls,
      borderColor: Colors.blue,
      borderWidth: 3,
      finished: (value) {
        if (!value.contains(0)) {
          var result = _engine.check(value);
          results.add(result);
          if (result.allCorrect == _engine.balls) {
            finished = true;
            answerText = _engine.answer.join(" ");
            setState(() {
              items.removeLast();
              items.add(addResultBoard(result, value));
            });
          } else {
            setState(() {
              items.removeLast();
              items.add(addResultBoard(result, value));
              times++;
              items.add(addCodeBoard());
            });
          }
        }
      },
    );
  }

  ResultBoard addResultBoard(HitAndBlowResult result, List<int> match) {
    return ResultBoard(
      times: times,
      borderColor: Colors.grey,
      result: result,
      match: match,
    );
  }
}

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
