import 'package:flutter/material.dart';

class AppInfoProvider with ChangeNotifier {
  String _themeColor = '';

  String get themeColor => _themeColor;

  setTheme(String themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }
}

final Map<String, ThemeData> darks = {
  "ZeroGo_purple": ThemeData(
      colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color.fromARGB(0xff, 0x64, 0x47, 0xbc),
          onPrimary: Colors.white,
          secondary: Color.fromARGB(0xff, 0x64, 0x47, 0xbc),
          onSecondary: Colors.white,
          error: Color.fromARGB(0xff, 0xD7, 0x2E, 0x2E),
          onError: Color.fromARGB(0xff, 0xB9, 0x20, 0x20),
          background: Color.fromARGB(0xff, 0x64, 0x47, 0xbc),
          onBackground: Colors.white,
          surface: Color.fromARGB(0xff, 0x64, 0x47, 0xbc),
          onSurface: Colors.white),
      fontFamily: "MiSans",
      useMaterial3: true),
};

final Map<String, ThemeData> lights = {
  "ZeroGo_purple": ThemeData(
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(0xff, 0x97, 0x74, 0xef),
          onPrimary: Colors.white,
          secondary: Color.fromARGB(0xff, 0x97, 0x74, 0xef),
          onSecondary: Colors.white,
          error: Color.fromARGB(0xff, 0xD7, 0x2E, 0x2E),
          onError: Color.fromARGB(0xff, 0xB9, 0x20, 0x20),
          background: Colors.white,
          onBackground: Colors.black,
          surface: Color.fromARGB(0xff, 0xBD, 0x63, 0x1A),
          onSurface: Colors.white,),
      fontFamily: "MiSans",
      textTheme: TextTheme(

      ),
      useMaterial3: true),
};
