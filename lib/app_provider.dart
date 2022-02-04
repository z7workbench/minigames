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
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0x64, 0x47, 0xbc),
          brightness: Brightness.dark),
      fontFamily: "MiSans",
      useMaterial3: true),
  "Yun_green": ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0x47, 0xc2, 0x29),
          brightness: Brightness.dark),
      fontFamily: "MiSans",
      useMaterial3: true),
};

final Map<String, ThemeData> lights = {
  "ZeroGo_purple": ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0x97, 0x74, 0xef),
          brightness: Brightness.light),
      fontFamily: "MiSans",
      useMaterial3: true),
  "Yun_green": ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0x47, 0xc2, 0x29),
          brightness: Brightness.light),
      fontFamily: "MiSans",
      useMaterial3: true),
};
