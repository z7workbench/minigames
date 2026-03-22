import 'package:drift/drift.dart';

/// Table for storing 2048 game save states.
/// Allows players to save their progress and resume later.
/// Maximum of 5 save slots per game type.
@DataClassName('Twenty48Save')
class Twenty48Saves extends Table {
  /// Unique identifier for the save.
  IntColumn get id => integer().autoIncrement()();

  /// Slot index (0-4) for display ordering.
  IntColumn get slotIndex => integer().withDefault(const Constant(0))();

  /// JSON-serialized Twenty48State containing all game data.
  TextColumn get gameStateJson => text()();

  /// Current score at save time.
  IntColumn get score => integer()();

  /// Maximum tile value achieved.
  IntColumn get maxTile => integer()();

  /// When this save was created.
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();
}
