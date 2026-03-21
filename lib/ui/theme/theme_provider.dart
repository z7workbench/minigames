import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  late final SharedPreferences _prefs;

  @override
  Future<ThemeMode> build() async {
    _prefs = await SharedPreferences.getInstance();
    final themeString = _prefs.getString('theme_mode');

    if (themeString == 'light') {
      return ThemeMode.light;
    } else if (themeString == 'dark') {
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  void toggleTheme() {
    final currentMode = state.valueOrNull ?? ThemeMode.system;
    ThemeMode newMode;

    if (currentMode == ThemeMode.light) {
      newMode = ThemeMode.dark;
    } else {
      newMode = ThemeMode.light;
    }

    _setTheme(newMode);
  }

  void setTheme(ThemeMode themeMode) {
    _setTheme(themeMode);
  }

  Future<void> _setTheme(ThemeMode themeMode) async {
    String? themeString;

    switch (themeMode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
        themeString = null;
        break;
    }

    if (themeString != null) {
      await _prefs.setString('theme_mode', themeString);
    } else {
      await _prefs.remove('theme_mode');
    }

    state = AsyncValue.data(themeMode);
  }
}
