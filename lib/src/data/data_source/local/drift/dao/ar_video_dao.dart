import 'package:drift/drift.dart';

import '../../../../../common/data/local/drift/dao.dart';
import '../app_database.dart';

class ArVideoDao implements IDao<ArVideoTableData> {
  final AppDatabase database;

  ArVideoDao({
    required this.database,
  });

  Future<List<ArVideoTableData>> getByPhotoAlbumId(String photoAlbumId) => (database.select(
        database.arVideoTable,
      )..where(
              (tbl) => tbl.photoAlbumId.equals(photoAlbumId),
            ))
          .get();

  @override
  Future<List<ArVideoTableData>> get() => database.select(database.arVideoTable).get();

  @override
  Stream<List<ArVideoTableData>> watch() => database.select(database.arVideoTable).watch();

  @override
  Future<int> insert({
    required UpdateCompanion<ArVideoTableData> companion,
  }) =>
      database.into(database.arVideoTable).insertOnConflictUpdate(companion);

  @override
  Future<bool> update({
    required UpdateCompanion<ArVideoTableData> companion,
  }) =>
      database.update(database.arVideoTable).replace(companion);

  @override
  Future<int> delete({
    required UpdateCompanion<ArVideoTableData> companion,
  }) =>
      database.delete(database.arVideoTable).delete(companion);
}
