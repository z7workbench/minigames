import 'package:flutter/material.dart';

/// Game type enumeration for all games in the collection.
/// Currently supports 12 games in a responsive grid layout.
enum GameType {
  hitAndBlow,
  yachtDice,
  guessArrangement,
  twenty48,
  diceBattle,
  mancala,
  hearts,
  bluffBar,
  reactionTest,
  aimTest,
  placeholder11,
  placeholder12,
}

extension GameTypeExtension on GameType {
  /// Display name for the game
  String get displayName {
    switch (this) {
      case GameType.hitAndBlow:
        return 'Hit & Blow';
      case GameType.yachtDice:
        return 'Yacht Dice';
      case GameType.guessArrangement:
        return 'Guess Arrangement';
      case GameType.twenty48:
        return '2048';
      case GameType.diceBattle:
        return 'Dice Battle';
      case GameType.mancala:
        return 'Mancala';
      case GameType.hearts:
        return 'Hearts';
      case GameType.bluffBar:
        return 'Bluff Bar';
      case GameType.reactionTest:
        return 'Reaction Test';
      case GameType.aimTest:
        return 'Aim Test';
      case GameType.placeholder11:
        return 'Game 11';
      case GameType.placeholder12:
        return 'Game 12';
    }
  }

  /// Icon for the game
  IconData get iconData {
    switch (this) {
      case GameType.hitAndBlow:
        return Icons.numbers;
      case GameType.yachtDice:
        return Icons.casino;
      case GameType.guessArrangement:
        return Icons.style;
      case GameType.twenty48:
        return Icons.grid_4x4;
      case GameType.diceBattle:
        return Icons.sports_mma;
      case GameType.mancala:
        return Icons.grain;
      case GameType.hearts:
        return Icons.favorite;
      case GameType.bluffBar:
        return Icons.local_bar;  // 酒吧/鸡尾酒图标，符合"吹牛酒吧"主题
      case GameType.reactionTest:
        return Icons.touch_app;
      case GameType.aimTest:
        return Icons.gps_fixed;
      case GameType.placeholder11:
        return Icons.toys;
      case GameType.placeholder12:
        return Icons.games;
    }
  }

  /// Route name for the game screen
  String get route {
    switch (this) {
      case GameType.hitAndBlow:
        return '/hit-and-blow';
      case GameType.yachtDice:
        return '/yacht-dice';
      case GameType.guessArrangement:
        return '/guess-arrangement';
      case GameType.twenty48:
        return '/2048';
      case GameType.diceBattle:
        return '/dice-battle';
      case GameType.mancala:
        return '/mancala';
      case GameType.hearts:
        return '/hearts';
      case GameType.bluffBar:
        return '/bluff-bar';
      case GameType.reactionTest:
        return '/reaction-test';
      case GameType.aimTest:
        return '/aim-test';
      case GameType.placeholder11:
        return '/game-11';
      case GameType.placeholder12:
        return '/game-12';
    }
  }
}
