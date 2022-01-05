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
  late TextEditingController _controller;

  late FocusNode _node;

  final List _contentList = [];

  @override
  void initState() {
    List.generate(widget.count, (index) {
      _contentList.add('');
    });
    _controller = TextEditingController();
    _node = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Stack(children: [
          Positioned.fill(
              child: Row(
            children: List.generate(
                widget.count,
                (index) => SizedBox(
                      width: widget.itemWidth,
                      child: _CodeBoardItem(
                          data: _contentList[index],
                          borderColor: widget.borderColor,
                          borderRadius: widget.borderRadius,
                          borderWidth: widget.borderWidth,
                          focusBorderColor: widget.focusBorderColor),
                    )),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          )),
          SizedBox(
            width: widget.itemWidth,
            child: TextField(
              controller: _controller,
              focusNode: _node,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
              ),
              cursorWidth: 0,
              autofocus: widget.autoFocus,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              ],
              maxLength: widget.count,
              buildCounter: (
                BuildContext context, {
                required int currentLength,
                required bool isFocused,
                required int? maxLength,
              }) {
                return const Text('');
              },
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.transparent),
              onChanged: _onValueChange,
            ),
          ),
          MaterialButton(
            onPressed: () => {widget.finished(_contentList)},
            child: Text("check"),
          )
        ]),
        onTap: () => FocusScope.of(context).requestFocus(_node),
      );

  _onValueChange(value) {
    for (int i = 0; i < widget.count; i++) {
      if (i < value.length) {
        _contentList[i] = value.substring(i, i + 1);
      } else {
        _contentList[i] = '';
      }
    }
    setState(() {});

    if (value.length == widget.count) {
      if (widget.unfocus) {
        _node.unfocus();
      }
    }
  }
}

class _CodeBoardItem extends StatelessWidget {
  const _CodeBoardItem(
      {Key? key,
      required this.data,
      required this.borderColor,
      required this.borderRadius,
      required this.borderWidth,
      required this.focusBorderColor})
      : super(key: key);

  final String data;
  final double borderWidth;
  final Color borderColor;
  final Color focusBorderColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) => Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: borderWidth)),
      child: Text(data));
}
