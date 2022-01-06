import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:minigames/games/hit_and_blow.dart';
import 'package:minigames/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Games',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "MiSans"),
      home: const MyHomePage(),
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
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).app),
      ),
      body: Center(
          child: Padding(
        padding: containerPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              child: Column(
                children: [
                  Text(
                    S.of(context).hnb_title,
                    style: titleTextStyle,
                  ),
                  Text(
                    S.of(context).hnb_desc,
                    style: docTextStyle,
                  )
                ],
              ),
              onTapUp: (_) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HitAndBlowHome()));
              },
            ),
            margin,
            GestureDetector(
              child: Column(
                children: [
                  Text(
                    S.of(context).minesweeper_title,
                    style: titleTextStyle,
                  ),
                  Text(
                    S.of(context).minesweeper_desc,
                    style: docTextStyle,
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
