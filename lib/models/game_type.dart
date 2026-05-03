import 'package:flutter/material.dart';

/// Game type enumeration for all games in the collection.
/// Currently supports 10 games in a responsive grid layout.
enum GameType {
  hitAndBlow,
  yachtDice,
  guessArrangement,
  twenty48,
  mancala,
  hearts,
  bluffBar,
  reactionTest,
  aimTest,
  chessIntl,
  schulteGrid,
  fishing,
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
      case GameType.chessIntl:
        return 'Chess';
case GameType.schulteGrid:
        return 'Schulte Grid';
      case GameType.fishing:
        return 'Fishing';
    }
  }

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
      case GameType.mancala:
        return Icons.grain;
      case GameType.hearts:
        return Icons.favorite;
      case GameType.bluffBar:
        return Icons.local_bar;
      case GameType.reactionTest:
        return Icons.touch_app;
      case GameType.aimTest:
        return Icons.gps_fixed;
      case GameType.chessIntl:
        return Icons.grid_on;
      case GameType.schulteGrid:
        return Icons.grid_4x4;
      case GameType.fishing:
        return Icons.phishing;
    }
  }

  String? get iconText {
    switch (this) {
      case GameType.chessIntl:
        return '\u265A';
      default:
        return null;
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
      case GameType.chessIntl:
        return '/chess-intl';
      case GameType.schulteGrid:
        return '/schulte-grid';
      case GameType.fishing:
        return '/fishing';
    }
  }

  DateTime get releaseDate {
    switch (this) {
      case GameType.hitAndBlow:
        return DateTime(2022, 1, 7);
      case GameType.yachtDice:
        return DateTime(2022, 2, 4);
      case GameType.mancala:
        return DateTime(2026, 4, 6);
      case GameType.twenty48:
        return DateTime(2026, 4, 6);
      case GameType.guessArrangement:
        return DateTime(2026, 4, 6);
      case GameType.hearts:
        return DateTime(2026, 4, 12);
      case GameType.bluffBar:
        return DateTime(2026, 4, 25);
      case GameType.reactionTest:
        return DateTime(2026, 4, 26);
      case GameType.aimTest:
        return DateTime(2026, 4, 26);
      case GameType.chessIntl:
        return DateTime(2026, 4, 29);
      case GameType.schulteGrid:
        return DateTime(2026, 5, 1);
      case GameType.fishing:
        return DateTime(2026, 5, 2);
    }
  }

  bool get isWip => false;
}
