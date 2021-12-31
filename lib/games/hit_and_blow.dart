import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:minigames/styles.dart';

class HitAndBlowHome extends StatefulWidget {
  const HitAndBlowHome({Key? key}) : super(key: key);

  @override
  State<HitAndBlowHome> createState() => _HitAndBlowState();
}

class _HitAndBlowState extends State<HitAndBlowHome> {
  var descVisiable = false;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(S.of(context).hnb_title)),
      body: Center(
          child: Padding(
        padding: containerPadding,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                child: Column(
                  children: [
                    Text(
                      S.of(context).description,
                      style: titleTextStyle,
                    ),
                    Offstage(
                      offstage: descVisiable,
                      child: Text(
                        S.of(context).hnb_desc,
                        style: docTextStyle,
                      ),
                    )
                  ],
                ),
                onTapUp: (_) {
                  if (descVisiable) {
                    setState(() {
                      descVisiable = false;
                    });
                  } else {
                    setState(() {
                      descVisiable = true;
                    });
                  }
                },
              ),
              MaterialButton(
                onPressed: () => {},
                child: Text(S.of(context).start_game),
              ),
              MaterialButton(
                onPressed: () => {},
                child: Text(S.of(context).leaderboard),
              ),
            ]),
      )));
}

class HitAndBlowEngine {
  bool allowDuplicate = false;
  int balls = 4;
  List<Color> answer = List.empty();
  List<Color> basicColors = List.from([
    Colors.blue,
    Colors.deepOrange,
    Colors.orange,
    Colors.teal,
    Colors.purple,
    Colors.grey
  ]);
  HashMap<Color, int> stats = HashMap();

  HitAndBlowEngine(this.balls, this.allowDuplicate) {
    var random = Random();
    var color = Colors.black;
    for (var i = 0; i < balls; i++) {
      do {
        var index = random.nextInt(basicColors.length);
        color = basicColors[index];
      } while (!allowDuplicate && answer.contains(color));
      answer.add(color);
      if (stats.containsKey(color)) {
        stats[color] = stats[color]! + 1;
      } else {
        stats[color] = 1;
      }
    }
  }

  HitAndBlowResult check(List<Color> candidate) {
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
