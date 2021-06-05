import 'package:uuid/uuid.dart';

import 'connector.dart';

const uuid = Uuid();

abstract class Migration {
  /// should not be changed once specified.
  ///
  /// names have to be unique across migration instances
  final String name;

  /// typical derived class will have a no-args constructor
  ///
  /// that should call super with a unique name
  Migration(this.name);

  /// generated using the name
  String get migrationId {
    return uuid.v5(Uuid.NAMESPACE_URL, name);
  }

  MigrationRow get asDbRow => MigrationRow(name, migrationId);

  /// implement using [conn]
  Future<void> execute(DbExecutor conn);

  /// undo is optional for now
  void undo(DbExecutor conn) {}
}

class Migrations {
  final Map<String, Migration> _migrations = {};
  final List<String> order = [];

  void add(Migration migration) {
    final name = migration.name;
    if (_migrations.containsKey(name)) {
      throw Exception('Duplicate migration $name');
    }
    _migrations[name] = migration;
    order.add(name);
  }

  Migration? byName(String name) => _migrations[name];

  Iterable<Migration> get migrations => order.map((n) => byName(n)!);
}
