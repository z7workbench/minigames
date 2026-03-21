import 'package:drift/drift.dart';

/// Table for storing individual game play records.
/// Each record represents a single game session with its score and metadata.
@DataClassName('GameRecord')
class GameRecords extends Table {
  /// Unique identifier for the record.
  IntColumn get id => integer().autoIncrement()();

  /// Type of game played (e.g., 'hit_and_blow', 'yacht_dice').
  TextColumn get gameType => text().withLength(min: 1, max: 50)();

  /// Score achieved in this game session.
  IntColumn get score => integer().withDefault(const Constant(0))();

  /// Duration of the game in seconds.
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();

  /// Difficulty level of the game (e.g., 'easy', 'normal', 'hard').
  TextColumn get difficulty => text().nullable()();

  /// When the game was played.
  DateTimeColumn get playedAt => dateTime().withDefault(currentDateAndTime)();

  /// When this record was created in the database.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
