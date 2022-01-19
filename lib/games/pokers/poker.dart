import 'package:flutter/material.dart';

const suits = ["♠", "♣", "♥", "♦", "J"];

typedef Poker = String;

class PairPokers {
  PairPokers({required this.card, required this.count});
  Poker card;
  int count;
}

class StraightPokers {
  StraightPokers({required this.start, required this.end, required this.count});
  Poker start;
  Poker end;
  int count;
}

class SimplePokerRule {
  const SimplePokerRule({required this.ruleList});

  final List<String> ruleList;

  bool compare(Poker pre, Poker now) {
    int index1 = ruleList.indexOf(pre[1]);
    int index2 = ruleList.indexOf(now[1]);
    return index1 < index2 ? true : false;
  }

  // bool compare([StraightPokers pre, StraightPokers now]) {
  //   return compare(pre.end, now.end);
  // }
}

class PokerCard extends StatefulWidget {
  PokerCard(
      {Key? key,
      this.size = 16.0,
      this.borderSize = 1.0,
      this.orientation = Orientation.landscape,
      this.radius = 1.5,
      required this.poker})
      : super(key: key);

  double size;
  double borderSize;
  double radius;
  Orientation orientation;
  Poker poker;

  @override
  State<StatefulWidget> createState() => _PokerCardState();
}

class _PokerCardState extends State<PokerCard> {
  var selected = false;

  bool changeColor() =>
      widget.poker[0] == suits[2] ||
      widget.poker[0] == suits[3] ||
      widget.poker[1] == 'R';

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.secondary
                : (changeColor()
                    ? Colors.deepOrange
                    : Theme.of(context).colorScheme.onBackground),
            border: Border.all(
              width: widget.borderSize,
              color: selected
                  ? Theme.of(context).colorScheme.secondary
                  : (changeColor()
                      ? Colors.deepOrange
                      : Theme.of(context).colorScheme.onBackground),
            ),
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            child: widget.orientation == Orientation.landscape
                ? Text(
                    widget.poker,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: widget.size),
                  )
                : Column(
                    children: [
                      Text(
                        widget.poker[0],
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                            fontSize: widget.size),
                      ),
                      Text(
                        widget.poker[1],
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                            fontSize: widget.size),
                      )
                    ],
                  ),
          ),
        ),
        onTap: () => {
          setState(() {
            selected = !selected;
          })
        },
      );
}
