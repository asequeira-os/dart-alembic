import 'connector.dart';
import 'migration.dart';

class MigrationsExecutor {
  final Migrations migrations;

  MigrationsExecutor(this.migrations);

  Future<void> execute(AlembicConnector conn) async {
    //await conn.open();
    await conn.ensureMigrationTable();
    final appliedMigs = await _dbRows(conn);

    if (appliedMigs.isNotEmpty) {
      // verify the lists match
      final k = appliedMigs.length;
      final _mlist = migrations.migrations.toList();
      for (var i = 0; i < k; i++) {
        final mid1 = appliedMigs[i].id;
        final mid1b = _mlist[i].migrationId;
        if (mid1 != mid1b) {
          throw Exception('applied migrations order mismatch: $mid1 != $mid1b');
        }
      }
    }

    final k = appliedMigs.length;
    var i = 0;
    for (final migration in migrations.migrations) {
      i++;
      if (i <= k) continue; // already applied

      await migration.execute(conn);
      await conn.addMigration(migration.asDbRow);
    }
  }

  Future<List<MigrationRow>> _dbRows(AlembicConnector conn) async {
    final tbl = conn.migrationTable;
    final resp = await conn.query('SELECT * from $tbl ORDER BY created asc');

    if (resp.isEmpty) return [];

    // ignore: omit_local_variable_types
    List<MigrationRow> migs = [];

    for (final tblrow in resp) {
      final row = tblrow[tbl];
      print(row);
      final mig = MigrationRow.fromJson(row!);
      migs.add(mig);
    }

    return migs;
  }
}
