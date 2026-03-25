import 'package:drift/drift.dart';

/// Table for storing Mancala game save states.
/// Allows players to save their progress and resume later.
/// Maximum of 5 save slots per game.
@DataClassName('MancalaSave')
class MancalaSaves extends Table {
  /// Unique identifier for the save.
  IntColumn get id => integer().autoIncrement()();

  /// Slot index (0-4) for display ordering.
  IntColumn get slotIndex => integer().withDefault(const Constant(0))();

  /// JSON-serialized MancalaState containing all game data.
  TextColumn get gameStateJson => text()();

  /// Player 1 score at save time.
  IntColumn get player1Score => integer()();

  /// Player 2 score at save time.
  IntColumn get player2Score => integer()();

  /// AI difficulty if playing vs AI (null for 2-player mode).
  IntColumn get aiDifficulty => integer().nullable()();

  /// When this save was created.
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();
}
