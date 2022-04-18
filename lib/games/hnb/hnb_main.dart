import 'package:flutter/material.dart';
import 'package:minigames/games/hnb/hnb_leaderboard.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:minigames/styles.dart';
import 'package:minigames/utils/hive_utils.dart';
import 'package:minigames/widgets/dropdown.dart';
import 'package:minigames/games/hnb/hnb_boards.dart';
import 'package:minigames/games/hnb/hnb_engine.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  late HiveUtil hive;

  List<Widget> items = [];
  int start = 0;

  @override
  void initState() {
    hive = HiveUtil();
    super.initState();
  }

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
                  children: [
                    Padding(
                      child: MaterialButton(
                        onPressed: () {
                          hive.hnbLeaderboardBox.clear();
                        },
                        child: Text(S.of(context).clean_leaderboard),
                      ),
                      padding: containerXSPadding,
                    ),
                    content
                  ],
                  title: S.of(context).leaderboard,
                ),
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
                                style: regularBoldStyle,
                              ),
                              margin,
                              Text(
                                answerText,
                                style: regularTextStyle,
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
                bottomBlank
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
          start = DateTime.now().millisecondsSinceEpoch;
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
            saveToHive();
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

  saveToHive() {
    var now = DateTime.now().millisecondsSinceEpoch;
    hive.hnbLeaderboardBox
        .add(HnbLeaderboardItem(now: now, usedTime: now - start, count: times));
  }

  Widget get content {
    if (hive.hnbLeaderboardBox.isEmpty) {
      return Container(
        child: Text(S.of(context).empty_leaderboard, style: regularTextStyle),
        alignment: Alignment.center,
      );
    }

    return ValueListenableBuilder(
      valueListenable: hive.hnbLeaderboardBox.listenable(),
      builder: (context, Box leaderboard, _) {
        if (leaderboard.keys.isEmpty) {
          return Container(
            child: Text(S.of(context).empty_leaderboard, style: regularTextStyle,),
            alignment: Alignment.center,
          );
        }

        var items = leaderboard.values.toList();
        items.sort((a, b) => a.count.compareTo(b.count));
        return DataTable(
          columns: [
            DataColumn(label: Text(S.of(context).hnb_when_finished)),
            DataColumn(label: Text(S.of(context).hnb_used_time)),
            DataColumn(label: Text(S.of(context).hnb_hit), numeric: true)
          ],
          rows: [
            for (var item in items)
              DataRow(
                cells: [
                  DataCell(Text(DateTime.fromMillisecondsSinceEpoch(item.now)
                      .toString())),
                  DataCell(
                      Text(Duration(milliseconds: item.usedTime).toString())),
                  // DataCell(Text(item.usedTime.toString())),
                  DataCell(Text(item.count.toString())),
                ],
              )
          ],
          sortColumnIndex: 2,
          sortAscending: false,
        );
      },
    );
  }
}
