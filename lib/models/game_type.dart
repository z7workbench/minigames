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
  placeholder7,
  placeholder8,
  placeholder9,
  placeholder10,
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
      case GameType.placeholder7:
        return 'Game 7';
      case GameType.placeholder8:
        return 'Game 8';
      case GameType.placeholder9:
        return 'Game 9';
      case GameType.placeholder10:
        return 'Game 10';
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
      case GameType.placeholder7:
        return Icons.games;
      case GameType.placeholder8:
        return Icons.videogame_asset;
      case GameType.placeholder9:
        return Icons.gamepad;
      case GameType.placeholder10:
        return Icons.extension;
      case GameType.placeholder11:
        return Icons.toys;
      case GameType.placeholder12:
        return Icons.widgets;
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
      case GameType.placeholder7:
        return '/game-7';
      case GameType.placeholder8:
        return '/game-8';
      case GameType.placeholder9:
        return '/game-9';
      case GameType.placeholder10:
        return '/game-10';
      case GameType.placeholder11:
        return '/game-11';
      case GameType.placeholder12:
        return '/game-12';
    }
  }
}
