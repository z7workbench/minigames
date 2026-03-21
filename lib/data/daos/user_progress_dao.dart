import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/user_progress.dart';

part 'user_progress_dao.g.dart';

/// Data Access Object for user progress.
/// Provides methods to query and update user progress across games.
@DriftAccessor(tables: [UserProgress])
class UserProgressDao extends DatabaseAccessor<AppDatabase>
    with _$UserProgressDaoMixin {
  /// Creates a new UserProgressDao with the given database.
  UserProgressDao(super.db);

  /// Gets progress for a specific game type.
  /// Returns null if no progress exists for the game type.
  Future<UserProgressData?> getProgressByGameType(String gameType) {
    return (select(userProgress)
          ..where((tbl) => tbl.gameType.equals(gameType))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Watches progress for a specific game type.
  /// Emits null if no progress exists for the game type.
  Stream<UserProgressData?> watchProgressByGameType(String gameType) {
    return (select(userProgress)
          ..where((tbl) => tbl.gameType.equals(gameType))
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Updates progress for a game type.
  /// Creates progress if it doesn't exist.
  Future<void> updateProgress({
    required String gameType,
    int? totalGamesPlayed,
    int? totalTimePlayed,
    int? highScore,
  }) async {
    final existing = await getProgressByGameType(gameType);
    if (existing != null) {
      final companion = UserProgressCompanion(updatedAt: Value(DateTime.now()));
      if (totalGamesPlayed != null) {
        companion.copyWith(totalGamesPlayed: Value(totalGamesPlayed));
      }
      if (totalTimePlayed != null) {
        companion.copyWith(totalTimePlayed: Value(totalTimePlayed));
      }
      if (highScore != null) {
        companion.copyWith(highScore: Value(highScore));
      }
      await (update(
        userProgress,
      )..where((tbl) => tbl.gameType.equals(gameType))).write(companion);
    } else {
      await into(userProgress).insert(
        UserProgressCompanion.insert(
          gameType: gameType,
          totalGamesPlayed: Value(totalGamesPlayed ?? 0),
          totalTimePlayed: Value(totalTimePlayed ?? 0),
          highScore: Value(highScore ?? 0),
        ),
      );
    }
  }

  /// Increments the games played count and optionally updates high score.
  /// Creates progress if it doesn't exist.
  Future<void> incrementGamesPlayed({
    required String gameType,
    required int durationSeconds,
    int? score,
  }) async {
    final existing = await getProgressByGameType(gameType);
    if (existing != null) {
      final newHighScore = score != null && score > existing.highScore
          ? score
          : existing.highScore;
      await (update(
        userProgress,
      )..where((tbl) => tbl.gameType.equals(gameType))).write(
        UserProgressCompanion(
          totalGamesPlayed: Value(existing.totalGamesPlayed + 1),
          totalTimePlayed: Value(existing.totalTimePlayed + durationSeconds),
          highScore: Value(newHighScore),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await into(userProgress).insert(
        UserProgressCompanion.insert(
          gameType: gameType,
          totalGamesPlayed: const Value(1),
          totalTimePlayed: Value(durationSeconds),
          highScore: Value(score ?? 0),
        ),
      );
    }
  }

  /// Updates the high score for a game type if the new score is higher.
  /// Returns true if the high score was updated.
  Future<bool> updateHighScoreIfHigher(String gameType, int score) async {
    final existing = await getProgressByGameType(gameType);
    if (existing != null) {
      if (score > existing.highScore) {
        await (update(
          userProgress,
        )..where((tbl) => tbl.gameType.equals(gameType))).write(
          UserProgressCompanion(
            highScore: Value(score),
            updatedAt: Value(DateTime.now()),
          ),
        );
        return true;
      }
      return false;
    } else {
      await into(userProgress).insert(
        UserProgressCompanion.insert(
          gameType: gameType,
          highScore: Value(score),
        ),
      );
      return true;
    }
  }

  /// Gets all user progress records.
  Future<List<UserProgressData>> getAllProgress() {
    return select(userProgress).get();
  }

  /// Watches all user progress records.
  Stream<List<UserProgressData>> watchAllProgress() {
    return select(userProgress).watch();
  }

  /// Gets the total games played across all games.
  Future<int> getTotalGamesPlayed() async {
    final query = selectOnly(userProgress)
      ..addColumns([userProgress.totalGamesPlayed.sum()]);
    final result = await query.getSingle();
    return result.read(userProgress.totalGamesPlayed.sum()) ?? 0;
  }

  /// Gets the total time played across all games in seconds.
  Future<int> getTotalTimePlayed() async {
    final query = selectOnly(userProgress)
      ..addColumns([userProgress.totalTimePlayed.sum()]);
    final result = await query.getSingle();
    return result.read(userProgress.totalTimePlayed.sum()) ?? 0;
  }

  /// Deletes progress for a specific game type.
  /// Returns the number of deleted records.
  Future<int> deleteProgressByGameType(String gameType) {
    return (delete(
      userProgress,
    )..where((tbl) => tbl.gameType.equals(gameType))).go();
  }

  /// Deletes all user progress.
  /// Returns the number of deleted records.
  Future<int> deleteAllProgress() {
    return delete(userProgress).go();
  }
}
