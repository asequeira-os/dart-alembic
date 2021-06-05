import 'package:dart_alembic/src/connector.dart';
import 'package:dart_alembic/src/executor.dart';
import 'package:dart_alembic/src/migration.dart';
import 'package:test/test.dart';

import 'init_db.dart';

class MigrationA extends Migration {
  int counter = 0;
  MigrationA() : super('make table foo');

  @override
  Future<void> execute(AlembicConnector conn) async {
    counter++;
    print('executing migration a');
    await conn.query('''
      CREATE TABLE links (
        link_id serial PRIMARY KEY,
        title VARCHAR (512) NOT NULL,
        url VARCHAR (1024) NOT NULL)
    ''');
  }
}

class MigrationB extends Migration {
  int counter = 0;
  MigrationB() : super('alter table foo');

  @override
  Future<void> execute(AlembicConnector conn) async {
    counter++;
    print('executing migration b');
    await conn.query('''
      ALTER TABLE links
      ADD COLUMN active boolean
    ''');
  }
}

class MigrationC extends Migration {
  int counter = 0;
  MigrationC() : super('table ccc');

  @override
  Future<void> execute(AlembicConnector conn) async {
    counter++;
    print('executing migration ccc');
    await conn.query('''
      ALTER TABLE links 
      RENAME COLUMN title TO link_title
    ''');
  }
}

void main() {
  const DBNAME = '_unit_test_2';

  group('migrations run test', () {
    late AlembicConnector conn;

    setUp(() async {
      conn = await makeTestDatabase(DBNAME);
    });

    tearDown(() async {
      await conn.close();
      await dropTestDatabase(DBNAME);
    });

    test('should run two sets', () async {
      final migs = Migrations();
      final m1 = MigrationA();
      final m2 = MigrationB();
      final m3 = MigrationC();

      migs.add(m1);
      migs.add(m2);

      await MigrationsExecutor(migs).execute(conn);
      expect(m1.counter, 1);
      expect(m2.counter, 1);
      expect(m3.counter, 0);

      migs.add(m3);
      await MigrationsExecutor(migs).execute(conn);
      expect(m1.counter, 1);
      expect(m2.counter, 1);
      expect(m3.counter, 1);

      await MigrationsExecutor(migs).execute(conn);
      expect(m1.counter, 1);
      expect(m2.counter, 1);
      expect(m3.counter, 1);
      // should not throw
      await conn.query('SELECT * from links');
    });
  });
}
