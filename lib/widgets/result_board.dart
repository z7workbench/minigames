import 'package:flutter/material.dart';
import 'package:minigames/games/hit_and_blow.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:minigames/styles.dart';

class ResultBoard extends StatefulWidget {
  const ResultBoard(
      {Key? key,
      this.borderWidth = 2.0,
      this.borderRadius = 25.0,
      required this.times,
      required this.borderColor,
      required this.result,
      required this.match})
      : super(key: key);

  final List<int> match;
  final HitAndBlowResult result;
  final int times;
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;

  @override
  State<StatefulWidget> createState() => _ResultBoardState();
}

class _ResultBoardState extends State<ResultBoard> {
  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          border:
              Border.all(color: widget.borderColor, width: widget.borderWidth),
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius))),
      child: Padding(
        padding: containerPadding,
        child: Column(
          children: [
            Text("try: ${widget.times}"),
            Row(children: [
              Text(widget.match.join(" ")),
              margin,
              Row(
                children: List.generate(
                        widget.result.allCorrect,
                        (index) => const Icon(
                              Icons.done,
                              color: Colors.green,
                            )) +
                    List.generate(widget.result.halfCorrect,
                        (index) => const Icon(Icons.done, color: Colors.grey)),
              )
            ])
          ],
        ),
      ));
}
