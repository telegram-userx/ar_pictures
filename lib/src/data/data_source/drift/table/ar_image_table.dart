import 'package:drift/drift.dart';

import '../drift.dart';

class ArImageTable extends Table {
  @override
  Set<Column<Object>>? get primaryKey => {id};

  TextColumn get id => text()();

  TextColumn get photoAlbumId => text().nullable().references(PhotoAlbumTable, #id)();

  TextColumn get videoUrl => text().nullable()();
  TextColumn get mindFileUrl => text().nullable()();

  TextColumn get videoLocation => text().nullable()();
  TextColumn get mindFileLocation => text().nullable()();

  BoolColumn get isVideoDownloaded => boolean().withDefault(const Constant(false))();
  BoolColumn get isMindFileDownloaded => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
