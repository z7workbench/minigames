import 'dart:math';
import 'package:flutter/material.dart';
import 'package:minigames/games/dices/dice.dart';
import 'package:minigames/games/dices/yacht/yacht_dice_engine.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:minigames/styles.dart';
import 'package:minigames/widgets/dropdown.dart';
import 'package:provider/provider.dart';

class DiceGamePage extends StatefulWidget {
  const DiceGamePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DiceGameState();
}

class _DiceGameState extends State<DiceGamePage> {
  bool notShowGame = true;

  @override
  Widget build(BuildContext buildContext) =>
      ChangeNotifierProvider<DiceNotifier>(
        create: (_) => DiceNotifier(),
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: Text(S.of(context).dice_game_title)),
          body: SingleChildScrollView(
            child: Padding(
              padding: containerPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DropdownWidget(children: [
                    Text(
                      S.of(context).dice_game_desc,
                      style: docTextStyle,
                    ),
                  ], title: S.of(context).description),
                  margin,
                  AnimatedOpacity(
                      opacity: notShowGame ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 500),
                      child: Offstage(
                        offstage: notShowGame,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                // This is likely caused by an event handler (like a button's onPressed) that called
                                // Provider.of without passing `listen: false`.
                                Provider.of<DiceNotifier>(context,
                                        listen: false)
                                    .rollingDice();
                              },
                              child: Text(Provider.of<DiceNotifier>(context)
                                      .times
                                      .toString() +
                                  S.of(context).dice_times),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    S.of(context).dice_deck,
                                    style: regularTextStyle,
                                  ),
                                  Row(
                                      children:
                                          Provider.of<DiceNotifier>(context)
                                              .roll),
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).dice_reserve,
                                  style: regularTextStyle,
                                ),
                                Row(
                                  children:
                                      Provider.of<DiceNotifier>(context).locked,
                                )
                              ],
                            ),
                            // result sheet
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: resultSheet(context),
                            ),
                          ],
                        ),
                      )),
                  bottomBlank
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: onPressed(),
              label: Text(S.of(context).start_new_game)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      );

  Widget resultSheet(BuildContext context) {
    var styles = diceStyle(context);
    var descs = diceStyleDesc(context);
    var players = Provider.of<DiceNotifier>(context).size;

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columns: const [DataColumn(label: Text(""))] +
                List.generate(players, (index) {
                  if (Provider.of<DiceNotifier>(context).engine.currentPlayer !=
                      index) {
                    return DataColumn(
                        label: Text(
                      "P$index",
                      style: regularTextStyle,
                    ));
                  } else {
                    return DataColumn(
                        label: Text(
                      "P$index",
                      style: regularBoldStyleUnderline,
                    ));
                  }
                }),
            rows: List.generate(
                    12,
                    (index) => DataRow(
                        cells: [
                              DataCell(
                                Text(styles[index]),
                                onTap: () {
                                  snack(context, descs[index]);
                                },
                              )
                            ] +
                            List.generate(players, (player) {
                              if (Provider.of<DiceNotifier>(context)
                                      .engine
                                      .currentPlayer !=
                                  player) {
                                return DataCell(Text(
                                  showNaturalNumber(
                                      Provider.of<DiceNotifier>(context)
                                          .engine
                                          .board[player][index]),
                                  style: regularTextStyle,
                                ));
                              } else {
                                if (Provider.of<DiceNotifier>(context)
                                        .engine
                                        .board[player][index] >=
                                    0) {
                                  return DataCell(Text(
                                    showNaturalNumber(
                                        Provider.of<DiceNotifier>(context)
                                            .engine
                                            .board[player][index]),
                                    style: regularTextStyle,
                                  ));
                                } else {
                                  return DataCell(
                                    Text(
                                        showNaturalNumber(
                                            Provider.of<DiceNotifier>(context)
                                                .engine
                                                .predict[index]),
                                        style: regularHintTextStyle),
                                    onDoubleTap: () {
                                      if (Provider.of<DiceNotifier>(context,
                                                  listen: false)
                                              .engine
                                              .predict[index] >=
                                          0) {
                                        Provider.of<DiceNotifier>(context,
                                                listen: false)
                                            .result(index);
                                      }
                                    },
                                  );
                                }
                              }
                            }))) +
                [
                  DataRow(
                      cells: [
                            DataCell(
                              Text(styles[12]),
                              onTap: () {
                                snack(context, descs[12]);
                              },
                            )
                          ] +
                          List.generate(players, (player) {
                            if (Provider.of<DiceNotifier>(context)
                                .engine
                                .bonus[player]) {
                              return const DataCell(
                                  Text('+35', style: regularTextStyle));
                            } else {
                              return const DataCell(
                                  Text('+0', style: regularTextStyle));
                            }
                          })),
                  DataRow(
                      cells: [
                            DataCell(
                              Text(styles[13]),
                              onTap: () {
                                snack(context, descs[13]);
                              },
                            )
                          ] +
                          List.generate(
                              players,
                              (player) => DataCell(Text(
                                  Provider.of<DiceNotifier>(context)
                                      .engine
                                      .totals[player]
                                      .toString(),
                                  style: regularTextStyle)))),
                ]));
  }

  VoidCallback onPressed() => () {
        setState(() {
          if (notShowGame) notShowGame = false;
        });
      };

  snack(BuildContext context, String string) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(string),
      action: SnackBarAction(
        label: S.of(context).dismiss,
        onPressed: () {},
      ),
      duration: const Duration(seconds: 1),
    ));
  }

  List<String> diceStyle(BuildContext context) => [
        S.of(context).dice_aces,
        S.of(context).dice_deuces,
        S.of(context).dice_threes,
        S.of(context).dice_fours,
        S.of(context).dice_fives,
        S.of(context).dice_sixes,
        S.of(context).dice_choice,
        S.of(context).dice_4_of_kind,
        S.of(context).dice_full_house,
        S.of(context).dice_s_straight,
        S.of(context).dice_l_straight,
        S.of(context).dice_yacht,
        S.of(context).dice_bonus,
        S.of(context).dice_total,
      ];

  List<String> diceStyleDesc(BuildContext context) => [
        S.of(context).dice_aces_desc,
        S.of(context).dice_deuces_desc,
        S.of(context).dice_threes_desc,
        S.of(context).dice_fours_desc,
        S.of(context).dice_fives_desc,
        S.of(context).dice_sixes_desc,
        S.of(context).dice_choice_desc,
        S.of(context).dice_4_of_kind_desc,
        S.of(context).dice_full_house_desc,
        S.of(context).dice_s_straight_desc,
        S.of(context).dice_l_straight_desc,
        S.of(context).dice_yacht_desc,
        S.of(context).dice_bonus_desc,
        S.of(context).dice_total_desc,
      ];

  showNaturalNumber(int i) {
    if (i >= 0) {
      return i.toString();
    } else {
      return "";
    }
  }
}

