import 'dart:math';
import 'package:flutter/material.dart';
import 'package:minigames/games/dices/dice.dart';
import 'package:minigames/games/dices/dice_engine.dart';
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
  bool finished = true;
  bool notShowGame = true;

  List<Widget> diceTitle(BuildContext context) => [
        shell(
            context,
            Text(
              "",
              style: regularBoldStyle,
            )),
        shell(
            context,
            Text(
              "1",
              style: regularTextStyle,
            )),
        shell(
            context,
            Text(
              "2",
              style: regularTextStyle,
            )),
        shell(
            context,
            Text(
              "3",
              style: regularTextStyle,
            )),
        shell(
            context,
            Text(
              "4",
              style: regularTextStyle,
            )),
        shell(
            context,
            Text(
              "5",
              style: regularTextStyle,
            )),
        shell(
            context,
            Text(
              "6",
              style: regularTextStyle,
            )),
        shell(
            context,
            Text(
              "quan",
              style: regularTextStyle,
            )),
        shell(
            context,
            Text(
              "si",
              style: regularTextStyle,
            )),
        shell(
            context,
            Text(
              "hu",
              style: regularTextStyle,
            )),
        shell(
            context,
            Text(
              "xiao",
              style: regularTextStyle,
            )),
        shell(
            context,
            Text(
              "da",
              style: regularTextStyle,
            )),
        shell(
            context,
            Text(
              "kuai",
              style: regularTextStyle,
            ))
      ];

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                // This is likely caused by an event handler (like a button's onPressed) that called
                                // Provider.of without passing `listen: false`.
                                Provider.of<DiceNotifier>(context,
                                        listen: false)
                                    .rollingDice();
                              },
                              child: Text("Roll " +
                                  Provider.of<DiceNotifier>(context)
                                      .times
                                      .toString()),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                child: Row(
                                  children: [
                                        Column(
                                          children: diceTitle(context),
                                        )
                                      ] +
                                      List.generate(
                                          Provider.of<DiceNotifier>(context)
                                              .size,
                                          (player) => Column(
                                                children: [
                                                      shell(
                                                          context,
                                                          Text(
                                                            "P${player + 1}",
                                                            style:
                                                                regularBoldStyle,
                                                          ))
                                                    ] +
                                                    List.generate(
                                                        12,
                                                        (index) =>
                                                            generateSheetCell(
                                                                context,
                                                                player,
                                                                index)),
                                              )),
                                ))
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: onPressed(),
              label: Text(finished
                  ? S.of(context).start_game
                  : S.of(context).restart_game)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      );

  VoidCallback onPressed() => () {
        setState(() {
          if (notShowGame) notShowGame = false;
        });
      };

  Widget shell(BuildContext context, Text child,
          {GestureTapCallback? onTap, GestureTapCallback? onDoubleTap}) =>
      GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        child: Container(
          padding: containerXSPadding,
          // decoration: BoxDecoration(
          //   border: Border.all(
          //       width: 2.0, color: Theme.of(context).colorScheme.onBackground),
          // ),
          child: child,
        ),
      );

  Widget generateSheetCell(BuildContext context, int player, int index) {
    int board = Provider.of<DiceNotifier>(context).engine.board[player][index];
    int predict = Provider.of<DiceNotifier>(context).engine.predict[index];
    int currentPlayer = Provider.of<DiceNotifier>(context).engine.currentPlayer;

    if (board >= 0) {
      return shell(
          context,
          Text(
            "$board",
            style: regularTextStyle,
          ));
    } else if (predict >= 0 && player == currentPlayer) {
      return shell(
          context,
          Text(
            "$predict",
            style: regularHintTextStyle,
          ));
    } else {
      return shell(
          context,
          const Text(
            "  ",
            style: regularTextStyle,
          ));
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
              count: index,
              keepAction: (i) => keep(i),
              discardAction: (i) => discard(i),
            ));
    locked = [];
    times = 3;
    dices = List.empty();
    notifyListeners();
  }

  rollingDice() {
    if (times > 0) {
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
    }
    notifyListeners();
  }

  keep(GesturedDiceWidget dice) {
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
}
