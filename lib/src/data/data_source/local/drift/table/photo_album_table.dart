import 'package:drift/drift.dart';

class PhotoAlbumTable extends Table {
  @override
  Set<Column<Object>>? get primaryKey => {id};

  TextColumn get id => text()();

  TextColumn get markerFileUrl => text().nullable()();
  RealColumn get markerFileSizeInBytes => real().nullable()();
  BoolColumn get isMarkerFileDownloaded => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
