import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/hearts_saves.dart';

part 'hearts_saves_dao.g.dart';

/// Data Access Object for Hearts game saves.
/// Provides methods to save, load, and delete game progress.
/// Maximum of 5 save slots allowed.
@DriftAccessor(tables: [HeartsSaves])
class HeartsSavesDao extends DatabaseAccessor<AppDatabase>
    with _$HeartsSavesDaoMixin {
  /// Creates a new HeartsSavesDao with the given database.
  HeartsSavesDao(super.db);

  /// Maximum number of save slots allowed.
  static const int maxSlots = 5;

  /// Save current game state to a slot.
  /// Returns the ID of the inserted save.
  /// If the slot is occupied, overwrites the existing save.
  Future<int> saveGame(HeartsSavesCompanion save) {
    return into(heartsSaves).insert(save, mode: InsertMode.insertOrReplace);
  }

  /// Get a specific save by slot index.
  /// Returns null if no save exists for that slot.
  Future<HeartsSave?> getSaveBySlot(int slotIndex) {
    return (select(
      heartsSaves,
    )..where((tbl) => tbl.slotIndex.equals(slotIndex))).getSingleOrNull();
  }

  /// Get all saves ordered by slot index.
  Future<List<HeartsSave>> getAllSaves() {
    return (select(
      heartsSaves,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.slotIndex)])).get();
  }

  /// Get the most recent save.
  /// Returns null if no saves exist.
  Future<HeartsSave?> getMostRecentSave() {
    return (select(heartsSaves)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.savedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Delete a specific save by slot index.
  /// Returns the number of deleted rows.
  Future<int> deleteSaveBySlot(int slotIndex) {
    return (delete(
      heartsSaves,
    )..where((tbl) => tbl.slotIndex.equals(slotIndex))).go();
  }

  /// Delete a specific save by ID.
  /// Returns the number of deleted rows.
  Future<int> deleteSave(int id) {
    return (delete(heartsSaves)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Delete all saves.
  /// Returns the number of deleted rows.
  Future<int> deleteAllSaves() {
    return delete(heartsSaves).go();
  }

  /// Check if any saves exist.
  Future<bool> hasAnySaves() async {
    final count = await getSaveCount();
    return count > 0;
  }

  /// Get the current count of saves.
  Future<int> getSaveCount() async {
    final query = selectOnly(heartsSaves)..addColumns([heartsSaves.id.count()]);
    final result = await query.getSingle();
    return result.read(heartsSaves.id.count()) ?? 0;
  }

  /// Get the first available empty slot index.
  /// Returns -1 if all slots are full.
  Future<int> getFirstEmptySlot() async {
    final saves = await getAllSaves();
    final occupiedSlots = saves.map((s) => s.slotIndex).toSet();

    for (int i = 0; i < maxSlots; i++) {
      if (!occupiedSlots.contains(i)) {
        return i;
      }
    }
    return -1;
  }

  /// Check if a specific slot is available.
  Future<bool> isSlotAvailable(int slotIndex) async {
    final save = await getSaveBySlot(slotIndex);
    return save == null;
  }
}
