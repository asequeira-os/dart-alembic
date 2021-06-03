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

    test('First Test', () async {
      assert(!conn.isClosed);
      await conn.close();
      expect(awesome.isAwesome, isTrue);
    });
  });
}
