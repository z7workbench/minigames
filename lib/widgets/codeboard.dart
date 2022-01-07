import 'package:flutter/material.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:minigames/styles.dart';

class CodeBoard extends StatefulWidget {
  const CodeBoard(
      {Key? key,
      this.count = 4,
      this.borderWidth = 2.0,
      this.borderRadius = 5.0,
      this.focused = true,
      required this.times,
      required this.borderColor,
      required this.focusBorderColor,
      required this.finished})
      : super(key: key);

  final int times;
  final int count;
  final double borderWidth;
  final Color borderColor;
  final Color focusBorderColor;
  final double borderRadius;
  final ValueChanged finished;
  final bool focused;

  @override
  State<StatefulWidget> createState() => _CodeBoardState();
}

class _CodeBoardState extends State<CodeBoard> {
  final List<int> _contentList = [];
  List get content => _contentList;
  final List<int> _candidates = [];

  @override
  void initState() {
    List.generate(widget.count, (index) {
      _contentList.add(0);
    });
    List.generate(widget.count + 2 + 1, (index) {
      _candidates.add(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          border: Border.all(
              color:
                  widget.focused ? widget.focusBorderColor : widget.borderColor,
              width: widget.borderWidth),
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius))),
      child: Padding(
        padding: containerPadding,
        child: Column(
          children: [
            Text("try: ${widget.times}"),
            Row(children: [
              Row(
                children: List.generate(
                    widget.count,
                    (index) => DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                          onChanged: (value) {
                            setState(() {
                              _contentList[index] = value ?? 0;
                            });
                          },
                          hint: Text(S.of(context).check),
                          value: _contentList[index],
                          items: _candidates
                              .map((e) => DropdownMenuItem<int>(
                                    value: e,
                                    child: Text(e.toString()),
                                  ))
                              .toList(),
                        ))),
              ),
              MaterialButton(
                onPressed: () => {widget.finished(_contentList)},
                child: const Text("check"),
              )
            ])
          ],
        ),
      ));
}
