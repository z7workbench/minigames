import 'package:flutter/material.dart';

const suits = ["♠", "♣", "♥", "♦", "🃏"];

typedef Poker = String;

class PokerCard extends StatefulWidget {
  PokerCard(
      {Key? key,
      this.size = 10.0,
      this.selectedColor = Colors.amber,
      this.normalColor = Colors.blue,
      this.textColor = Colors.black,
      this.borderSize = 3.0,
      required this.poker})
      : super(key: key);

  double size;
  Color selectedColor;
  Color normalColor;
  Color textColor;
  double borderSize;
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
          ),
          child: Text(
            widget.poker,
            style: TextStyle(
                color: widget.textColor, fontSize: widget.size * 2 - 5),
          ),
        ),
        onTap: () => {
          setState(() {
            selected = !selected;
          })
        },
      );
}
