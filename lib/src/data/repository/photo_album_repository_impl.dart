import 'package:drift/drift.dart';

import '../../domain/entity/entity.dart';
import '../../domain/repository/repository.dart';
import '../data_source/directus_sdk/directus_sdk.dart';
import '../data_source/drift/drift.dart';

class PhotoAlbumRepositoryImpl implements PhotoAlbumRepository {
  final PhotoAlbumSdk _photoAlbumSdk;
  final PhotoAlbumDao _photoAlbumDao;

  PhotoAlbumRepositoryImpl({
    required PhotoAlbumSdk photoAlbumSdk,
    required PhotoAlbumDao photoAlbumDao,
  })  : _photoAlbumSdk = photoAlbumSdk,
        _photoAlbumDao = photoAlbumDao;

  @override
  Future<PhotoAlbumEntity> getAlbum({required String id}) async {
    final photoAlbumDto = await _photoAlbumSdk.getById(id);

    return _mapPhotoAlbumDtoToEntity(photoAlbumDto);
  }

  @override
  Future<void> saveAlbum({required PhotoAlbumEntity album}) async {
    final companion = _mapPhotoAlbumEntityToCompanion(album);

    await _photoAlbumDao.insert(companion: companion);
  }

  @override
  Future<List<PhotoAlbumEntity>> getAlbums() async {
    final photoAlbums = await _photoAlbumDao.get();

    return photoAlbums.map(_mapPhotoAlbumTableDataToEntity).toList();
  }

  @override
  Future<bool> isFullyDownloaded({required PhotoAlbumEntity album}) {
    // TODO: implement isFullyDownloaded
    throw UnimplementedError();
  }
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

PhotoAlbumTableCompanion _mapPhotoAlbumEntityToCompanion(PhotoAlbumEntity album) {
  return PhotoAlbumTableCompanion(
    id: album.id == null ? const Value.absent() : Value(int.parse(album.id!)),
    titleRu: Value(album.titleRu),
    titleTm: Value(album.titleTm),
    titleEn: Value(album.titleEn),
    descriptionRu: Value(album.descriptionRu),
    descriptionTm: Value(album.descriptionTm),
    descriptionEn: Value(album.descriptionEn),
    posterImageUrl: Value(album.posterImageUrl),
    isFullyDownloaded: Value(album.isFullyDownloaded),
  );
}

PhotoAlbumEntity _mapPhotoAlbumTableDataToEntity(PhotoAlbumTableData data) {
  return PhotoAlbumEntity(
    id: data.id.toString(),
    titleRu: data.titleRu,
    titleTm: data.titleTm,
    titleEn: data.titleEn,
    descriptionRu: data.descriptionRu,
    descriptionTm: data.descriptionTm,
    descriptionEn: data.descriptionEn,
    posterImageUrl: data.posterImageUrl,
    isFullyDownloaded: data.isFullyDownloaded,
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