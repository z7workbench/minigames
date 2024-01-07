import 'package:flutter/material.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:provider/provider.dart';

class PokerPopPage extends StatefulWidget {
  const PokerPopPage({super.key});

  @override
  State<StatefulWidget> createState() => _PokerPopState();
}

class _PokerPopState extends State<PokerPopPage> {
  bool notShowGame = true;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<PopNoticer>(
    create: (_) => PopNoticer(),
    builder: (context, _) => Scaffold(
      appBar: AppBar(title: Text(S.of(context).pop_title)),
    ),
  );

}

class PopNoticer with ChangeNotifier {

}