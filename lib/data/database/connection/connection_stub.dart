import 'package:drift/drift.dart';

/// Stub implementation for database connection.
/// This file is used as a fallback and should never be actually imported
/// because either dart:io or dart:js will be available.
///
/// This is only here to satisfy Dart's conditional import requirements.
DatabaseConnection openConnection() {
  throw UnsupportedError(
    'No database implementation available for this platform. '
    'This should never happen - please report this as a bug.',
  );
}

/// Creates an in-memory database connection (stub).
DatabaseConnection createMemoryConnection() {
  throw UnsupportedError(
    'No database implementation available for this platform. '
    'This should never happen - please report this as a bug.',
  );
}
