import 'connector.dart';
import 'migration.dart';

class MigrationsExecutor {
  final Migrations migrations;

  MigrationsExecutor(this.migrations);

  Future<void> execute(AlembicConnector conn) async {
    //await conn.open();
    await conn.ensureMigrationTable();
  }
}
