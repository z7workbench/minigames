import 'package:flutter/material.dart';
import 'package:minigames/models/game_type.dart';
import 'package:minigames/l10n/generated/app_localizations.dart';

/// Game category enumeration for grouping games by type.
enum GameCategory { dice, cards, board, reaction, casual }

extension GameCategoryExtension on GameCategory {
  /// Display name for the category (localized)
  String displayName(AppLocalizations l10n) {
    switch (this) {
      case GameCategory.dice:
        return l10n.category_dice;
      case GameCategory.cards:
        return l10n.category_cards;
      case GameCategory.board:
        return l10n.category_board;
      case GameCategory.reaction:
        return l10n.category_reaction;
      case GameCategory.casual:
        return l10n.category_casual;
    }
  }

  /// Icon for the category
  IconData get icon {
    switch (this) {
      case GameCategory.dice:
        return Icons.casino;
      case GameCategory.cards:
        return Icons.style;
      case GameCategory.board:
        return Icons.grain;
      case GameCategory.reaction:
        return Icons.touch_app;
      case GameCategory.casual:
        return Icons.sports_esports;
    }
  }

  /// Games in this category (after placeholder removal)
  List<GameType> get gameTypes {
    switch (this) {
      case GameCategory.dice:
        return [GameType.yachtDice];
      case GameCategory.cards:
        return [GameType.guessArrangement, GameType.hearts, GameType.bluffBar];
      case GameCategory.board:
        return [GameType.mancala, GameType.chessIntl];
      case GameCategory.reaction:
        return [GameType.reactionTest, GameType.aimTest, GameType.schulteGrid];
      case GameCategory.casual:
        return [GameType.hitAndBlow, GameType.twenty48, GameType.fishing];
    }
  }

  /// Get category by name (for SharedPreferences deserialization)
  static GameCategory? fromName(String name) {
    switch (name) {
      case 'dice':
        return GameCategory.dice;
      case 'cards':
        return GameCategory.cards;
      case 'board':
        return GameCategory.board;
      case 'reaction':
        return GameCategory.reaction;
      case 'casual':
        return GameCategory.casual;
      default:
        return null;
    }
  }
}

/// Extension to get category from GameType
extension GameTypeCategoryExtension on GameType {
  /// The category this game belongs to
  GameCategory? get category {
    switch (this) {
      case GameType.yachtDice:
        return GameCategory.dice;
      case GameType.guessArrangement:
      case GameType.hearts:
      case GameType.bluffBar:
        return GameCategory.cards;
      case GameType.mancala:
      case GameType.chessIntl:
        return GameCategory.board;
      case GameType.reactionTest:
      case GameType.aimTest:
      case GameType.schulteGrid:
        return GameCategory.reaction;
      case GameType.hitAndBlow:
      case GameType.twenty48:
      case GameType.fishing:
        return GameCategory.casual;
    }
  }
}
