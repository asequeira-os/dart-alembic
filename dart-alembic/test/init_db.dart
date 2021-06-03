import 'package:postgres/postgres.dart';

const TEST_DB_HOST = "db00a";

Future<PostgreSQLConnection> makeTestDatabase() async {
  final connection = PostgreSQLConnection(TEST_DB_HOST, 5432, "postgres",
      username: "db00auser", password: "db00apass");
  await connection.open();
  return connection;
}
