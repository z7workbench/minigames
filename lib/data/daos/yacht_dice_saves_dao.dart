import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/yacht_dice_saves.dart';

part 'yacht_dice_saves_dao.g.dart';

/// Data Access Object for Yacht Dice game saves.
/// Provides methods to save, load, and delete game progress.
@DriftAccessor(tables: [YachtDiceSaves])
class YachtDiceSavesDao extends DatabaseAccessor<AppDatabase>
    with _$YachtDiceSavesDaoMixin {
  /// Creates a new YachtDiceSavesDao with the given database.
  YachtDiceSavesDao(super.db);

  /// Save current game state.
  /// Returns the ID of the inserted save.
  Future<int> saveGame(YachtDiceSavesCompanion save) {
    return into(yachtDiceSaves).insert(save);
  }

  /// Get most recent save for a specific game type and difficulty.
  /// Returns null if no save exists.
  Future<YachtDiceSave?> getMostRecentSave(
    String gameType, [
    String? difficulty,
  ]) {
    final query = select(yachtDiceSaves)
      ..where((tbl) => tbl.gameType.equals(gameType))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.savedAt)])
      ..limit(1);

    if (difficulty != null) {
      query.where((tbl) => tbl.difficulty.equals(difficulty));
    } else {
      query.where((tbl) => tbl.difficulty.isNull());
    }

    return query.getSingleOrNull();
  }

  /// Get all saves for a specific game type.
  /// Results are ordered by saved date in descending order.
  Future<List<YachtDiceSave>> getSavesByGameType(String gameType) {
    return (select(yachtDiceSaves)
          ..where((tbl) => tbl.gameType.equals(gameType))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.savedAt)]))
        .get();
  }

  /// Delete a specific save by ID.
  /// Returns the number of deleted rows.
  Future<int> deleteSave(int id) {
    return (delete(yachtDiceSaves)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Delete all saves for a specific game type.
  /// Returns the number of deleted rows.
  Future<int> deleteAllSavesForGame(String gameType) {
    return (delete(
      yachtDiceSaves,
    )..where((tbl) => tbl.gameType.equals(gameType))).go();
  }

  /// Delete all saves for a specific game type and difficulty.
  /// Returns the number of deleted rows.
  Future<int> deleteSavesByGameTypeAndDifficulty(
    String gameType,
    String? difficulty,
  ) {
    final query = delete(yachtDiceSaves)
      ..where((tbl) => tbl.gameType.equals(gameType));

    if (difficulty != null) {
      query.where((tbl) => tbl.difficulty.equals(difficulty));
    } else {
      query.where((tbl) => tbl.difficulty.isNull());
    }

    return query.go();
  }

  /// Check if a save exists for the given game type and difficulty.
  Future<bool> hasSave(String gameType, [String? difficulty]) async {
    final save = await getMostRecentSave(gameType, difficulty);
    return save != null;
  }

  /// Get the count of saves for a specific game type.
  Future<int> getSaveCount(String gameType) async {
    final query = selectOnly(yachtDiceSaves)
      ..where(yachtDiceSaves.gameType.equals(gameType))
      ..addColumns([yachtDiceSaves.id.count()]);
    final result = await query.getSingle();
    return result.read(yachtDiceSaves.id.count()) ?? 0;
  }
}
