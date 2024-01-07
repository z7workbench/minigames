import 'package:flutter/material.dart';

typedef DiceCount = int;
typedef MoveAccordingIndex = void Function(GesturedDiceWidget);

class DiceWidget extends StatelessWidget {
  DiceWidget(
      {super.key,
      this.size = 50.0,
      this.borderSize = 3.0,
      this.radius = 1.5,
      this.padding = const EdgeInsets.all(4.0),
      required this.count});

  double size;
  double borderSize;
  double radius;
  EdgeInsets padding;
  DiceCount count;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            border: Border.all(
                width: borderSize,
                color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          child: CustomPaint(
            size: Size(size, size),
            painter: _DicePainter(
                diceColor: Theme.of(context).colorScheme.background,
                count: count),
          ),
        ),
      );
}

class _DicePainter extends CustomPainter {
  DiceCount count;
  Color diceColor;

  _DicePainter({required this.count, required this.diceColor}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    var dicePainter = Paint()
      ..color = diceColor
      ..strokeWidth = 0.0
      ..isAntiAlias = true;
    switch (count) {
      case 1:
        {
          canvas.drawCircle(Offset(size.width / 2, size.height / 2),
              size.height / 6, dicePainter);
        }
        break;
      case 2:
        {
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height / 4),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height * 3 / 4),
              size.height / 8, dicePainter);
        }
        break;
      case 3:
        {
          canvas.drawCircle(Offset(size.width / 2, size.height / 2),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height / 4),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height * 3 / 4),
              size.height / 8, dicePainter);
        }
        break;
      case 4:
        {
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height / 4),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height * 3 / 4),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height * 3 / 4),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height / 4),
              size.height / 8, dicePainter);
        }
        break;
      case 5:
        {
          canvas.drawCircle(Offset(size.width / 2, size.height / 2),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height / 4),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height * 3 / 4),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height * 3 / 4),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height / 4),
              size.height / 8, dicePainter);
        }
        break;
      case 6:
        {
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height / 2),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height / 2),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height * 3 / 16),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height * 13 / 16),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height * 13 / 16),
              size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height * 3 / 16),
              size.height / 8, dicePainter);
        }
        break;
      default:
        {}
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class GesturedDiceWidget extends StatelessWidget {
  GesturedDiceWidget(
      {super.key,
      required this.count,
      required this.keepAction,
      required this.discardAction,
      this.size = 50.0,
      this.reserve = false});

  DiceCount count;
  double size;
  MoveAccordingIndex keepAction;
  MoveAccordingIndex discardAction;
  bool reserve;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          child: DiceWidget(
            count: count,
            padding: EdgeInsets.zero,
            size: size,
          ),
          onTap: () {
            if (reserve) {
              discardAction(this);
            } else {
              keepAction(this);
            }
            //reserve = !reserve; // (maybe) it moves to reserve
          },
        ),
      );
}
