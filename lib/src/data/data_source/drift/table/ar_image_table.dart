import 'package:drift/drift.dart';

import '../drift.dart';

class ArImageTable extends Table {
  @override
  Set<Column<Object>>? get primaryKey => {id};

  TextColumn get id => text()();

  TextColumn get photoAlbumId => text().nullable().references(PhotoAlbumTable, #id)();

  TextColumn get videoUrl => text().nullable()();

  TextColumn get videoLocation => text().nullable()();

  RealColumn get filesizeInMegaBytes => real().nullable()();

  BoolColumn get isVideoDownloaded => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
