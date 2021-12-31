import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:minigames/hit_and_blow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiniGames',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mini Games'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              child: Column(
                children: [
                  Text(S.of(context).hnb_title,
                    style: const TextStyle(fontSize: 24.0, color: Colors.black),
                  ),
                  Text(S.of(context).hnb_desc,
                  style: const TextStyle(fontSize: 16.0),)
                ],
              ),
              onTapUp: (_) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HitAndBlowHome()));
              },
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            GestureDetector(
              child: Column(
                children: const [
                  Text(
                    "Minesweeper",
                    style: TextStyle(fontSize: 24.0, color: Colors.black),
                  ),
                  Text(
                    "Here is the description. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. ",
                    style: TextStyle(fontSize: 16.0),)
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
