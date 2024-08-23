import 'package:drift/drift.dart';

class PhotoAlbumTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get titleRu => text().nullable()();
  TextColumn get titleTm => text().nullable()();
  TextColumn get titleEn => text().nullable()();

  TextColumn get descriptionRu => text().nullable()();
  TextColumn get descriptionTm => text().nullable()();
  TextColumn get descriptionEn => text().nullable()();

  TextColumn get posterImageUrl => text().nullable()();

  BoolColumn get isFullyDownloaded => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