class DiceNotifier with ChangeNotifier {
  late List<GesturedDiceWidget> locked;
  late List<GesturedDiceWidget> roll;
  late DiceEngine engine;
  late Dices dices;
  int size;
  int times;

  DiceNotifier({this.size = 2, this.times = 3}) {
    reset(size);
  }

  reset(int size) {
    softReset();
    engine = DiceEngine(size: size);
    notifyListeners();
  }

  softReset() {
    roll = List.generate(
        5,
        (index) => GesturedDiceWidget(
              count: 0,
              keepAction: (i) => keep(i),
              discardAction: (i) => discard(i),
            ));
    locked = [];
    times = 3;
    dices = List.empty();
    notifyListeners();
  }

  rollingDice() {
    if (times > 0 && roll.isNotEmpty) {
      var random = Random();
      int length = roll.length;
      roll.clear();
      roll = List.generate(
          length,
          (index) => GesturedDiceWidget(
                count: random.nextInt(6) + 1,
                keepAction: (i) => keep(i),
                discardAction: (i) => discard(i),
              ));
      dices = List.generate(roll.length, (index) => roll[index].count) +
          List.generate(locked.length, (index) => locked[index].count);
      engine.updatePredict(dices);
      times--;
      notifyListeners();
    }
  }

  keep(GesturedDiceWidget dice) {
    if (dice.count == 0) {
      return;
    }
    roll.remove(dice);
    GesturedDiceWidget widget = GesturedDiceWidget(
      count: dice.count,
      keepAction: dice.keepAction,
      discardAction: dice.discardAction,
      reserve: true,
      size: 30.0,
    );
    locked.add(widget);
    notifyListeners();
  }

  discard(GesturedDiceWidget dice) {
    locked.remove(dice);
    GesturedDiceWidget widget = GesturedDiceWidget(
      count: dice.count,
      keepAction: dice.keepAction,
      discardAction: dice.discardAction,
    );
    roll.add(widget);
    notifyListeners();
  }

  result(int index) {
    engine.confirmPredict(index);
    softReset();
    notifyListeners();
  }
}
