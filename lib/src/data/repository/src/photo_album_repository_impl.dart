import 'package:drift/drift.dart';

import '../../../domain/entity/entity.dart';
import '../../../domain/repository/repository.dart';
import '../../data_source/directus_sdk/directus_sdk.dart';
import '../../data_source/drift/drift.dart';

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
  Future<void> saveAlbum({required PhotoAlbumEntity photoAlbum}) async {
    final companion = _mapPhotoAlbumEntityToCompanion(photoAlbum);

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
    titleTk: dto.titleTk,
    titleEn: dto.titleEn,
    contentRu: dto.contentRu,
    contentTk: dto.contentTk,
    contentEn: dto.contentEn,
    posterImageUrl: dto.posterImageUrl,
  );
}

PhotoAlbumTableCompanion _mapPhotoAlbumEntityToCompanion(PhotoAlbumEntity album) {
  return PhotoAlbumTableCompanion(
    id: album.id == null ? const Value.absent() : Value(album.id!),
    titleRu: Value(album.titleRu),
    titleTk: Value(album.titleTk),
    titleEn: Value(album.titleEn),
    contentRu: Value(album.contentRu),
    contentTk: Value(album.contentTk),
    contentEn: Value(album.contentEn),
    posterImageUrl: Value(album.posterImageUrl),
    isFullyDownloaded: Value(album.isFullyDownloaded),
  );
}

PhotoAlbumEntity _mapPhotoAlbumTableDataToEntity(PhotoAlbumTableData data) {
  return PhotoAlbumEntity(
    id: data.id.toString(),
    titleRu: data.titleRu,
    titleTk: data.titleTk,
    titleEn: data.titleEn,
    contentRu: data.contentRu,
    contentTk: data.contentTk,
    contentEn: data.contentEn,
    posterImageUrl: data.posterImageUrl,
    isFullyDownloaded: data.isFullyDownloaded,
  );
}
