import 'package:drift/drift.dart';

/// Table for storing 2048 game save states.
/// Allows players to save their progress and resume later.
///
/// Slot organization:
/// - Slot 0: Auto-save (triggered every 3 minutes during gameplay)
/// - Slots 1-3: Manual save slots (user-initiated saves)
///
/// Total: 4 save slots.
@DataClassName('Twenty48Save')
class Twenty48Saves extends Table {
  /// Unique identifier for the save.
  IntColumn get id => integer().autoIncrement()();

  /// Slot index (0-3) for display ordering.
  /// 0 = auto-save, 1-3 = manual save slots.
  /// Unique constraint ensures only one save per slot.
  IntColumn get slotIndex => integer().unique()();

  /// JSON-serialized Twenty48State containing all game data.
  TextColumn get gameStateJson => text()();

  /// Current score at save time.
  IntColumn get score => integer()();

  /// Maximum tile value achieved.
  IntColumn get maxTile => integer()();

  /// When this save was created.
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();
}
