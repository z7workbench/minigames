import 'package:flutter/material.dart';

const suits = ["♠", "♣", "♥", "♦", "🃏"];

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

  bool compare([Poker pre, Poker now]) {
    int index1 = ruleList.indexOf(pre[1]);
    int index2 = ruleList.indexOf(now[1]);
    return index1 < index2 ? true : false;
  }

  bool compare([StraightPokers pre, StraightPokers now]) {
    return compare(pre.end, now.end);
  }
}

class PokerCard extends StatefulWidget {
  PokerCard(
      {Key? key,
      this.size = 10.0,
      this.selectedColor = Colors.amber,
      this.normalColor = Colors.blue,
      this.textColor = Colors.black,
      this.borderSize = 3.0,
      this.orientation = Orientation.landscape,
      this.radius = 1.5,
      required this.poker})
      : super(key: key);

  double size;
  Color selectedColor;
  Color normalColor;
  Color textColor;
  double borderSize;
  double radius;
  Orientation orientation;
  Poker poker;

  @override
  State<StatefulWidget> createState() => _PokerCardState();
}

class _PokerCardState extends State<PokerCard> {
  var selected = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: selected ? widget.selectedColor : widget.normalColor,
            border: Border.all(width: widget.borderSize),
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          ),
          child: widget.orientation == Orientation.landscape
              ? Text(
                  widget.poker,
                  style: TextStyle(
                      color: widget.textColor, fontSize: widget.size * 2 - 5),
                )
              : Column(
                  children: [
                    Text(
                      widget.poker[0],
                      style: TextStyle(
                          color: widget.textColor,
                          fontSize: widget.size * 2 - 5),
                    ),
                    Text(
                      widget.poker[1],
                      style: TextStyle(
                          color: widget.textColor,
                          fontSize: widget.size * 2 - 5),
                    )
                  ],
                ),
        ),
        onTap: () => {
          setState(() {
            selected = !selected;
          })
        },
      );
}
