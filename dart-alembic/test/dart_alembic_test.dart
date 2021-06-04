import 'package:dart_alembic/dart_alembic.dart';
import 'package:dart_alembic/src/connector.dart';
import 'package:test/test.dart';

import 'init_db.dart';

void main() {
  group('A group of tests', () {
    final awesome = Awesome();
    late AlembicConnector conn;

    setUp(() async {
      conn = await makeTestDatabase();
    });

    tearDown(() async {
      await conn.close();
      await dropTestDatabase();
    });

    test('DB basic operations check', () async {
      final chars36 = '012345678901234567890123456789123456';
      final tbl = PostgresAlembicConnector.migrationTable;
      assert(conn.isOpen);
      await conn.ensureMigrationTable();
      await conn.query(
          '''INSERT INTO $tbl (migration_id, name) VALUES ('$chars36', 'fooo')''');
      final foo = await conn.query('select migration_id from $tbl');
      expect(foo, [
        {
          tbl: {'migration_id': chars36}
        }
      ]);
      expect(awesome.isAwesome, isTrue);
    });
  });
}
