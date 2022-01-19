import 'package:flutter/material.dart';

typedef DiceCount = int;

class DiceWidget extends StatefulWidget {
  DiceWidget(
      {Key? key,
      this.size = 10.0,
      this.borderSize = 3.0,
      this.radius = 1.5,
      required this.count})
      : super(key: key);

  double size;
  double borderSize;
  double radius;
  DiceCount count;

  @override
  State<StatefulWidget> createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget> {
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            border: Border.all(width: widget.borderSize),
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          ),
  );
}