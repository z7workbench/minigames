import 'package:drift/drift.dart';

/// Table for storing user progress across all games.
/// Tracks cumulative statistics for each game type.
@DataClassName('UserProgressData')
class UserProgress extends Table {
  /// Unique identifier for the progress record.
  IntColumn get id => integer().autoIncrement()();

  /// Type of game this progress applies to.
  TextColumn get gameType => text()();

  /// Total number of games played for this game type.
  IntColumn get totalGamesPlayed => integer().withDefault(const Constant(0))();

  /// Total time played in seconds for this game type.
  IntColumn get totalTimePlayed => integer().withDefault(const Constant(0))();

  /// Highest score achieved for this game type.
  IntColumn get highScore => integer().withDefault(const Constant(0))();

  /// When this progress was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
