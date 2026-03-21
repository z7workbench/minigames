import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database.dart';
import '../daos/game_records_dao.dart';
import '../daos/game_settings_dao.dart';
import '../daos/user_progress_dao.dart';
import '../daos/yacht_dice_saves_dao.dart';

part 'database_provider.g.dart';

/// Provides the singleton instance of AppDatabase.
/// The database is created lazily and cached for the lifetime of the app.
@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  // Create the database instance
  final database = AppDatabase();

  // Ensure the database is closed when the provider is disposed
  ref.onDispose(() {
    database.close();
  });

  return database;
}

/// Provides the GameRecordsDao instance.
@riverpod
GameRecordsDao gameRecordsDao(GameRecordsDaoRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return database.gameRecordsDao;
}

/// Provides the GameSettingsDao instance.
@riverpod
GameSettingsDao gameSettingsDao(GameSettingsDaoRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return database.gameSettingsDao;
}

/// Provides the UserProgressDao instance.
@riverpod
UserProgressDao userProgressDao(UserProgressDaoRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return database.userProgressDao;
}

/// Provides the YachtDiceSavesDao instance.
@riverpod
YachtDiceSavesDao yachtDiceSavesDao(YachtDiceSavesDaoRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return database.yachtDiceSavesDao;
}
