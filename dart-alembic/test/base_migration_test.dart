import 'package:dart_alembic/src/connector.dart';
import 'package:dart_alembic/src/migration.dart';
import 'package:test/test.dart';

class DummyMigration extends Migration {
  DummyMigration(String name) : super(name);

  @override
  Future<void> execute(DbExecutor conn) async {
  }

}

void main() {
  final m1 = DummyMigration('mig1');
  final m2 = DummyMigration('mig2');
  final m1_dupe = DummyMigration('mig1');

  test('Migration should generate proper ids', () async {
    expect(m1.migrationId.length, 36);
    expect(m1.migrationId, m1.migrationId);
    expect(m1.migrationId != m2.migrationId, isTrue);
  });

  test('Migration should not allow duplicates', () async {
    final migs = Migrations();
    migs.add(m1);
    migs.add(m2);
    try {
      migs.add(m1_dupe);
    } catch (e) {
      expect(e.toString(), 'Exception: Duplicate migration mig1');
    }
  });

  test('Migrations should be ordered', () async {
    final migs = Migrations();
    migs.add(m1);
    migs.add(m2);
    expect(migs.order[0], m1.name);
    expect(migs.order[1], m2.name);
    expect(migs.byName(m1.name), m1);
    expect(migs.byName(m2.name), m2);
  });
}
