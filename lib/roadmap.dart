import 'package:flutter/material.dart';
import 'package:minigames/generated/l10n.dart';

class Roadmap extends StatelessWidget {
  const Roadmap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(S.of(context).roadmap)),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ));
}
