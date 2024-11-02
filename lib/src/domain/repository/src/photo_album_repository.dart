import '../../entity/entity.dart';

abstract class PhotoAlbumRepository {
  /// Returns album with videos
  Future<PhotoAlbumEntity> getAlbum(String id);

  Future<void> updateAlbum(PhotoAlbumEntity album);
}
