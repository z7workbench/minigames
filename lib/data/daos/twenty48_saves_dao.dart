import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/twenty48_saves.dart';

part 'twenty48_saves_dao.g.dart';

/// Data Access Object for 2048 game saves.
/// Provides methods to save, load, and delete game progress.
///
/// Slot organization:
/// - Slot 0: Auto-save (triggered every 3 minutes during gameplay)
/// - Slots 1-3: Manual save slots (user-initiated saves)
///
/// Total: 4 save slots.
@DriftAccessor(tables: [Twenty48Saves])
class Twenty48SavesDao extends DatabaseAccessor<AppDatabase>
    with _$Twenty48SavesDaoMixin {
  /// Creates a new Twenty48SavesDao with the given database.
  Twenty48SavesDao(super.db);

  /// Maximum number of save slots allowed.
  /// Slot 0 = auto-save, Slots 1-3 = manual save.
  static const int maxSlots = 4;

  /// Save current game state to a slot.
  /// Returns the ID of the inserted save.
  /// If the slot is occupied, deletes the old save and inserts a new one.
  ///
  /// Note: We delete and re-insert instead of using insertOrReplace because
  /// insertOrReplace works on the primary key (id), not slotIndex.
  Future<int> saveGame(Twenty48SavesCompanion save) async {
    // First delete any existing save in this slot
    final slotIndex = save.slotIndex.value;
    await deleteSaveBySlot(slotIndex);

    // Then insert the new save
    return into(twenty48Saves).insert(save);
  }

  /// Get a specific save by slot index.
  /// Returns null if no save exists for that slot.
  Future<Twenty48Save?> getSaveBySlot(int slotIndex) {
    return (select(
      twenty48Saves,
    )..where((tbl) => tbl.slotIndex.equals(slotIndex))).getSingleOrNull();
  }

  /// Get all saves ordered by slot index.
  Future<List<Twenty48Save>> getAllSaves() {
    return (select(
      twenty48Saves,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.slotIndex)])).get();
  }

  /// Get the most recent save.
  /// Returns null if no saves exist.
  Future<Twenty48Save?> getMostRecentSave() {
    return (select(twenty48Saves)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.savedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Delete a specific save by slot index.
  /// Returns the number of deleted rows.
  Future<int> deleteSaveBySlot(int slotIndex) {
    return (delete(
      twenty48Saves,
    )..where((tbl) => tbl.slotIndex.equals(slotIndex))).go();
  }

  /// Delete a specific save by ID.
  /// Returns the number of deleted rows.
  Future<int> deleteSave(int id) {
    return (delete(twenty48Saves)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Delete all saves.
  /// Returns the number of deleted rows.
  Future<int> deleteAllSaves() {
    return delete(twenty48Saves).go();
  }

  /// Check if any saves exist.
  Future<bool> hasAnySaves() async {
    final count = await getSaveCount();
    return count > 0;
  }

  /// Get the current count of saves.
  Future<int> getSaveCount() async {
    final query = selectOnly(twenty48Saves)
      ..addColumns([twenty48Saves.id.count()]);
    final result = await query.getSingle();
    return result.read(twenty48Saves.id.count()) ?? 0;
  }

  /// Get the first available empty slot index (includes slot 0 for auto-save).
  /// Returns -1 if all slots are full.
  /// For manual saves only, use getFirstEmptyManualSlot().
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

  /// Get the auto-save (slot 0).
  /// Returns null if no auto-save exists.
  Future<Twenty48Save?> getAutoSave() {
    return getSaveBySlot(0);
  }

  /// Get all manual saves (slots 1-3).
  /// Returns an empty list if no manual saves exist.
  Future<List<Twenty48Save>> getManualSaves() {
    return (select(twenty48Saves)
          ..where((tbl) => tbl.slotIndex.isBetweenValues(1, 3))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.slotIndex)]))
        .get();
  }

  /// Check if an auto-save exists.
  Future<bool> hasAutoSave() async {
    final save = await getAutoSave();
    return save != null;
  }

  /// Check if any manual saves exist.
  Future<bool> hasManualSaves() async {
    final saves = await getManualSaves();
    return saves.isNotEmpty;
  }

  /// Get the first available empty manual slot index (slots 1-3).
  /// Returns -1 if all manual slots are full.
  Future<int> getFirstEmptyManualSlot() async {
    final saves = await getManualSaves();
    final occupiedSlots = saves.map((s) => s.slotIndex).toSet();

    for (int i = 1; i <= 3; i++) {
      if (!occupiedSlots.contains(i)) {
        return i;
      }
    }
    return -1;
  }
}
