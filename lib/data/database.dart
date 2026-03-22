import 'package:drift/drift.dart';

import 'database/connection/connection.dart';
import 'daos/game_records_dao.dart';
import 'daos/game_settings_dao.dart';
import 'daos/user_progress_dao.dart';
import 'daos/yacht_dice_saves_dao.dart';
import 'daos/twenty48_saves_dao.dart';
import 'tables/game_records.dart';
import 'tables/game_settings.dart';
import 'tables/user_progress.dart';
import 'tables/yacht_dice_saves.dart';
import 'tables/twenty48_saves.dart';

part 'database.g.dart';

/// The main database class for the MiniGames application.
/// Supports all platforms: iOS, Android, Windows, macOS, Linux, and Web.
@DriftDatabase(
  tables: [
    GameRecords,
    GameSettings,
    UserProgress,
    YachtDiceSaves,
    Twenty48Saves,
  ],
  daos: [
    GameRecordsDao,
    GameSettingsDao,
    UserProgressDao,
    YachtDiceSavesDao,
    Twenty48SavesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Creates a new AppDatabase instance.
  AppDatabase() : super(openConnection());

  /// Creates an in-memory database for testing purposes.
  AppDatabase.memory() : super(createMemoryConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Add migration logic here when schema changes
        if (from < 2) {
          // Add yacht_dice_saves table for game state persistence
          await m.createTable(yachtDiceSaves);
        }
        if (from < 3) {
          // Add twenty48_saves table for 2048 game state persistence
          await m.createTable(twenty48Saves);
        }
      },
    );
  }
}
