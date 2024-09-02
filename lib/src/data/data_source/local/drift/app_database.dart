import 'package:drift/drift.dart';

import 'table/ar_video_table.dart';
import 'table/photo_album_table.dart';

part '../../../../../generated/src/data/data_source/local/drift/app_database.g.dart';

@DriftDatabase(
  tables: [
    PhotoAlbumTable,
    ArVideoTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.queryExecutor);

  @override
  int get schemaVersion => 1;
}
