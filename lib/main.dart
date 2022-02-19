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
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  String theme = await getTheme();
  runApp(MyApp(
    theme: theme,
  ));
}

Future<String> getTheme() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  String? themeIndex = sp.getString("theme");
  if (themeIndex != null) {
    return themeIndex;
  }
  return '';
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.theme}) : super(key: key);
  late ThemeData lightTheme;
  late ThemeData darkTheme;
  String theme = '';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
              value: AppInfoProvider(themeColor: theme))
        ],
        child: Consumer<AppInfoProvider>(
          builder: (context, appInfo, _) {
            var colorKey = appInfo.themeColor;
            if (lights[colorKey] != null) {
              lightTheme = lights[colorKey]!;
              darkTheme = darks[colorKey]!;
            } else {
              lightTheme = lights['ZeroGo Purple']!;
              darkTheme = darks['ZeroGo Purple']!;
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
          actions: [
            Container(
              child: GestureDetector(
                child: const Icon(Icons.format_paint),
                onTap: () {
                  showThemeDialog();
                },
              ),
              margin: containerPadding,
            )
          ],
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

  void showThemeDialog() {
    List themes = darks.keys.toList();

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).theme),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: themes.length,
                  itemBuilder: (BuildContext context, int position) {
                    return GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text(themes[position]),
                      ),
                      onTap: () async {
                        Provider.of<AppInfoProvider>(context, listen: false)
                            .setTheme(themes[position]);
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        sp.setString('theme', themes[position]);
                        Navigator.of(context).pop();
                      },
                    );
                  }),
            ),
          ),
        );
      },
    );
  }
}
