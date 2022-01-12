import 'package:flutter/material.dart';
import 'package:minigames/styles.dart';

class DescriptionCard extends StatelessWidget {
  const DescriptionCard(
      {Key? key, required this.title, required this.desc, required this.goto})
      : super(key: key);

  final String title;
  final String desc;
  final Widget goto;

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Column(
          children: [
            Text(
              title,
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
            Text(
              desc,
              style: docTextStyle,
            )
          ],
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
        onTapUp: (_) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => goto));
        },
      );
}
