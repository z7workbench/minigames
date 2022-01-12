// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hit and Blow`
  String get hnb_title {
    return Intl.message(
      'Hit and Blow',
      name: 'hnb_title',
      desc: '',
      args: [],
    );
  }

  /// `This is a game of guessing the hidden n numbers and positions, with the default n being 4. Select n-2 numbers from 1 to n and place them in the positions, then press "Check" to check for correctness. Each position will be judged as "all correct" (indicated by colored check marks) or "half correct" (indicated by grey check marks), the number of former is the number of correct positions and numbers, the number of latter is the number of correct numbers. If it fails, you can try again until you get it right! `
  String get hnb_desc {
    return Intl.message(
      'This is a game of guessing the hidden n numbers and positions, with the default n being 4. Select n-2 numbers from 1 to n and place them in the positions, then press "Check" to check for correctness. Each position will be judged as "all correct" (indicated by colored check marks) or "half correct" (indicated by grey check marks), the number of former is the number of correct positions and numbers, the number of latter is the number of correct numbers. If it fails, you can try again until you get it right! ',
      name: 'hnb_desc',
      desc: '',
      args: [],
    );
  }

  /// `Correct answer`
  String get hnb_answer {
    return Intl.message(
      'Correct answer',
      name: 'hnb_answer',
      desc: '',
      args: [],
    );
  }

  /// `Check`
  String get check {
    return Intl.message(
      'Check',
      name: 'check',
      desc: '',
      args: [],
    );
  }

  /// `Minesweeper`
  String get minesweeper_title {
    return Intl.message(
      'Minesweeper',
      name: 'minesweeper_title',
      desc: '',
      args: [],
    );
  }

  /// `Get ask reduce skin. Child never forget less herself reveal. City example similar service billion store large. Book term although believe. Religious out opportunity upon note.`
  String get minesweeper_desc {
    return Intl.message(
      'Get ask reduce skin. Child never forget less herself reveal. City example similar service billion store large. Book term although believe. Religious out opportunity upon note.',
      name: 'minesweeper_desc',
      desc: '',
      args: [],
    );
  }

  /// `Start Game`
  String get start_game {
    return Intl.message(
      'Start Game',
      name: 'start_game',
      desc: '',
      args: [],
    );
  }

  /// `Restart Game`
  String get restart_game {
    return Intl.message(
      'Restart Game',
      name: 'restart_game',
      desc: '',
      args: [],
    );
  }

  /// `Leaderboard`
  String get leaderboard {
    return Intl.message(
      'Leaderboard',
      name: 'leaderboard',
      desc: '',
      args: [],
    );
  }

  /// `Game info`
  String get description {
    return Intl.message(
      'Game info',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Mini Games`
  String get app {
    return Intl.message(
      'Mini Games',
      name: 'app',
      desc: '',
      args: [],
    );
  }

  /// `Up Coming Next...`
  String get up_coming {
    return Intl.message(
      'Up Coming Next...',
      name: 'up_coming',
      desc: '',
      args: [],
    );
  }

  /// `More mini games will be released in this app, click here to see the version update logs and future version roadmap!`
  String get up_coming_desc {
    return Intl.message(
      'More mini games will be released in this app, click here to see the version update logs and future version roadmap!',
      name: 'up_coming_desc',
      desc: '',
      args: [],
    );
  }

  /// `Roadmap`
  String get roadmap {
    return Intl.message(
      'Roadmap',
      name: 'roadmap',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
