import 'package:drift/drift.dart';

class PhotoAlbumTable extends Table {
  TextColumn get id => text().unique()();

  TextColumn get titleRu => text().nullable()();
  TextColumn get titleTk => text().nullable()();
  TextColumn get titleEn => text().nullable()();

  TextColumn get contentRu => text().nullable()();
  TextColumn get contentTk => text().nullable()();
  TextColumn get contentEn => text().nullable()();

  TextColumn get posterImageUrl => text().nullable()();

  BoolColumn get isFullyDownloaded => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
