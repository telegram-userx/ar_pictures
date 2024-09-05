import 'dart:convert';

import 'package:mobx/mobx.dart';
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

    final videos = await getVideos(album.id);

    return PhotoAlbumEntity(
      id: album.id,
      markerFileSizeInBytes: album.markerFileSizeInBytes,
      markerFileUrl: album.markerFileUrl,
      isMarkerFileDownloaded: album.isMarkerFileDownloaded,
      arVideos: ObservableList.of(
        videos,
      ),
    );
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
        .toList();
  }

  @override
  Future<void> updateAlbum(PhotoAlbumEntity album) async {
    final isSuccess = await _prefs.setString(
      '$_key${album.id}',
      jsonEncode(album),
    );

    Logger.i('Save photo album status: $isSuccess');
  }

  @override
  Future<void> updateVideo(ArVideoEntity video) async {
    final videosJson = _prefs.getStringList('$_key${video.albumId}') ?? [];
    videosJson.add(
      jsonEncode(video),
    );

    final isSuccess = await _prefs.setStringList('$_key${video.albumId}', videosJson);

    Logger.i('Save video status: $isSuccess');
  }
}
