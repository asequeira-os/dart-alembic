import 'connector.dart';
import 'migration.dart';

class MigrationsExecutor {
  final Migrations migrations;

  MigrationsExecutor(this.migrations);

  Future<void> execute(AlembicConnector conn) async {
    //await conn.open();
    await conn.ensureMigrationTable();
    final foo = await _dbRows(conn);
  }

  Future<List<MigrationRow>> _dbRows(AlembicConnector conn) async {
    final tbl = conn.migrationTable;
    final resp = await conn.query('SELECT * from $tbl');
    if (resp.isEmpty) return [];
    final rows = resp[0][tbl];
    print(rows);
    // TODO 0 AAS WIP 

    return [];
  }
}
