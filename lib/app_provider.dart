import 'package:flutter/material.dart';

class AppInfoProvider with ChangeNotifier {
  String themeColor = '';

  AppInfoProvider({required this.themeColor});

  setTheme(String theme) {
    themeColor = theme;
    notifyListeners();
  }
}

final Map<String, ThemeData> darks = {
  "ZeroGo Purple": ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0x64, 0x47, 0xbc),
          brightness: Brightness.dark),
      fontFamily: "MiSans",
      useMaterial3: true),
  "Yun Green": ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0x47, 0xc2, 0x29),
          brightness: Brightness.dark),
      fontFamily: "MiSans",
      useMaterial3: true),
  "Cyan": ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0x00, 0x5b, 0x9f),
          brightness: Brightness.dark),
      fontFamily: "MiSans",
      useMaterial3: true),
  "Amber": ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0xff, 0xa0, 0x00),
          brightness: Brightness.dark),
      fontFamily: "MiSans",
      useMaterial3: true),
  "Black": ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0x37, 0x37, 0x37),
          brightness: Brightness.dark),
      fontFamily: "MiSans",
      useMaterial3: true),
};

final Map<String, ThemeData> lights = {
  "ZeroGo Purple": ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0x97, 0x74, 0xef),
          brightness: Brightness.light),
      fontFamily: "MiSans",
      useMaterial3: true),
  "Yun Green": ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0x47, 0xc2, 0x29),
          brightness: Brightness.light),
      fontFamily: "MiSans",
      useMaterial3: true),
  "Cyan": ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0x03, 0xa9, 0xf4),
          brightness: Brightness.light),
      fontFamily: "MiSans",
      useMaterial3: true),
  "Amber": ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0xff, 0xc1, 0x07),
          brightness: Brightness.light),
      fontFamily: "MiSans",
      useMaterial3: true),
  "Black": ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0xff, 0xbd, 0xbd, 0xbd),
          brightness: Brightness.light),
      fontFamily: "MiSans",
      useMaterial3: true),
};
