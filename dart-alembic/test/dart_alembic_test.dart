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
      final tbl = PostgresAlembicConnector.migrationTable;
      assert(conn.isOpen);
      await conn.ensureMigrationTable();
      await conn.query('''INSERT INTO $tbl (migration_id, name) VALUES ('ZZZZ', 'fooo')''');
      final foo = await conn.query('select migration_id from $tbl');
      expect(foo, [
        {
          tbl: {'migration_id': 'ZZZZ'}
        }
      ]);
      expect(awesome.isAwesome, isTrue);
    });
  });
}
