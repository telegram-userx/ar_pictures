import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/logger/logger.dart';
import '../../../domain/entity/entity.dart';
import '../../../domain/repository/repository.dart';

class LocalPhotoAlbumRepositoryImpl implements PhotoAlbumRepository {
  final SharedPreferences _prefs;
  late final String _key;

  LocalPhotoAlbumRepositoryImpl({
    required SharedPreferences prefs,
  })  : _prefs = prefs,
        _key = 'photo_album_';

  @override
  Future<PhotoAlbumEntity> getAlbum(String id) async {
    final albumJson = _prefs.getString('$_key$id');

    if (albumJson == null) {
      throw Exception('Failed to get album with id: $id locally');
    }

    final album = PhotoAlbumEntity.fromJson(
      jsonDecode(albumJson),
    );

    return album;
  }

  @override
  Future<void> updateAlbum(PhotoAlbumEntity album) async {
    final json = jsonEncode(album.toJson());

    final isSuccess = await _prefs.setString(
      '$_key${album.id}',
      json,
    );

    Logger.i('Save photo album status: $isSuccess');
  }
}
