import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/mancala_saves.dart';

part 'mancala_saves_dao.g.dart';

/// Data Access Object for Mancala game saves.
/// Provides methods to save, load, and delete game progress.
/// Maximum of 5 save slots allowed.
@DriftAccessor(tables: [MancalaSaves])
class MancalaSavesDao extends DatabaseAccessor<AppDatabase>
    with _$MancalaSavesDaoMixin {
  /// Creates a new MancalaSavesDao with the given database.
  MancalaSavesDao(super.db);

  /// Maximum number of save slots allowed.
  static const int maxSlots = 5;

  /// Save current game state to a slot.
  /// Returns the ID of the inserted save.
  /// If the slot is occupied, overwrites the existing save.
  Future<int> saveGame(MancalaSavesCompanion save) {
    return into(mancalaSaves).insert(save, mode: InsertMode.insertOrReplace);
  }

  /// Get a specific save by slot index.
  /// Returns null if no save exists for that slot.
  Future<MancalaSave?> getSaveBySlot(int slotIndex) {
    return (select(
      mancalaSaves,
    )..where((tbl) => tbl.slotIndex.equals(slotIndex))).getSingleOrNull();
  }

  /// Get all saves ordered by slot index.
  Future<List<MancalaSave>> getAllSaves() {
    return (select(
      mancalaSaves,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.slotIndex)])).get();
  }

  /// Get the most recent save.
  /// Returns null if no saves exist.
  Future<MancalaSave?> getMostRecentSave() {
    return (select(mancalaSaves)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.savedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Delete a specific save by slot index.
  /// Returns the number of deleted rows.
  Future<int> deleteSaveBySlot(int slotIndex) {
    return (delete(
      mancalaSaves,
    )..where((tbl) => tbl.slotIndex.equals(slotIndex))).go();
  }

  /// Delete a specific save by ID.
  /// Returns the number of deleted rows.
  Future<int> deleteSave(int id) {
    return (delete(mancalaSaves)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Delete all saves.
  /// Returns the number of deleted rows.
  Future<int> deleteAllSaves() {
    return delete(mancalaSaves).go();
  }

  /// Check if any saves exist.
  Future<bool> hasAnySaves() async {
    final count = await getSaveCount();
    return count > 0;
  }

  /// Get the current count of saves.
  Future<int> getSaveCount() async {
    final query = selectOnly(mancalaSaves)
      ..addColumns([mancalaSaves.id.count()]);
    final result = await query.getSingle();
    return result.read(mancalaSaves.id.count()) ?? 0;
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
