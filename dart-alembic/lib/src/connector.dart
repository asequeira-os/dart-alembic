import 'package:postgres/postgres.dart';

typedef SqlRows = List<Map<String, Map<String, dynamic>>>;
typedef QuerySubsitutions = Map<String, dynamic>;

class MigrationRow {
  final String name;
  final String id;
  final DateTime? created;

  MigrationRow(this.name, this.id) : created = null;
  MigrationRow.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['migration_id'],
        created = json['created'];

  QuerySubsitutions get insertParams {
    return {
      'migration_id': id,
      'name': name,
    };
  }
}

abstract class DbExecutor {
  Future<void> ddl(String sql, {QuerySubsitutions? params});
  Future<SqlRows> query(String sql, {QuerySubsitutions? params});
}

abstract class AlembicConnector extends DbExecutor {
  Future<void> open();
  Future<void> close();
  bool get isOpen;
  Future<void> transaction(
    Future<void> Function(DbExecutor txconn) callback,
  );

  Future<void> ensureMigrationTable();

  String get migrationTable;
  Future<void> addMigration(MigrationRow row);
}

class PostgresDbExecutor implements DbExecutor {
  final PostgreSQLExecutionContext conn;

  PostgresDbExecutor(this.conn);

  @override
  Future<void> ddl(String sql, {QuerySubsitutions? params}) async {
    await conn.query(sql, substitutionValues: params);
  }

  @override
  Future<SqlRows> query(String sql, {QuerySubsitutions? params}) {
    return conn.mappedResultsQuery(sql, substitutionValues: params);
  }
}

class PostgresAlembicConnector extends PostgresDbExecutor
    implements AlembicConnector {
  @override
  final PostgreSQLConnection conn;
  static const _migrationTable = '__migration';
  static const _tableSql = '''
    CREATE TABLE IF NOT EXISTS $_migrationTable (
      migration_id char(36) NOT NULL,
      name varchar(100) NOT NULL,
      created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
  ''';
  static const _insertSql = '''
    INSERT INTO $_migrationTable (migration_id, name) 
    VALUES (@migration_id, @name)
  ''';

  PostgresAlembicConnector(this.conn) : super(conn);

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
  Future<void> ensureMigrationTable() async {
    await conn.query(_tableSql);
  }

  @override
  String get migrationTable => _migrationTable;

  @override
  Future<void> addMigration(MigrationRow row) async {
    await query(_insertSql, params: row.insertParams);
  }

  @override
  Future<void> transaction(
    Future<void> Function(DbExecutor txconn) callback,
  ) async {
    await conn.transaction((ctx) async {
      await callback(PostgresDbExecutor(ctx));
    });
  }
}
