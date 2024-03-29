import 'package:flutter/material.dart';
import 'package:minigames/games/hnb/hnb_engine.dart';
import 'package:minigames/styles.dart';
import 'package:minigames/generated/l10n.dart';

class CheckBoard extends StatefulWidget {
  const CheckBoard(
      {super.key,
      this.count = 4,
      this.borderWidth = 2.0,
      this.borderRadius = 25.0,
      required this.times,
      required this.borderColor,
      required this.finished});

  final int times;
  final int count;
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;
  final ValueChanged finished;

  @override
  State<StatefulWidget> createState() => _CheckBoardState();
}

class _CheckBoardState extends State<CheckBoard> {
  final List<int> _contentList = [];

  List get content => _contentList;
  final List<int> _candidates = [];
  double dragDelta = 0.0;

  @override
  void initState() {
    List.generate(widget.count, (index) {
      _contentList.add(0);
    });
    List.generate(widget.count + 2 + 1, (index) {
      _candidates.add(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          border:
              Border.all(color: widget.borderColor, width: widget.borderWidth),
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius))),
      child: Padding(
        padding: containerSmallPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Try: ${widget.times}"),
                margin,
                ElevatedButton(
                  onPressed: () => {widget.finished(_contentList)},
                  child: Text(S.of(context).check),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                  widget.count,
                  (index) => Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: GestureDetector(
                          child: DropdownButton<int>(
                            icon: const Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                            onChanged: (value) {
                              setState(() {
                                _contentList[index] = value ?? 0;
                              });
                            },
                            value: _contentList[index],
                            items: _candidates
                                .map((e) => DropdownMenuItem<int>(
                                      value: e,
                                      child: Text(
                                        e.toString(),
                                        style: regularTextStyle,
                                      ),
                                    ))
                                .toList(),
                          ),
                          onVerticalDragEnd: (_) {
                            setState(() {
                              dragDelta = 0.0;
                            });
                          },
                          onVerticalDragUpdate: (details) {
                            setState(() {
                              dragDelta += details.delta.dy;
                              if (dragDelta >= 12.0) {
                                _contentList[index] =
                                    _contentList[index] + 1 <= widget.count + 2
                                        ? _contentList[index] + 1
                                        : widget.count + 2;
                                dragDelta = 0.0;
                              }
                              if (dragDelta < -12.0) {
                                _contentList[index] =
                                    _contentList[index] - 1 >= 0
                                        ? _contentList[index] - 1
                                        : 0;
                                dragDelta = 0.0;
                              }
                            });
                          },
                        ),
                      )),
            )
          ],
        ),
      ));
}

class ResultBoard extends StatefulWidget {
  const ResultBoard(
      {super.key,
      this.borderWidth = 2.0,
      this.borderRadius = 25.0,
      required this.times,
      required this.borderColor,
      required this.result,
      required this.match});

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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Try: ${widget.times}"),
            margin,
            Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.match.join(" ")),
                  margin,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                            widget.result.allCorrect,
                            (index) => const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                )) +
                        List.generate(
                            widget.result.halfCorrect,
                            (index) =>
                                const Icon(Icons.done, color: Colors.grey)),
                  )
                ])
          ],
        ),
      ));
}
