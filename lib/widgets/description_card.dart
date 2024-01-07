import 'package:flutter/material.dart';
import 'package:minigames/styles.dart';

class DescriptionCard extends StatelessWidget {
  const DescriptionCard(
      {super.key, required this.title, required this.desc, required this.goto});

  final String title;
  final String desc;
  final Widget goto;

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: largeTextStyle,
              textAlign: TextAlign.center,
            ),
            Text(
              desc,
              style: docTextStyle,
            )
          ],
        ),
        onTapUp: (_) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => goto));
        },
      );
}
