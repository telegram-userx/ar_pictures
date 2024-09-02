import 'package:drift/drift.dart';

import 'photo_album_table.dart';

class ArVideoTable extends Table {
  @override
  Set<Column<Object>>? get primaryKey => {id};

  TextColumn get id => text()();

  TextColumn get photoAlbumId => text().nullable().references(PhotoAlbumTable, #id)();

  TextColumn get videoUrl => text().nullable()();

  RealColumn get videoSizeInBytes => real().nullable()();

  BoolColumn get isVideoDownloaded => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
