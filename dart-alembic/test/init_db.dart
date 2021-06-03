import 'package:postgres/postgres.dart';

const TEST_DB_HOST = "db00a";
const TEST_DB_NAME = "testdb1";

Future<PostgreSQLConnection> makeTestDatabase() async {
  final connection = PostgreSQLConnection(TEST_DB_HOST, 5432, "postgres",
      username: "db00auser", password: "db00apass");
  await connection.open();

  await connection.query('CREATE DATABASE $TEST_DB_NAME');

  return connection;
}

Future<void> dropTestDatabase(PostgreSQLConnection conn) async {
  await conn.query('DROP DATABASE IF EXISTS $TEST_DB_NAME');
}
