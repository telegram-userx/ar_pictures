import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../../../common/extension/src/future_status.dart';
import '../../../../common/logger/logger.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/repository/repository.dart';

part '../../../../../generated/src/presentation/screen/photo_album/store/photo_album_store.g.dart';

class PhotoAlbumStore = _PhotoAlbumStoreBase with _$PhotoAlbumStore;

abstract class _PhotoAlbumStoreBase with Store {
  final PhotoAlbumRepository _albumRepository;

  _PhotoAlbumStoreBase({
    required PhotoAlbumRepository albumRepository,
  }) : _albumRepository = albumRepository {
    _init();
  }

  @action
  _init() async {
    getPhotoAlbumByIdStatus = FutureStatus.pending;
    photoAlbums = await _albumRepository.getAlbums();
    getPhotoAlbumByIdStatus = FutureStatus.fulfilled;
  }

  @observable
  @readonly
  List<PhotoAlbumEntity> photoAlbums = [];

  @observable
  @readonly
  FutureStatus getPhotoAlbumByIdStatus = FutureStatus.fulfilled;

  @action
  Future<PhotoAlbumEntity?> getPhotoAlbumById(String id) async {
    if (getPhotoAlbumByIdStatus.isPending) return null;

    try {
      getPhotoAlbumByIdStatus = FutureStatus.pending;

      final photoAlbum = await _albumRepository.getAlbum(id: id);
      await _albumRepository.saveAlbum(photoAlbum: photoAlbum);

      final fetchedAlbum = photoAlbum;

      if (!photoAlbums.contains(photoAlbum)) {
        photoAlbums.add(photoAlbum);
      }

      getPhotoAlbumByIdStatus = FutureStatus.fulfilled;

      return fetchedAlbum;
    } catch (error, stackTrace) {
      Logger.e(error, stackTrace);
      getPhotoAlbumByIdStatus = FutureStatus.rejected;

      return null;
    }
  }

  @observable
  @readonly
  ObservableFuture<double> requiredDownloadSize = ObservableFuture.value(0);

  @action
  getRequiredDownloadSize(String albumId) async {
    if (requiredDownloadSize.status.isPending) return;

    try {
      requiredDownloadSize = ObservableFuture(_albumRepository.getRequiredDownloadFilesSize(albumId));

      await requiredDownloadSize;
    } catch (error, stackTrace) {
      Logger.e(error, stackTrace);
    }
  }
}
