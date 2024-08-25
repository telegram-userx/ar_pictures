import 'package:drift/drift.dart';

import '../drift.dart';
import 'dao.dart';

class ArImageDao implements IDao<ArImageTableData> {
  final AppDatabase database;

  ArImageDao({
    required this.database,
  });

  Future<List<ArImageTableData>> getByPhotoAlbumId(String photoAlbumId) => (database.select(
        database.arImageTable,
      )..where(
              (tbl) => tbl.photoAlbumId.equals(photoAlbumId),
            ))
          .get();

  Stream<List<ArImageTableData>> watchByPhotoAlbumId(String photoAlbumId) => (database.select(
        database.arImageTable,
      )..where(
              (tbl) => tbl.photoAlbumId.equals(photoAlbumId),
            ))
          .watch();

  @override
  Future<List<ArImageTableData>> get() => database.select(database.arImageTable).get();

  @override
  Stream<List<ArImageTableData>> watch() => database.select(database.arImageTable).watch();

  @override
  Future<int> insert({
    required UpdateCompanion<ArImageTableData> companion,
  }) =>
      database.into(database.arImageTable).insertOnConflictUpdate(companion);

  @override
  Future<bool> update({
    required UpdateCompanion<ArImageTableData> companion,
  }) =>
      database.update(database.arImageTable).replace(companion);

  @override
  Future<int> delete({
    required UpdateCompanion<ArImageTableData> companion,
  }) =>
      database.delete(database.arImageTable).delete(companion);
}
