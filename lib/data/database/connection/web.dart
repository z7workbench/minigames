// ignore: deprecated_member_use
import 'package:drift/drift.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';

/// Opens a database connection for Web platform.
/// Uses sql.js (SQLite compiled to WebAssembly) via drift/web.
///
/// Note: drift/web.dart is deprecated in favor of drift/wasm.dart.
/// However, the wasm implementation requires additional setup:
/// - sqlite3.wasm file in web/
/// - drift_worker.js generation
/// For simplicity, we keep using the stable web implementation.
/// Consider migrating to wasm.dart in the future:
/// https://drift.simonbinder.eu/web
DatabaseConnection openConnection() {
  // WebDatabase uses IndexedDB for persistence
  // The database name 'minigames' will be used as the storage key
  return DatabaseConnection(WebDatabase('minigames'));
}

/// Creates a database connection for testing purposes on web.
DatabaseConnection createMemoryConnection() {
  // For web testing, use a separate database name
  return DatabaseConnection(WebDatabase('minigames_memory_test'));
}
