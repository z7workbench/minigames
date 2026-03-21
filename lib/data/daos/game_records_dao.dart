import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/game_records.dart';

part 'game_records_dao.g.dart';

/// Data Access Object for game records.
/// Provides methods to query, insert, and delete game records.
@DriftAccessor(tables: [GameRecords])
class GameRecordsDao extends DatabaseAccessor<AppDatabase>
    with _$GameRecordsDaoMixin {
  /// Creates a new GameRecordsDao with the given database.
  GameRecordsDao(super.db);

  /// Inserts a new game record.
  /// Returns the ID of the inserted record.
  Future<int> insertRecord(GameRecordsCompanion record) {
    return into(gameRecords).insert(record);
  }

  /// Gets all records for a specific game type.
  /// Results are ordered by played date in descending order.
  Future<List<GameRecord>> getRecordsByGameType(String gameType) {
    return (select(gameRecords)
          ..where((tbl) => tbl.gameType.equals(gameType))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.playedAt)]))
        .get();
  }

  /// Watches all records for a specific game type.
  /// Results are ordered by played date in descending order.
  Stream<List<GameRecord>> watchRecordsByGameType(String gameType) {
    return (select(gameRecords)
          ..where((tbl) => tbl.gameType.equals(gameType))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.playedAt)]))
        .watch();
  }

  /// Gets the highest score for a specific game type.
  /// Returns null if no records exist for the game type.
  Future<GameRecord?> getHighScoreByGameType(String gameType) {
    return (select(gameRecords)
          ..where((tbl) => tbl.gameType.equals(gameType))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.score)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Watches the highest score for a specific game type.
  /// Emits null if no records exist for the game type.
  Stream<GameRecord?> watchHighScoreByGameType(String gameType) {
    return (select(gameRecords)
          ..where((tbl) => tbl.gameType.equals(gameType))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.score)])
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Gets recent game records with a limit.
  /// Results are ordered by played date in descending order.
  Future<List<GameRecord>> getRecentGames({int limit = 10}) {
    return (select(gameRecords)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.playedAt)])
          ..limit(limit))
        .get();
  }

  /// Watches recent game records with a limit.
  /// Results are ordered by played date in descending order.
  Stream<List<GameRecord>> watchRecentGames({int limit = 10}) {
    return (select(gameRecords)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.playedAt)])
          ..limit(limit))
        .watch();
  }

  /// Deletes all game records.
  /// Returns the number of deleted records.
  Future<int> deleteAllRecords() {
    return delete(gameRecords).go();
  }

  /// Deletes all records for a specific game type.
  /// Returns the number of deleted records.
  Future<int> deleteRecordsByGameType(String gameType) {
    return (delete(
      gameRecords,
    )..where((tbl) => tbl.gameType.equals(gameType))).go();
  }

  /// Gets the total count of records for a specific game type.
  Future<int> getRecordCountByGameType(String gameType) async {
    final query = selectOnly(gameRecords)
      ..where(gameRecords.gameType.equals(gameType))
      ..addColumns([gameRecords.id.count()]);
    final result = await query.getSingle();
    return result.read(gameRecords.id.count()) ?? 0;
  }

  /// Gets records within a date range.
  Future<List<GameRecord>> getRecordsByDateRange(
    String gameType,
    DateTime start,
    DateTime end,
  ) {
    return (select(gameRecords)
          ..where(
            (tbl) =>
                tbl.gameType.equals(gameType) &
                tbl.playedAt.isBiggerOrEqualValue(start) &
                tbl.playedAt.isSmallerOrEqualValue(end),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.playedAt)]))
        .get();
  }
}
