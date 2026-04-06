import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

// keepAlive: true 防止 provider 被自动释放
// 这确保设置在整个应用生命周期中保持持久化
@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  @override
  SettingsModel build() {
    // We'll load settings lazily in the methods since SharedPreferences is async
    return SettingsModel(
      locale: null,
      soundEnabled: true,
      difficulty: 'normal',
      fullscreen: false,
    );
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsModel(
      locale: _getLocale(prefs),
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
  final bool soundEnabled;
  final String difficulty;
  final bool fullscreen;

  SettingsModel({
    required this.locale,
    required this.soundEnabled,
    required this.difficulty,
    required this.fullscreen,
  });

  /// Sentinel value to distinguish "not provided" from "null"
  static const _unset = Object();

  SettingsModel copyWith({
    Object? locale = _unset,
    bool? soundEnabled,
    String? difficulty,
    bool? fullscreen,
  }) {
    return SettingsModel(
      locale: locale == _unset ? this.locale : locale as Locale?,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      difficulty: difficulty ?? this.difficulty,
      fullscreen: fullscreen ?? this.fullscreen,
    );
  }
}
