import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:minigames/styles.dart';
import 'package:minigames/widgets/dropdown.dart';

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

  List<_HitAndBlowItemWidget> items = List.empty(growable: true);

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
                DropdownWidget(children: [], title: S.of(context).leaderboard),
                margin,
                MaterialButton(
                  onPressed: () => {
                    setState(() {
                      if (notShowGame) notShowGame = false;
                      _engine = HitAndBlowEngine(4, allowDuplicate);
                      finished = false;
                      items.add(_HitAndBlowItemWidget(
                        balls: _engine.balls,
                      ));
                    })
                  },
                  child: Text(S.of(context).start_game),
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
                      Column(
                        children: items,
                      )
                    ],
                  ),
                )
              ]),
        )),
      );
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
    var allRight = List.empty();
    var halfRight = List.empty();
    var map = Map.of(stats);
    for (var i = 0; i < balls; i++) {
      if (map.containsKey(candidate[i]) &&
          map[candidate[i]]! > 0 &&
          candidate[i] == answer[i]) {
        map[candidate[i]] = map[candidate]! - 1;
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

class _HitAndBlowItemWidget extends StatefulWidget {
  final int balls;

  const _HitAndBlowItemWidget({Key? key, required this.balls})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _HitAndBlowItemState();
}

class _HitAndBlowItemState extends State<_HitAndBlowItemWidget> {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text("done")
          // VerificationBox(
          //   count: widget.balls,
          //   borderColor: Colors.grey,
          //   focusBorderColor: Colors.blue,
          //   borderWidth: 3,
          //   borderRadius: 50,
          // )
        ],
      );
}
