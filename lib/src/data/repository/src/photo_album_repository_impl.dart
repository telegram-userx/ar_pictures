import 'package:mobx/mobx.dart';

import '../../../common/logger/logger.dart';
import '../../../domain/entity/src/ar_video_entity.dart';
import '../../../domain/entity/src/photo_album_entity.dart';
import '../../../domain/repository/repository.dart';
import 'local_photo_album_repository_impl.dart';
import 'remote_photo_album_repository_impl.dart';

class PhotoAlbumRepositoryImpl implements PhotoAlbumRepository {
  final RemotePhotoAlbumRepositoryImpl _remotePhotoAlbumRepository;
  final LocalPhotoAlbumRepositoryImpl _localPhotoAlbumRepository;

  PhotoAlbumRepositoryImpl({
    required RemotePhotoAlbumRepositoryImpl remotePhotoAlbumRepository,
    required LocalPhotoAlbumRepositoryImpl localPhotoAlbumRepository,
  })  : _remotePhotoAlbumRepository = remotePhotoAlbumRepository,
        _localPhotoAlbumRepository = localPhotoAlbumRepository;

  @override
  Future<PhotoAlbumEntity> getAlbum(String id) async {
    try {
      final localAlbum = await _localPhotoAlbumRepository.getAlbum(id);
      final localVideos = await _localPhotoAlbumRepository.getVideos(localAlbum.id);

      return localAlbum.copyWith(
        arVideos: ObservableList.of(localVideos),
      );
    } catch (e) {
      try {
        final remoteAlbum = await _remotePhotoAlbumRepository.getAlbum(id);
        final remoteVideos = await _remotePhotoAlbumRepository.getVideos(remoteAlbum.id);

        return remoteAlbum.copyWith(
          arVideos: ObservableList.of(remoteVideos),
        );
      } catch (error, stackTrace) {
        Logger.e(error, stackTrace);
        rethrow;
      }
    }
  }

  @override
  Future<List<ArVideoEntity>> getVideos(String albumId) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateAlbum(PhotoAlbumEntity album) async {
    await _localPhotoAlbumRepository.updateAlbum(album);
  }

  @override
  Future<void> updateVideo(ArVideoEntity video) async {
    await _localPhotoAlbumRepository.updateVideo(video);
  }
}
