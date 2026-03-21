import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'daos/game_records_dao.dart';
import 'daos/game_settings_dao.dart';
import 'daos/user_progress_dao.dart';
import 'daos/yacht_dice_saves_dao.dart';
import 'tables/game_records.dart';
import 'tables/game_settings.dart';
import 'tables/user_progress.dart';
import 'tables/yacht_dice_saves.dart';

part 'database.g.dart';

/// The main database class for the MiniGames application.
/// Supports all platforms: iOS, Android, Windows, macOS, Linux, and Web.
@DriftDatabase(
  tables: [GameRecords, GameSettings, UserProgress, YachtDiceSaves],
  daos: [GameRecordsDao, GameSettingsDao, UserProgressDao, YachtDiceSavesDao],
)
class AppDatabase extends _$AppDatabase {
  /// Creates a new AppDatabase instance.
  AppDatabase() : super(_openConnection());

  /// Creates an in-memory database for testing purposes.
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 2;

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
      },
    );
  }
}

/// Opens a database connection with platform-specific configuration.
/// Supports all platforms: iOS, Android, Windows, macOS, Linux, and Web.
LazyDatabase _openConnection() {
  // LazyDatabase allows async initialization
  return LazyDatabase(() async {
    // Get the database file location
    final dbFolder = await _getDatabaseDirectory();
    final file = File(p.join(dbFolder.path, 'minigames.db'));

    // Ensure the database file exists
    if (!await file.exists()) {
      debugPrint('Creating new database at ${file.path}');
    }

    // Apply Android-specific workaround for older versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Set up SQLite temp directory
    final cacheBase = (await getTemporaryDirectory()).path;
    sqlite.sqlite3.tempDirectory = cacheBase;

    debugPrint('Database opened at ${file.path}');
    return NativeDatabase.createInBackground(file);
  });
}

/// Gets the platform-specific database directory.
Future<Directory> _getDatabaseDirectory() async {
  if (kIsWeb) {
    // Web platform - use a virtual directory (drift handles this internally)
    throw UnsupportedError(
      'Web platform should use drift web support. '
      'Add drift_flutter or use DriftWebStorage.',
    );
  }

  // Get platform-specific application support directory
  if (Platform.isIOS || Platform.isMacOS) {
    return getApplicationDocumentsDirectory();
  } else if (Platform.isAndroid) {
    return getApplicationDocumentsDirectory();
  } else if (Platform.isWindows || Platform.isLinux) {
    return getApplicationSupportDirectory();
  } else {
    // Fallback to application documents directory
    return getApplicationDocumentsDirectory();
  }
}

/// Alternative constructor for web platform support.
/// This is used when building for web target.
AppDatabase createWebDatabase() {
  throw UnimplementedError(
    'Web database requires drift_flutter or drift/web.dart. '
    'Please add appropriate web support dependencies.',
  );
}
