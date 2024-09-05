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
  Future<List<ArVideoEntity>> getVideos(String albumId) async {
    final videosJson = _prefs.getStringList('$_key$albumId') ?? [];

    return videosJson
        .map<ArVideoEntity>(
          (video) => ArVideoEntity.fromJson(
            jsonDecode(video),
          ),
        )
        .where(
          (e) => e.albumId == albumId,
        )
        .toList();
  }

  @override
  Future<void> updateAlbum(PhotoAlbumEntity album, {bool override = false}) async {
    late final PhotoAlbumEntity? localAlbum;

    try {
      localAlbum = await getAlbum(album.id);
    } catch (e) {
      localAlbum = null;
    }

    final json = jsonEncode(localAlbum == null
        ? album.toJson()
        : localAlbum
            .copyWith(
              arVideos: album.arVideos,
            )
            .toJson());

    final isSuccess = await _prefs.setString(
      '$_key${album.id}',
      json,
    );

    Logger.i('Save photo album status: $isSuccess');
  }
}
