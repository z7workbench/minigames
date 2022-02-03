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
                            Text("deck"),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    Provider.of<DiceNotifier>(context).roll),
                            Text("reserve"),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:
                                    Provider.of<DiceNotifier>(context).locked),
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
}

class DiceNotifier with ChangeNotifier {
  late List<GesturedDiceWidget> locked;
  late List<GesturedDiceWidget> roll;
  late DiceEngine engine;
  late int size;

  DiceNotifier({this.size = 2}) {
    reset(size);
  }

  reset(int size) {
    roll = List.generate(
        5,
        (index) => GesturedDiceWidget(
              count: index,
              keepAction: (i) => keep(i),
              discardAction: (i) => discard(i),
            ));
    locked = [];
    engine = DiceEngine(size: size);
  }

  rollingDice() {
    var random = Random();
    for (GesturedDiceWidget widget in roll) {
      widget.count = random.nextInt(6) + 1;
    }
    notifyListeners();
  }

  keep(GesturedDiceWidget dice) {
    roll.remove(dice);
    locked.add(dice);
    notifyListeners();
  }

  discard(GesturedDiceWidget dice) {
    locked.remove(dice);
    roll.add(dice);
    notifyListeners();
  }
}
