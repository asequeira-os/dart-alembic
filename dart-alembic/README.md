# dart_alembic
A dart relational database schema migration library.  
Code at [github repo](https://github.com/asequeira-os/dart-alembic)

Inspired by [Alembic](https://alembic.sqlalchemy.org/) for Python, but very basic.

Unit tested, but not yet used in any system.

# Install
Add to your `pubspec.yaml`
```
dependencies:
  ...
  dart_alembic:
    git:
      url: git@github.com:asequeira-os/dart-alembic.git
      path: dart-alembic
  ...
```

and run `dart pub get`

# Usage
Please see [migration_test](test/migration_test.dart)
