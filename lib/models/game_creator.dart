import 'package:flutter/material.dart';
import 'package:minigames/models/game_type.dart';
import 'package:minigames/l10n/generated/app_localizations.dart';

enum GameCreator { glm, minimax, mimo }

extension GameCreatorExtension on GameCreator {
  String displayName(AppLocalizations l10n) {
    switch (this) {
      case GameCreator.glm:
        return l10n.creator_glm;
      case GameCreator.minimax:
        return l10n.creator_minimax;
      case GameCreator.mimo:
        return l10n.creator_mimo;
    }
  }

  IconData get icon {
    switch (this) {
      case GameCreator.glm:
        return Icons.auto_awesome;
      case GameCreator.minimax:
        return Icons.bolt;
      case GameCreator.mimo:
        return Icons.psychology;
    }
  }

  List<GameType> get gameTypes {
    switch (this) {
      case GameCreator.glm:
        return [
          GameType.yachtDice,
          GameType.guessArrangement,
          GameType.twenty48,
          GameType.diceBattle,
          GameType.mancala,
          GameType.hearts,
          GameType.bluffBar,
        ];
      case GameCreator.minimax:
        return [GameType.reactionTest, GameType.aimTest, GameType.fishing];
      case GameCreator.mimo:
        return [GameType.hitAndBlow, GameType.chessIntl, GameType.schulteGrid];
    }
  }

  static GameCreator? fromName(String name) {
    for (final c in GameCreator.values) {
      if (c.name == name) return c;
    }
    return null;
  }
}

extension GameTypeCreatorExtension on GameType {
  GameCreator get creator {
    switch (this) {
      case GameType.yachtDice:
      case GameType.guessArrangement:
      case GameType.twenty48:
      case GameType.diceBattle:
      case GameType.mancala:
      case GameType.hearts:
      case GameType.bluffBar:
        return GameCreator.glm;
      case GameType.reactionTest:
      case GameType.aimTest:
        return GameCreator.minimax;
      case GameType.hitAndBlow:
      case GameType.chessIntl:
      case GameType.schulteGrid:
        return GameCreator.mimo;
      case GameType.fishing:
        return GameCreator.minimax;
    }
  }
}
