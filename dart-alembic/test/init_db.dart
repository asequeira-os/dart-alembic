import 'package:dart_alembic/src/connector.dart';
import 'package:postgres/postgres.dart';

const TEST_DB_HOST = 'db00a';

PostgreSQLConnection admin_conn() => PostgreSQLConnection(
      TEST_DB_HOST,
      5432,
      'postgres',
      username: 'db00auser',
      password: 'db00apass',
    );

Future<AlembicConnector> makeTestDatabase(String dbname) async {
  final _admin_conn = admin_conn();
  await _admin_conn.open();

  await _admin_conn.query('DROP DATABASE IF EXISTS $dbname');

  try {
    await _admin_conn.query('CREATE DATABASE $dbname');
  } on PostgreSQLException catch (e) {
    if (e.code != '42P04') rethrow;
  } finally {
    await _admin_conn.close();
  }

  final _conn = PostgreSQLConnection(
    TEST_DB_HOST,
    5432,
    dbname,
    username: 'db00auser',
    password: 'db00apass',
  );

  await _conn.open();

  return PostgresAlembicConnector(_conn);
}

Future<void> dropTestDatabase(String dbname) async {
  final _admin_conn = admin_conn();
  await _admin_conn.open();
  await _admin_conn.query('DROP DATABASE IF EXISTS $dbname');
  await _admin_conn.close();
}
