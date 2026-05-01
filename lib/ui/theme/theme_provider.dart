import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// Available color schemes
enum ColorSchemeType { wooden, starlight, forest, volcano }

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

@riverpod
class ColorSchemeNotifier extends _$ColorSchemeNotifier {
  late final SharedPreferences _prefs;

  @override
  Future<ColorSchemeType> build() async {
    _prefs = await SharedPreferences.getInstance();
    final schemeString = _prefs.getString('color_scheme');

    switch (schemeString) {
      case 'wooden':
        return ColorSchemeType.wooden;
      case 'forest':
        return ColorSchemeType.forest;
      case 'volcano':
        return ColorSchemeType.volcano;
      case 'starlight':
      default:
        return ColorSchemeType.starlight;
    }
  }

  void setColorScheme(ColorSchemeType scheme) {
    _setColorScheme(scheme);
  }

  Future<void> _setColorScheme(ColorSchemeType scheme) async {
    final schemeString = switch (scheme) {
      ColorSchemeType.starlight => 'starlight',
      ColorSchemeType.forest => 'forest',
      ColorSchemeType.volcano => 'volcano',
      ColorSchemeType.wooden => 'wooden',
    };

    await _prefs.setString('color_scheme', schemeString);
    state = AsyncValue.data(scheme);
  }
}
