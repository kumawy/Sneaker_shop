import 'package:drift/drift.dart';

QueryExecutor createConnection() {
  return LazyDatabase(() async {
    throw UnsupportedError(
        'Drift SQLite native database is disabled on web in this assignment ZIP. ');
  });
}
