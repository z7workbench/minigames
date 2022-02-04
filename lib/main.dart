import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minigames/app_provider.dart';
import 'package:minigames/games/dices/yacht/yacht_dice_main.dart';
import 'package:minigames/generated/l10n.dart';
import 'package:minigames/games/hnb/hnb_main.dart';
import 'package:minigames/roadmap.dart';
import 'package:minigames/styles.dart';
import 'package:minigames/widgets/description_card.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  late ThemeData lightTheme;
  late ThemeData darkTheme;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [ChangeNotifierProvider.value(value: AppInfoProvider())],
        child: Consumer<AppInfoProvider>(
          builder: (context, appInfo, _) {
            var colorKey = appInfo.themeColor;
            if (lights[colorKey] != null) {
              lightTheme = lights[colorKey]!;
              darkTheme = darks[colorKey]!;
            } else {
              lightTheme = lights['ZeroGo_purple']!;
              darkTheme = darks['ZeroGo_purple']!;
            }
            return MaterialApp(
              title: 'Mini Games',
              theme: lightTheme,
              darkTheme: darkTheme,
              home: const MyHomePage(),
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: S.delegate.supportedLocales,
            );
          },
        ),
      );
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
        body: SingleChildScrollView(
          child: Center(
              child: Padding(
            padding: containerPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                DescriptionCard(
                    title: S.of(context).hnb_title,
                    desc: S.of(context).hnb_desc,
                    goto: const HitAndBlowHome()),
                margin,
                DescriptionCard(
                    title: S.of(context).dice_game_title,
                    desc: S.of(context).dice_game_desc,
                    goto: const DiceGamePage()),
                margin,
                DescriptionCard(
                    title: S.of(context).up_coming,
                    desc: S.of(context).up_coming_desc,
                    goto: const Roadmap())
              ],
            ),
          )),
        ));
  }
}
