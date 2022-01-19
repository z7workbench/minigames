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
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(width: widget.borderSize, color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
        ),
        child: CustomPaint(
          size: const Size(48.0, 48.0),
          painter: _DicePainter(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              diceColor: Theme.of(context).colorScheme.background,
              count: 1),
        ),
      );
}

class _DicePainter extends CustomPainter {
  var count = 1;
  Color backgroundColor;
  Color diceColor;

  _DicePainter(
      {required this.count,
      required this.backgroundColor,
      required this.diceColor})
      : super();

  @override
  void paint(Canvas canvas, Size size) {
    var dicePainter = Paint()
      ..color = diceColor
      ..strokeWidth = 0.0
      ..isAntiAlias = true;
    var bgPainter = Paint()
      ..color = backgroundColor
      ..strokeWidth = 0.0
      ..isAntiAlias = true;
    switch (count) {
      case 1:
        {
          // canvas.drawRect(Rect.fromLTRB(0.0, 0.0, size.width, size.height), bgPainter);
          canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.height / 4, dicePainter);
        }
        break;
      default:
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
