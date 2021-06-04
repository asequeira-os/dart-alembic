import 'package:postgres/postgres.dart';

typedef SqlRows = List<Map<String, Map<String, dynamic>>>;

abstract class AlembicConnector {
  Future<void> open();
  Future<void> close();
  bool get isOpen;

  Future<void> ensureMigrationTable();
  Future<void> ddl(String sql);
  Future<SqlRows> query(String sql);
}

class PostgresAlembicConnector extends AlembicConnector {
  final PostgreSQLConnection conn;
  static const migrationTable = '__migration';
  static const _tableSql = '''
    CREATE TABLE IF NOT EXISTS $migrationTable (
      migration_id varchar(45) NOT NULL,
      created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
  ''';

  PostgresAlembicConnector(this.conn);

  @override
  Future<void> open() async {
    await conn.open();
  }

  @override
  Future<void> close() async {
    await conn.close();
  }

  @override
  bool get isOpen => !conn.isClosed;

  @override
  Future<void> ddl(String sql) async {
    await conn.query(sql);
  }

  @override
  Future<void> ensureMigrationTable() async {
    await conn.query(_tableSql);
  }

  @override
  Future<SqlRows> query(String sql) {
    return conn.mappedResultsQuery(sql);
  }
}
