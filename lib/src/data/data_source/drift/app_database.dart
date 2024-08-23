import 'package:drift/drift.dart';

import 'drift.dart';

part '../../../../generated/src/data/data_source/drift/app_database.g.dart';

@DriftDatabase(
  tables: [
    PhotoAlbumTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.queryExecutor);

  @override
  int get schemaVersion => 1;
}
