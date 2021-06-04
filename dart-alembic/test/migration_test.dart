import 'package:dart_alembic/src/connector.dart';
import 'package:dart_alembic/src/executor.dart';
import 'package:dart_alembic/src/migration.dart';
import 'package:test/test.dart';

import 'init_db.dart';

class MigrationA extends Migration {
  MigrationA() : super('make table foo');

  @override
  void execute(AlembicConnector conn) {
    print('executing migration a');
  }
}

class MigrationB extends Migration {
  MigrationB() : super('alter table foo');

  @override
  void execute(AlembicConnector conn) {
    print('executing migration b');
  }
}

class MigrationC extends Migration {
  MigrationC() : super('table ccc');

  @override
  void execute(AlembicConnector conn) {
    print('executing migration ccc');
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

    test('Migrations should run', () async {
      final migs = Migrations();
      migs.add(MigrationA());
      migs.add(MigrationB());

      await MigrationsExecutor(migs).execute(conn);

      migs.add(MigrationC());
      await MigrationsExecutor(migs).execute(conn);
    });
  });
}
