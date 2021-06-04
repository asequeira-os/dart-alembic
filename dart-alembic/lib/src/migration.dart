import 'package:uuid/uuid.dart';

import 'connector.dart';

const uuid = Uuid();

class MigrationRow {
  final String name;
  final String id;
  final DateTime? created;

  MigrationRow(this.name, this.id) : created = null;
  MigrationRow.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['migration_id'],
        created = json['created'];
}

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
  void execute(AlembicConnector conn);

  /// undo is optional for now
  void undo(AlembicConnector conn) {}
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
