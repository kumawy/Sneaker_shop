import 'package:drift/drift.dart';

QueryExecutor createConnection() {
  return LazyDatabase(() async {
    throw UnsupportedError('Unsupported platform for local database.');
  });
}
