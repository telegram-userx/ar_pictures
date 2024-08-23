import '../../domain/entity/entity.dart';
import '../../domain/repository/repository.dart';
import '../data_source/directus_sdk/directus_sdk.dart';

class PhotoAlbumRepositoryImpl implements PhotoAlbumRepository {
  final PhotoAlbumSdk _photoAlbumSdk;

  PhotoAlbumRepositoryImpl({
    required PhotoAlbumSdk photoAlbumSdk,
  }) : _photoAlbumSdk = photoAlbumSdk;

  @override
  Future<PhotoAlbumEntity> getAlbum({required String id}) async {
    final photoAlbumDto = await _photoAlbumSdk.getById(id);

    return _mapPhotoAlbumDtoToEntity(photoAlbumDto);
  }

  @override
  Future<void> saveAlbum({required PhotoAlbumEntity album}) {
    // TODO: implement saveAlbum
    throw UnimplementedError();
  }

  @override
  Future<List<PhotoAlbumEntity>> getAlbums() {
    // TODO: implement getAlbums
    throw UnimplementedError();
  }

  @override
  Future<bool> isFullyDownloaded({required PhotoAlbumEntity album}) {
    // TODO: implement isFullyDownloaded
    throw UnimplementedError();
  }

  // Mapping
  PhotoAlbumEntity _mapPhotoAlbumDtoToEntity(PhotoAlbumDto dto) {
    return PhotoAlbumEntity(
      id: dto.id,
      titleRu: dto.titleRu,
      titleTm: dto.titleTm,
      titleEn: dto.titleEn,
      descriptionRu: dto.descriptionRu,
      descriptionTm: dto.descriptionTm,
      descriptionEn: dto.descriptionEn,
      posterImageUrl: dto.posterImageUrl,
    );
  }

  // PhotoAlbumDto _mapPhotoAlbumEntityToDto(PhotoAlbumEntity entity) {
  //   return PhotoAlbumDto(
  //     id: entity.id,
  //     titleRu: entity.titleRu,
  //     titleTm: entity.titleTm,
  //     titleEn: entity.titleEn,
  //     descriptionRu: entity.descriptionRu,
  //     descriptionTm: entity.descriptionTm,
  //     descriptionEn: entity.descriptionEn,
  //     posterImageUrl: entity.posterImageUrl,
  //   );
  // }
}
