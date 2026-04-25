import 'package:drift/drift.dart';

import 'database/connection/connection.dart';
import 'daos/game_records_dao.dart';
import 'daos/game_settings_dao.dart';
import 'daos/user_progress_dao.dart';
import 'daos/yacht_dice_saves_dao.dart';
import 'daos/twenty48_saves_dao.dart';
import 'daos/mancala_saves_dao.dart';
import 'daos/hearts_saves_dao.dart';
import 'daos/bluff_bar_saves_dao.dart';
import 'tables/game_records.dart';
import 'tables/game_settings.dart';
import 'tables/user_progress.dart';
import 'tables/yacht_dice_saves.dart';
import 'tables/twenty48_saves.dart';
import 'tables/mancala_saves.dart';
import 'tables/hearts_saves.dart';
import 'tables/bluff_bar_saves.dart';

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
    MancalaSaves,
    HeartsSaves,
    BluffBarSaves,
  ],
  daos: [
    GameRecordsDao,
    GameSettingsDao,
    UserProgressDao,
    YachtDiceSavesDao,
    Twenty48SavesDao,
    MancalaSavesDao,
    HeartsSavesDao,
    BluffBarSavesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Creates a new AppDatabase instance.
  AppDatabase() : super(openConnection());

  /// Creates an in-memory database for testing purposes.
  AppDatabase.memory() : super(createMemoryConnection());

  @override
  int get schemaVersion => 7;

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
        if (from < 4) {
          // Add mancala_saves table for Mancala game state persistence
          await m.createTable(mancalaSaves);
        }
        if (from < 5) {
          // Add hearts_saves table for Hearts game state persistence
          await m.createTable(heartsSaves);
        }
        if (from < 6) {
          // Add unique constraint to twenty48_saves.slotIndex
          // First clean up any duplicate slots (keep the most recent)
          await customStatement(
            'DELETE FROM twenty48_saves WHERE id NOT IN '
            '(SELECT MAX(id) FROM twenty48_saves GROUP BY slot_index)',
          );
          await m.alterTable(TableMigration(twenty48Saves));
        }
        if (from < 7) {
          // Add bluff_bar_saves table for Bluff Bar game state persistence
          await m.createTable(bluffBarSaves);
        }
      },
    );
  }
}
