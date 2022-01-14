import 'package:flutter/material.dart';
import 'package:minigames/styles.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({Key? key, required this.children, required this.title})
      : super(key: key);
  final List<Widget> children;
  final String title;

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
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
                    style: largeTextStyle,
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
            AnimatedOpacity(
              opacity: visibility ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 500),
              child: Offstage(
                offstage: visibility,
                child: Column(
                  children: widget.children,
                ),
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
