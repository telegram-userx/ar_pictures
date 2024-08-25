import 'package:drift/drift.dart';

class PhotoAlbumTable extends Table {
  @override
  Set<Column<Object>>? get primaryKey => {id};

  TextColumn get id => text()();

  TextColumn get titleRu => text().nullable()();
  TextColumn get titleTk => text().nullable()();
  TextColumn get titleEn => text().nullable()();

  TextColumn get contentRu => text().nullable()();
  TextColumn get contentTk => text().nullable()();
  TextColumn get contentEn => text().nullable()();

  TextColumn get posterImageUrl => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
