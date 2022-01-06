import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeBoard extends StatefulWidget {
  const CodeBoard(
      {Key? key,
      this.count = 4,
      this.itemWidth = 45,
      this.borderWidth = 2.0,
      this.borderRadius = 5.0,
      this.unfocus = true,
      this.autoFocus = true,
      required this.borderColor,
      required this.focusBorderColor,
      required this.finished})
      : super(key: key);

  final int count;
  final double borderWidth;
  final Color borderColor;
  final Color focusBorderColor;
  final double borderRadius;
  final ValueChanged finished;
  final double itemWidth;
  final bool autoFocus;
  final bool unfocus;

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
      _contentList.add(1);
    });
    List.generate(widget.count + 2, (index) {
      _candidates.add(index + 1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Row(children: [
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
                    hint: Text("select"),
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
      ]);
}
