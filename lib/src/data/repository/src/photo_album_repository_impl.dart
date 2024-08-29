import 'package:drift/drift.dart';
import 'package:mobx/mobx.dart';

import '../../../domain/entity/entity.dart';
import '../../../domain/repository/repository.dart';
import '../../data_source/directus_sdk/directus_sdk.dart';
import '../../data_source/drift/drift.dart';

class PhotoAlbumRepositoryImpl implements PhotoAlbumRepository {
  final PhotoAlbumSdk _photoAlbumSdk;
  final PhotoAlbumDao _photoAlbumDao;
  final ArImageDao _arImageDao;
  final ArImageRepository _arImageRepository;

  PhotoAlbumRepositoryImpl({
    required PhotoAlbumSdk photoAlbumSdk,
    required PhotoAlbumDao photoAlbumDao,
    required ArImageDao arImageDao,
    required ArImageRepository arImageRepository,
  })  : _photoAlbumSdk = photoAlbumSdk,
        _photoAlbumDao = photoAlbumDao,
        _arImageDao = arImageDao,
        _arImageRepository = arImageRepository;

  @override
  Future<PhotoAlbumEntity> getAlbum({required String id}) async {
    final photoAlbumDto = await _photoAlbumSdk.getById(id);

    final photoAlbumEntity = _mapPhotoAlbumDtoToEntity(photoAlbumDto);

    final markersSize = await _photoAlbumSdk.getFileSize(photoAlbumEntity.mindFileUrl);

    final isFullyDownloaded = await isAlbumFullyDownloaded(photoAlbumEntity.id ?? '');

    final arImages = await _arImageRepository.getArImages(photoAlbumId: id);

    final arImagesSize = arImages.fold<double>(
      0.0,
      (previousValue, element) => previousValue + (element.videoSize ?? 0),
    );

    return photoAlbumEntity.copyWith(
      isFullyDownloaded: isFullyDownloaded,
      markersSizeInMegaBytes: markersSize + arImagesSize,
      arImages: ObservableList.of(arImages),
    );
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
  Stream<List<PhotoAlbumEntity>> watchAlbums() async* {
    yield* _photoAlbumDao.watch().map(
          (event) => event.map(_mapPhotoAlbumTableDataToEntity).toList(),
        );
  }

  @override
  Future<bool> isAlbumFullyDownloaded(String albumId) async {
    final arImages = await _arImageDao.getByPhotoAlbumId(albumId);
    final isFullyDownloaded = arImages.fold<bool>(
      false,
      (previousValue, element) {
        if (previousValue) return previousValue;

        return element.isVideoDownloaded;
      },
    );

    return isFullyDownloaded;
  }

  @override
  Future<double> getRequiredDownloadFilesSize(String albumId) async {
    // TODO: implement getRequiredDownloadFilesSize
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
    mindFileUrl: dto.mindFileUrl,
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
  );
}
