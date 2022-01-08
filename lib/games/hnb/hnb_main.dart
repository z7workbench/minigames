import 'package:flutter/material.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:minigames/styles.dart';
import 'package:minigames/widgets/dropdown.dart';
import 'package:minigames/games/hnb/hnb_boards.dart';
import 'package:minigames/games/hnb/hnb_engine.dart';

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
  String answerText = hnbPlaceholder;
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
                AnimatedOpacity(
                    opacity: notShowGame ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Offstage(
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
                          margin,
                          Wrap(
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8.0,
                            runSpacing: 4.0,
                            alignment: WrapAlignment.start,
                            children: items,
                          )
                        ],
                      ),
                    )),
              ]),
        )),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: onPressed(),
            label: Text(finished
                ? S.of(context).start_game
                : S.of(context).restart_game)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );

  VoidCallback onPressed() => () {
        setState(() {
          if (notShowGame) notShowGame = false;
          answerText = hnbPlaceholder;
          _engine = HitAndBlowEngine(4, allowDuplicate);
          finished = false;
          times = 1;
          items.clear();
          items.add(addCodeBoard());
        });
      };

  CheckBoard addCodeBoard() {
    return CheckBoard(
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
