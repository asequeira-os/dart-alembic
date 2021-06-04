import 'package:dart_alembic/src/migration.dart';
import 'package:test/test.dart';

void main() {
  final m1 = Migration('mig1');
  final m2 = Migration('mig2');
  final m1_dupe = Migration('mig1');

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
}
