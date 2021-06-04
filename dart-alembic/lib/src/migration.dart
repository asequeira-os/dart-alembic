import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Migration {
  /// should not be changed once specified.
  ///
  /// names have to be unique across migration instances
  final String name;

  Migration(this.name);

  /// generated using the name
  String get migrationId {
    return uuid.v5(Uuid.NAMESPACE_URL, name);
  }
}

class Migrations {
  final Map<String, Migration> migrations = {};
  final List<String> order = [];

  void add(Migration migration) {
    final name = migration.name;
    if (migrations.containsKey(name)) {
      throw Exception('Duplicate migration $name');
    }
    migrations[name] = migration;
    order.add(name);
  }
}
