import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

/// Opens a database connection for native platforms.
/// Supports: iOS, Android, macOS, Windows, Linux
LazyDatabase openConnection() {
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

/// Creates an in-memory database for testing purposes.
DatabaseConnection createMemoryConnection() {
  return DatabaseConnection(NativeDatabase.memory());
}
