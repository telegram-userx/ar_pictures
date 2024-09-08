import 'package:mobx/mobx.dart';

import '../../../common/logger/logger.dart';
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

      return localAlbum;
    } catch (e) {
      try {
        final remoteAlbum = await _remotePhotoAlbumRepository.getAlbum(id);
        final remoteVideos = await _remotePhotoAlbumRepository.getVideos(remoteAlbum.id);

        final album = remoteAlbum.copyWith(
          arVideos: ObservableList.of(remoteVideos),
        );

        await updateAlbum(album, override: true);

        return album;
      } catch (error, stackTrace) {
        Logger.e(error, stackTrace);
        rethrow;
      }
    }
  }

  @override
  Future<void> updateAlbum(PhotoAlbumEntity album, {bool override = false}) async {
    await _localPhotoAlbumRepository.updateAlbum(album);
  }
}
