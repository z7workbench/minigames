import 'package:flutter/material.dart';
import 'package:minigames/styles.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({super.key, required this.children, required this.title});
  final List<Widget> children;
  final String title;

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  var visibility = false;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          GestureDetector(
            child: Row(
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
      );
}
