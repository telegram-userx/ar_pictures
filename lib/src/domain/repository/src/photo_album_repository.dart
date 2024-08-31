import '../../entity/entity.dart';

abstract interface class PhotoAlbumRepository {
  Future<PhotoAlbumEntity> getAlbum(String id);
}
