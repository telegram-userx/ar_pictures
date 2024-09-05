import '../../entity/entity.dart';

abstract interface class PhotoAlbumRepository {
  /// Returns album with videos
  Future<PhotoAlbumEntity> getAlbum(String id);

  Future<List<ArVideoEntity>> getVideos(String albumId);

  Future<void> updateVideo(ArVideoEntity video);
  Future<void> updateAlbum(PhotoAlbumEntity album);
}
