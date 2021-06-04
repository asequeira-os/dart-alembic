import 'package:dart_alembic/src/connector.dart';
import 'package:test/test.dart';

import 'init_db.dart';

void main() {
  const DBNAME = '_unit_test_1';
  group('migration utilities tests', () {
    late AlembicConnector conn;

    setUp(() async {
      conn = await makeTestDatabase(DBNAME);
    });

    tearDown(() async {
      await conn.close();
      await dropTestDatabase(DBNAME);
    });

    test('DB basic operations check', () async {
      final chars36 = '012345678901234567890123456789123456';
      final tbl = conn.migrationTable;
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
    });
  });
}
