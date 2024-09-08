import '../../entity/entity.dart';

abstract interface class PhotoAlbumRepository {
  /// Returns album with videos
  Future<PhotoAlbumEntity> getAlbum(String id);

  Future<void> updateAlbum(PhotoAlbumEntity album);
}
