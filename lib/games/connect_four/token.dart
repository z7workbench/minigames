import 'package:flutter/material.dart';

class ConnectFourToken extends StatelessWidget {
  const ConnectFourToken({
    Key? key,
    required this.type,
  }) : super(key: key);

  final ConnectFourTokenType type;

  Color get color {
    switch (type) {
      case ConnectFourTokenType.first:
        return Colors.red;
      case ConnectFourTokenType.last:
        return Colors.blue;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(width: 30.0, color: color),
          borderRadius: BorderRadius.circular(50),
        ),
        width: 30,
        height: 30,
      );
}

enum ConnectFourTokenType {
  first,
  last,
  none,
}