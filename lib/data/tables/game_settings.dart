import 'package:drift/drift.dart';

/// Table for storing game-specific settings.
/// Each game type has its own settings row with preferences.
@DataClassName('GameSetting')
class GameSettings extends Table {
  /// Unique identifier for the setting.
  IntColumn get id => integer().autoIncrement()();

  /// Type of game these settings apply to.
  TextColumn get gameType => text()();

  /// Difficulty level for the game.
  TextColumn get difficulty => text().withDefault(const Constant('normal'))();

  /// Whether sound effects are enabled.
  BoolColumn get soundEnabled => boolean().withDefault(const Constant(true))();

  /// When these settings were created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
