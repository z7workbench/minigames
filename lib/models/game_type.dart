import 'package:flutter/material.dart';

/// Game type enumeration for all games in the collection.
/// Currently supports 6 games in a 3x2 grid layout.
enum GameType {
  hitAndBlow,
  yachtDice,
  placeholder1,
  placeholder2,
  placeholder3,
  placeholder4,
}

extension GameTypeExtension on GameType {
  /// Display name for the game
  String get displayName {
    switch (this) {
      case GameType.hitAndBlow:
        return 'Hit & Blow';
      case GameType.yachtDice:
        return 'Yacht Dice';
      case GameType.placeholder1:
        return 'Game 1';
      case GameType.placeholder2:
        return 'Game 2';
      case GameType.placeholder3:
        return 'Game 3';
      case GameType.placeholder4:
        return 'Game 4';
    }
  }

  /// Icon for the game
  IconData get iconData {
    switch (this) {
      case GameType.hitAndBlow:
        return Icons.numbers;
      case GameType.yachtDice:
        return Icons.casino;
      case GameType.placeholder1:
        return Icons.videogame_asset;
      case GameType.placeholder2:
        return Icons.extension;
      case GameType.placeholder3:
        return Icons.sports_esports;
      case GameType.placeholder4:
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
      case GameType.placeholder1:
        return '/game-1';
      case GameType.placeholder2:
        return '/game-2';
      case GameType.placeholder3:
        return '/game-3';
      case GameType.placeholder4:
        return '/game-4';
    }
  }
}
