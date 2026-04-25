import 'package:drift/drift.dart';

/// Table for storing Bluff Bar game save states.
/// Allows players to save their progress and resume later.
/// Maximum of 5 save slots per game.
@DataClassName('BluffBarSave')
class BluffBarSaves extends Table {
  /// Unique identifier for the save.
  IntColumn get id => integer().autoIncrement()();

  /// Slot index (0-4) for display ordering.
  IntColumn get slotIndex => integer().unique()();

  /// JSON-serialized game state containing all game data.
  TextColumn get gameStateJson => text()();

  /// Human player's score at save time.
  IntColumn get humanScore => integer()();

  /// AI scores as comma-separated string (e.g., "10,25,15" for 3 AI players).
  TextColumn get aiScores => text()();

  /// Current round number in the game.
  IntColumn get roundNumber => integer()();

  /// When this save was created.
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();
}
