import 'package:flutter/material.dart';
import 'package:minigames/styles.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({Key? key, required this.children, required this.title}) : super(key: key);
  final List<Widget> children;
  final String title;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  var visibility = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: titleTextStyle,
              ),
            ),
            Offstage(
              offstage: visibility,
              child: const Icon(Icons.expand_less),
            ),
            Offstage(
              offstage: !visibility,
              child: const Icon(Icons.expand_more),
            )
          ],
        ),
        Offstage(
          offstage: visibility,
          child: Column(
            children: widget.children,
          ),
        )
      ],
    ),
    onTapUp: (_) {
      if (visibility) {
        setState(() {
          visibility = false;
        });
      } else {
        setState(() {
          visibility = true;
        });
      }
    },
  );
}