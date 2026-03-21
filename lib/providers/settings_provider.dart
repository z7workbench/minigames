import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
class Settings extends _$Settings {
  @override
  SettingsModel build() {
    // We'll load settings lazily in the methods since SharedPreferences is async
    return SettingsModel(
      locale: null,
      themeMode: ThemeMode.system,
      soundEnabled: true,
      difficulty: 'normal',
      fullscreen: false,
    );
  }

  Future<SettingsModel> load() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsModel(
      locale: _getLocale(prefs),
      themeMode: _getThemeMode(prefs),
      soundEnabled: _getSoundEnabled(prefs),
      difficulty: _getDifficulty(prefs),
      fullscreen: _getFullscreen(prefs),
    );
  }

  Locale? _getLocale(SharedPreferences prefs) {
    final localeStr = prefs.getString('locale');
    if (localeStr == null) return null;
    return Locale(localeStr);
  }

  ThemeMode _getThemeMode(SharedPreferences prefs) {
    final themeStr = prefs.getString('themeMode') ?? 'system';
    switch (themeStr) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  bool _getSoundEnabled(SharedPreferences prefs) {
    return prefs.getBool('soundEnabled') ?? true;
  }

  String _getDifficulty(SharedPreferences prefs) {
    return prefs.getString('difficulty') ?? 'normal';
  }

  bool _getFullscreen(SharedPreferences prefs) {
    return prefs.getBool('fullscreen') ?? false;
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(locale: locale);
    if (locale == null) {
      prefs.remove('locale');
    } else {
      prefs.setString('locale', locale.toString());
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(themeMode: themeMode);
    switch (themeMode) {
      case ThemeMode.light:
        prefs.setString('themeMode', 'light');
        break;
      case ThemeMode.dark:
        prefs.setString('themeMode', 'dark');
        break;
      default:
        prefs.setString('themeMode', 'system');
        break;
    }
  }

  Future<void> toggleSound() async {
    final prefs = await SharedPreferences.getInstance();
    final newEnabled = !state.soundEnabled;
    state = state.copyWith(soundEnabled: newEnabled);
    prefs.setBool('soundEnabled', newEnabled);
  }

  Future<void> setDifficulty(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(difficulty: difficulty);
    prefs.setString('difficulty', difficulty);
  }

  Future<void> toggleFullscreen() async {
    final prefs = await SharedPreferences.getInstance();
    final newFullscreen = !state.fullscreen;
    state = state.copyWith(fullscreen: newFullscreen);
    prefs.setBool('fullscreen', newFullscreen);
  }
}

class SettingsModel {
  final Locale? locale;
  final ThemeMode themeMode;
  final bool soundEnabled;
  final String difficulty;
  final bool fullscreen;

  SettingsModel({
    required this.locale,
    required this.themeMode,
    required this.soundEnabled,
    required this.difficulty,
    required this.fullscreen,
  });

  SettingsModel copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    bool? soundEnabled,
    String? difficulty,
    bool? fullscreen,
  }) {
    return SettingsModel(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      difficulty: difficulty ?? this.difficulty,
      fullscreen: fullscreen ?? this.fullscreen,
    );
  }
}
