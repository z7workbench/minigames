// Platform-specific database connection.
//
// This file uses conditional imports to select the appropriate
// implementation based on the target platform:
// - Web: uses drift/web with sql.js
// - Native (iOS, Android, macOS, Windows, Linux): uses drift/native with sqlite3
//
// The export is automatically selected by Dart's conditional import mechanism.
export 'connection_stub.dart'
    if (dart.library.io) 'native.dart'
    if (dart.library.js) 'web.dart';
