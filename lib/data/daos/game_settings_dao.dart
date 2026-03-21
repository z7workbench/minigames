import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/game_settings.dart';

part 'game_settings_dao.g.dart';

/// Data Access Object for game settings.
/// Provides methods to query and update game-specific settings.
@DriftAccessor(tables: [GameSettings])
class GameSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$GameSettingsDaoMixin {
  /// Creates a new GameSettingsDao with the given database.
  GameSettingsDao(super.db);

  /// Gets settings for a specific game type.
  /// Returns null if no settings exist for the game type.
  Future<GameSetting?> getSettingsByGameType(String gameType) {
    return (select(gameSettings)
          ..where((tbl) => tbl.gameType.equals(gameType))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Watches settings for a specific game type.
  /// Emits null if no settings exist for the game type.
  Stream<GameSetting?> watchSettingsByGameType(String gameType) {
    return (select(gameSettings)
          ..where((tbl) => tbl.gameType.equals(gameType))
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Saves settings for a game type.
  /// If settings already exist, they will be replaced.
  Future<int> saveSettings(GameSettingsCompanion settings) {
    return into(gameSettings).insertOnConflictUpdate(settings);
  }

  /// Updates the difficulty for a game type.
  /// Creates settings if they don't exist.
  Future<void> updateDifficulty(String gameType, String difficulty) async {
    final existing = await getSettingsByGameType(gameType);
    if (existing != null) {
      await (update(gameSettings)
            ..where((tbl) => tbl.gameType.equals(gameType)))
          .write(GameSettingsCompanion(difficulty: Value(difficulty)));
    } else {
      await saveSettings(
        GameSettingsCompanion.insert(
          gameType: gameType,
          difficulty: Value(difficulty),
        ),
      );
    }
  }

  /// Updates the sound enabled setting for a game type.
  /// Creates settings if they don't exist.
  Future<void> updateSoundEnabled(String gameType, bool enabled) async {
    final existing = await getSettingsByGameType(gameType);
    if (existing != null) {
      await (update(gameSettings)
            ..where((tbl) => tbl.gameType.equals(gameType)))
          .write(GameSettingsCompanion(soundEnabled: Value(enabled)));
    } else {
      await saveSettings(
        GameSettingsCompanion.insert(
          gameType: gameType,
          soundEnabled: Value(enabled),
        ),
      );
    }
  }

  /// Updates a specific setting for a game type.
  /// Creates settings with defaults if they don't exist.
  Future<void> updateSetting({
    required String gameType,
    String? difficulty,
    bool? soundEnabled,
  }) async {
    final existing = await getSettingsByGameType(gameType);
    if (existing != null) {
      final updates = GameSettingsCompanion();
      if (difficulty != null) {
        updates.copyWith(difficulty: Value(difficulty));
      }
      if (soundEnabled != null) {
        updates.copyWith(soundEnabled: Value(soundEnabled));
      }
      await (update(
        gameSettings,
      )..where((tbl) => tbl.gameType.equals(gameType))).write(updates);
    } else {
      await saveSettings(
        GameSettingsCompanion.insert(
          gameType: gameType,
          difficulty: difficulty != null
              ? Value(difficulty)
              : const Value.absent(),
          soundEnabled: soundEnabled != null
              ? Value(soundEnabled)
              : const Value.absent(),
        ),
      );
    }
  }

  /// Gets all game settings.
  Future<List<GameSetting>> getAllSettings() {
    return select(gameSettings).get();
  }

  /// Watches all game settings.
  Stream<List<GameSetting>> watchAllSettings() {
    return select(gameSettings).watch();
  }

  /// Deletes settings for a specific game type.
  /// Returns the number of deleted records.
  Future<int> deleteSettingsByGameType(String gameType) {
    return (delete(
      gameSettings,
    )..where((tbl) => tbl.gameType.equals(gameType))).go();
  }

  /// Deletes all game settings.
  /// Returns the number of deleted records.
  Future<int> deleteAllSettings() {
    return delete(gameSettings).go();
  }
}
