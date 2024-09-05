import 'package:drift/drift.dart';
import 'package:mobx/mobx.dart';

import '../../../common/logger/logger.dart';
import '../../../domain/entity/entity.dart';
import '../../../domain/repository/repository.dart';
import '../../data_source/local/drift/app_database.dart';
import '../../data_source/local/drift/dao/ar_video_dao.dart';
import '../../data_source/local/drift/dao/photo_album_dao.dart';

class LocalPhotoAlbumRepositoryImpl implements PhotoAlbumRepository {
  final PhotoAlbumDao _albumDao;
  final ArVideoDao _arVideoDao;

  LocalPhotoAlbumRepositoryImpl({
    required PhotoAlbumDao albumDao,
    required ArVideoDao arVideoDao,
  })  : _albumDao = albumDao,
        _arVideoDao = arVideoDao;

  @override
  Future<PhotoAlbumEntity> getAlbum(String id) async {
    final album = await _albumDao.getById(id);

    if (album == null) {
      throw Exception('Failed to get album with id: $id locally');
    }

    final videos = await getVideos(album.id);

    return PhotoAlbumEntity(
      id: album.id,
      markerFileSizeInBytes: album.markerFileSizeInBytes ?? 0,
      markerFileUrl: album.markerFileUrl ?? '',
      isMarkerFileDownloaded: album.isMarkerFileDownloaded,
      arVideos: ObservableList.of(
        videos,
      ),
    );
  }

  @override
  Future<List<ArVideoEntity>> getVideos(String albumId) async {
    final videos = await _arVideoDao.getByAlbumId(albumId);

    return videos
        .map<ArVideoEntity>(
          (e) => ArVideoEntity(
            id: e.id,
            albumId: e.photoAlbumId ?? '',
            isVideoDownloaded: e.isVideoDownloaded,
            videoSizeInBytes: e.videoSizeInBytes ?? 0,
            videoUrl: e.videoUrl ?? '',
          ),
        )
        .toList();
  }

  @override
  Future<void> updateAlbum(PhotoAlbumEntity album) async {
    final isSuccess = await _albumDao.update(
      companion: PhotoAlbumTableCompanion(
        id: Value(album.id),
        isMarkerFileDownloaded: Value(album.isMarkerFileDownloaded),
        markerFileSizeInBytes: Value(album.markerFileSizeInBytes),
        markerFileUrl: Value(album.markerFileUrl),
      ),
    );

    Logger.i('Save photo album status: $isSuccess');
  }

  @override
  Future<void> updateVideo(ArVideoEntity video) async {
    final isSuccess = await _arVideoDao.update(
      companion: ArVideoTableCompanion(
        id: Value(video.id),
        isVideoDownloaded: Value(video.isVideoDownloaded),
        photoAlbumId: Value(video.albumId),
        videoSizeInBytes: Value(video.videoSizeInBytes),
        videoUrl: Value(video.videoUrl),
      ),
    );

    Logger.i('Save video status: $isSuccess');
  }
}
