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

  /// `When you finished`
  String get hnb_when_finished {
    return Intl.message(
      'When you finished',
      name: 'hnb_when_finished',
      desc: '',
      args: [],
    );
  }

  /// `Playtime`
  String get hnb_used_time {
    return Intl.message(
      'Playtime',
      name: 'hnb_used_time',
      desc: '',
      args: [],
    );
  }

  /// `Count you tried`
  String get hnb_hit {
    return Intl.message(
      'Count you tried',
      name: 'hnb_hit',
      desc: '',
      args: [],
    );
  }

  /// `Currently no data`
  String get empty_leaderboard {
    return Intl.message(
      'Currently no data',
      name: 'empty_leaderboard',
      desc: '',
      args: [],
    );
  }

  /// `Clean Leaderboard`
  String get clean_leaderboard {
    return Intl.message(
      'Clean Leaderboard',
      name: 'clean_leaderboard',
      desc: '',
      args: [],
    );
  }

  /// `Simple Dice Game`
  String get dice_game_title {
    return Intl.message(
      'Simple Dice Game',
      name: 'dice_game_title',
      desc: '',
      args: [],
    );
  }

  /// `It's a game of throwing dices at each other to make permutations and compete for points. If you make a good combination, double tap the corresponding score to confirm the score. The selected permutations cannot be selected again. You can tap on the dice once, save only the good ones and roll them again. The remaining dice can also be changed after a re-roll. Each sheet's cell must be filled in, even if there are no permutations. The one with the highest score wins!`
  String get dice_game_desc {
    return Intl.message(
      'It\'s a game of throwing dices at each other to make permutations and compete for points. If you make a good combination, double tap the corresponding score to confirm the score. The selected permutations cannot be selected again. You can tap on the dice once, save only the good ones and roll them again. The remaining dice can also be changed after a re-roll. Each sheet\'s cell must be filled in, even if there are no permutations. The one with the highest score wins!',
      name: 'dice_game_desc',
      desc: '',
      args: [],
    );
  }

  /// `Reserve`
  String get dice_reserve {
    return Intl.message(
      'Reserve',
      name: 'dice_reserve',
      desc: '',
      args: [],
    );
  }

  /// `Deck`
  String get dice_deck {
    return Intl.message(
      'Deck',
      name: 'dice_deck',
      desc: '',
      args: [],
    );
  }

  /// `Aces`
  String get dice_aces {
    return Intl.message(
      'Aces',
      name: 'dice_aces',
      desc: '',
      args: [],
    );
  }

  /// `Deuces`
  String get dice_deuces {
    return Intl.message(
      'Deuces',
      name: 'dice_deuces',
      desc: '',
      args: [],
    );
  }

  /// `Threes`
  String get dice_threes {
    return Intl.message(
      'Threes',
      name: 'dice_threes',
      desc: '',
      args: [],
    );
  }

  /// `Fours`
  String get dice_fours {
    return Intl.message(
      'Fours',
      name: 'dice_fours',
      desc: '',
      args: [],
    );
  }

  /// `Fives`
  String get dice_fives {
    return Intl.message(
      'Fives',
      name: 'dice_fives',
      desc: '',
      args: [],
    );
  }

  /// `Sixes`
  String get dice_sixes {
    return Intl.message(
      'Sixes',
      name: 'dice_sixes',
      desc: '',
      args: [],
    );
  }

  /// `Choices`
  String get dice_choice {
    return Intl.message(
      'Choices',
      name: 'dice_choice',
      desc: '',
      args: [],
    );
  }

  /// `4 of Kind`
  String get dice_4_of_kind {
    return Intl.message(
      '4 of Kind',
      name: 'dice_4_of_kind',
      desc: '',
      args: [],
    );
  }

  /// `Full House`
  String get dice_full_house {
    return Intl.message(
      'Full House',
      name: 'dice_full_house',
      desc: '',
      args: [],
    );
  }

  /// `S. Straight`
  String get dice_s_straight {
    return Intl.message(
      'S. Straight',
      name: 'dice_s_straight',
      desc: '',
      args: [],
    );
  }

  /// `L. Straight`
  String get dice_l_straight {
    return Intl.message(
      'L. Straight',
      name: 'dice_l_straight',
      desc: '',
      args: [],
    );
  }

  /// `Yacht`
  String get dice_yacht {
    return Intl.message(
      'Yacht',
      name: 'dice_yacht',
      desc: '',
      args: [],
    );
  }

  /// `Bonus`
  String get dice_bonus {
    return Intl.message(
      'Bonus',
      name: 'dice_bonus',
      desc: '',
      args: [],
    );
  }

  /// `Aces: Total of all 1s`
  String get dice_aces_desc {
    return Intl.message(
      'Aces: Total of all 1s',
      name: 'dice_aces_desc',
      desc: '',
      args: [],
    );
  }

  /// `Deuces: Total of all 2s`
  String get dice_deuces_desc {
    return Intl.message(
      'Deuces: Total of all 2s',
      name: 'dice_deuces_desc',
      desc: '',
      args: [],
    );
  }

  /// `Threes: Total of all 3s`
  String get dice_threes_desc {
    return Intl.message(
      'Threes: Total of all 3s',
      name: 'dice_threes_desc',
      desc: '',
      args: [],
    );
  }

  /// `Fours: Total of all 4s`
  String get dice_fours_desc {
    return Intl.message(
      'Fours: Total of all 4s',
      name: 'dice_fours_desc',
      desc: '',
      args: [],
    );
  }

  /// `Fives: Total of all 5s`
  String get dice_fives_desc {
    return Intl.message(
      'Fives: Total of all 5s',
      name: 'dice_fives_desc',
      desc: '',
      args: [],
    );
  }

  /// `Sixes: Total of all 6s`
  String get dice_sixes_desc {
    return Intl.message(
      'Sixes: Total of all 6s',
      name: 'dice_sixes_desc',
      desc: '',
      args: [],
    );
  }

  /// `Choices: Total of all dices`
  String get dice_choice_desc {
    return Intl.message(
      'Choices: Total of all dices',
      name: 'dice_choice_desc',
      desc: '',
      args: [],
    );
  }

  /// `4 of Kind: 4 of the same number`
  String get dice_4_of_kind_desc {
    return Intl.message(
      '4 of Kind: 4 of the same number',
      name: 'dice_4_of_kind_desc',
      desc: '',
      args: [],
    );
  }

  /// `Full House: 3 of a kind + 2 of the kind`
  String get dice_full_house_desc {
    return Intl.message(
      'Full House: 3 of a kind + 2 of the kind',
      name: 'dice_full_house_desc',
      desc: '',
      args: [],
    );
  }

  /// `S. Straight: 4 numbers in ascending order`
  String get dice_s_straight_desc {
    return Intl.message(
      'S. Straight: 4 numbers in ascending order',
      name: 'dice_s_straight_desc',
      desc: '',
      args: [],
    );
  }

  /// `L. Straight: 5 numbers in ascending order`
  String get dice_l_straight_desc {
    return Intl.message(
      'L. Straight: 5 numbers in ascending order',
      name: 'dice_l_straight_desc',
      desc: '',
      args: [],
    );
  }

  /// `Yacht: 5 of the same number`
  String get dice_yacht_desc {
    return Intl.message(
      'Yacht: 5 of the same number',
      name: 'dice_yacht_desc',
      desc: '',
      args: [],
    );
  }

  /// `Bonus: All score above 63 in the first six categories is awarded +35 bonus points`
  String get dice_bonus_desc {
    return Intl.message(
      'Bonus: All score above 63 in the first six categories is awarded +35 bonus points',
      name: 'dice_bonus_desc',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get dice_total {
    return Intl.message(
      'Total',
      name: 'dice_total',
      desc: '',
      args: [],
    );
  }

  /// `Total: The sum of all score`
  String get dice_total_desc {
    return Intl.message(
      'Total: The sum of all score',
      name: 'dice_total_desc',
      desc: '',
      args: [],
    );
  }

  /// ` roll(s) remained`
  String get dice_times {
    return Intl.message(
      ' roll(s) remained',
      name: 'dice_times',
      desc: '',
      args: [],
    );
  }

  /// `Poker Pop`
  String get pop_title {
    return Intl.message(
      'Poker Pop',
      name: 'pop_title',
      desc: '',
      args: [],
    );
  }

  /// `12312122312`
  String get pop_desc {
    return Intl.message(
      '12312122312',
      name: 'pop_desc',
      desc: '',
      args: [],
    );
  }

  /// `Connect Four`
  String get connect_four_title {
    return Intl.message(
      'Connect Four',
      name: 'connect_four_title',
      desc: '',
      args: [],
    );
  }

  /// `Connect Four`
  String get connect_four_desc {
    return Intl.message(
      'Connect Four',
      name: 'connect_four_desc',
      desc: '',
      args: [],
    );
  }

  /// `Dismiss`
  String get dismiss {
    return Intl.message(
      'Dismiss',
      name: 'dismiss',
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

  /// `Start a Brand New Game`
  String get start_new_game {
    return Intl.message(
      'Start a Brand New Game',
      name: 'start_new_game',
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

  /// `Themes`
  String get theme {
    return Intl.message(
      'Themes',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Current player:`
  String get current_player {
    return Intl.message(
      'Current player:',
      name: 'current_player',
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
