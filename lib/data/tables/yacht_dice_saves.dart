import 'package:drift/drift.dart';

/// Table for storing Yacht Dice game save states.
/// Allows players to save their progress and resume later.
@DataClassName('YachtDiceSave')
class YachtDiceSaves extends Table {
  /// Unique identifier for the save.
  IntColumn get id => integer().autoIncrement()();

  /// Type of game (always 'yacht_dice').
  TextColumn get gameType => text().withLength(min: 1, max: 50)();

  /// AI difficulty level if playing vs AI ('easy', 'medium', 'hard'), null for local multiplayer.
  TextColumn get difficulty => text().nullable()();

  /// JSON-serialized YachtDiceState containing all game data.
  TextColumn get gameStateJson => text()();

  /// When this save was created.
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();
}
