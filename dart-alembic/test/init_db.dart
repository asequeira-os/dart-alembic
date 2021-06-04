import 'package:dart_alembic/src/connector.dart';
import 'package:postgres/postgres.dart';

const TEST_DB_HOST = 'db00a';
const TEST_DB_NAME = 'testdb1';

PostgreSQLConnection admin_conn() => PostgreSQLConnection(
      TEST_DB_HOST,
      5432,
      'postgres',
      username: 'db00auser',
      password: 'db00apass',
    );

Future<AlembicConnector> makeTestDatabase() async {
  final _admin_conn = admin_conn();
  await _admin_conn.open();

  await _admin_conn.query('DROP DATABASE IF EXISTS $TEST_DB_NAME');

  try {
    await _admin_conn.query('CREATE DATABASE $TEST_DB_NAME');
  } on PostgreSQLException catch (e) {
    if (e.code != '42P04') rethrow;
  } finally {
    await _admin_conn.close();
  }

  final _conn = PostgreSQLConnection(
    TEST_DB_HOST,
    5432,
    TEST_DB_NAME,
    username: 'db00auser',
    password: 'db00apass',
  );

  await _conn.open();

  return PostgresAlembicConnector(_conn);
}

Future<void> dropTestDatabase() async {
  final _admin_conn = admin_conn();
  await _admin_conn.open();
  await _admin_conn.query('DROP DATABASE IF EXISTS $TEST_DB_NAME');
  await _admin_conn.close();
}
