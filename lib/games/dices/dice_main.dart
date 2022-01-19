import 'package:flutter/material.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:minigames/styles.dart';
import 'package:minigames/widgets/dropdown.dart';

class DiceGamePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState()  => _DiceGameState();
}

class _DiceGameState extends State<DiceGamePage> {
  bool finished = true;
  bool notShowGame = true;

  @override
  Widget build(BuildContext context)  => Scaffold(
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
                
              ),
            )
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
        onPressed: onPressed(),
        label: Text(finished
            ? S.of(context).start_game
            : S.of(context).restart_game)),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );


  VoidCallback onPressed() => () {
    setState(() {
    });
  };
}