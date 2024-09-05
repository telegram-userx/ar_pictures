import 'package:collection/collection.dart';
import 'package:drift/drift.dart';

import '../../../../../common/data/local/drift/dao.dart';
import '../app_database.dart';

class PhotoAlbumDao implements IDao<PhotoAlbumTableData> {
  final AppDatabase database;

  PhotoAlbumDao({
    required this.database,
  });

  Future<PhotoAlbumTableData?> getById(String id) async {
    final response = await get();

    if (response.isNotEmpty) {
      return response.firstWhereOrNull(
        (e) => e.id == id,
      );
    }

    return null;
  }

  @override
  Future<List<PhotoAlbumTableData>> get() => database.select(database.photoAlbumTable).get();

  @override
  Stream<List<PhotoAlbumTableData>> watch() => database.select(database.photoAlbumTable).watch();

  @override
  Future<int> insert({
    required UpdateCompanion<PhotoAlbumTableData> companion,
  }) =>
      database.into(database.photoAlbumTable).insertOnConflictUpdate(companion);

  @override
  Future<bool> update({
    required UpdateCompanion<PhotoAlbumTableData> companion,
  }) =>
      database.update(database.photoAlbumTable).replace(companion);

  @override
  Future<int> delete({
    required UpdateCompanion<PhotoAlbumTableData> companion,
  }) =>
      database.delete(database.photoAlbumTable).delete(companion);
}
