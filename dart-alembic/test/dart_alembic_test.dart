import 'package:dart_alembic/dart_alembic.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';

import 'init_db.dart';

void main() {
  group('A group of tests', () {
    final awesome = Awesome();
    late PostgreSQLConnection conn;

    setUp(() async {
      conn = await makeTestDatabase();
    });

    tearDown(() async {
      await dropTestDatabase(conn);
      await conn.close();
    });

    test('First Test', () async {
      assert(!conn.isClosed);
      expect(awesome.isAwesome, isTrue);
    });
  });
}
