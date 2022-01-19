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
              diceColor: Theme.of(context).colorScheme.background,
              count: widget.count),
        ),
      );
}

class _DicePainter extends CustomPainter {
  DiceCount count;
  Color diceColor;

  _DicePainter(
      {required this.count,
      required this.diceColor})
      : super();

  @override
  void paint(Canvas canvas, Size size) {
    print(count);
    var dicePainter = Paint()
      ..color = diceColor
      ..strokeWidth = 0.0
      ..isAntiAlias = true;
    switch (count) {
      case 1:
        {
          canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.height / 6, dicePainter);
        }
        break;
      case 2:
      {
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height / 4), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height *3 / 4), size.height / 8, dicePainter);
      }
      break;
      case 3:
      {
          canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height / 4), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height *3 / 4), size.height / 8, dicePainter);
      }
      break;
      case 4:
      {
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height / 4), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height *3 / 4), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height *3/ 4), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height  / 4), size.height / 8, dicePainter);
      }
      break;
      case 5:
      {
          canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height / 4), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height *3 / 4), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height *3/ 4), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height  / 4), size.height / 8, dicePainter);
      }
      break;
      case 6:
      {
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height / 2), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height / 2), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height * 3 / 16), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height *13 / 16), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width * 3 / 4, size.height *13/ 16), size.height / 8, dicePainter);
          canvas.drawCircle(Offset(size.width / 4, size.height  * 3 / 16), size.height / 8, dicePainter);
      }
      break;
      default:
      {
        canvas.drawCircle(Offset(size.width / 4, size.height / 2), size.height / 6, dicePainter);
        canvas.drawCircle(Offset(size.width / 4, size.height / 2), size.height / 6, dicePainter);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
