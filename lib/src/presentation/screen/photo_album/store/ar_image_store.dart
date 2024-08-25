import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';

import '../../../../common/extension/src/future_status.dart';
import '../../../../common/logger/logger.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/repository/repository.dart';

part '../../../../../generated/src/presentation/screen/photo_album/store/ar_image_store.g.dart';

class ArImageStore = _ArImageStoreBase with _$ArImageStore;

abstract class _ArImageStoreBase with Store {
  final ArImageRepository _arImageRepository;
  final PhotoAlbumRepository _photoAlbumRepository;

  _ArImageStoreBase({
    required ArImageRepository arImageRepository,
    required PhotoAlbumRepository photoAlbumRepository,
  })  : _arImageRepository = arImageRepository,
        _photoAlbumRepository = photoAlbumRepository {
    _init();
  }

  @action
  Future<void> _init() async {
    // Listen to the stream of photo albums
    _photoAlbumRepository.watchAlbums().listen((albums) async {
      photoAlbums = albums;

      final allArImages = await _arImageRepository.getArImagesFromLocal();

      arImages = groupBy(
        allArImages,
        (e) => e.photoAlbumId ?? '',
      );
    });
  }

  @observable
  @readonly
  List<PhotoAlbumEntity> photoAlbums = [];

  @observable
  @readonly
  Map<String, List<ArImageEntity>> arImages = {};

  @observable
  @readonly
  ObservableMap<String, FutureStatus> getArImagesStatus = ObservableMap();

  @action
  downloadArImages(String? photoAlbumId) async {
    if (photoAlbumId == null) return;

    if (getArImagesStatus[photoAlbumId]?.isPending ?? false) return;

    try {
      getArImagesStatus[photoAlbumId] = FutureStatus.pending;

      arImages[photoAlbumId] = await _arImageRepository.getArImages(photoAlbumId: photoAlbumId);

      getArImagesStatus[photoAlbumId] = FutureStatus.fulfilled;
    } catch (error, stackTrace) {
      Logger.e(error, stackTrace);

      getArImagesStatus[photoAlbumId] = FutureStatus.rejected;
    }
  }

  @observable
  @readonly
  Map<String, double> downloadProgress = {};

  @observable
  @readonly
  Map<String, FutureStatus> getArImagesDataStatus = {};

  @action
  Future<void> downloadArImagesData(String photoAlbumId) async {
    if (getArImagesDataStatus[photoAlbumId]?.isPending ?? false) return;

    try {
      getArImagesDataStatus[photoAlbumId] = FutureStatus.pending;

      downloadProgress[photoAlbumId] = 0.0;

      final albumImages = arImages[photoAlbumId];
      if (albumImages == null) return;

      final totalFiles = albumImages.length;
      int downloadedFilesCount = 0;

      final Stream<ArImageEntity> arImageStream = _arImageRepository.downloadArData(images: albumImages.toList());

      await for (final image in arImageStream) {
        final index = albumImages.indexWhere((img) => img.id == image.id);
        if (index != -1) {
          albumImages[index] = image;
        }

        downloadedFilesCount++;
        downloadProgress[photoAlbumId] = (downloadedFilesCount / totalFiles) * 100;
      }

      getArImagesDataStatus[photoAlbumId] = FutureStatus.fulfilled;
    } catch (error, stackTrace) {
      Logger.e(error, stackTrace);

      getArImagesDataStatus[photoAlbumId] = FutureStatus.rejected;
    }
  }
}
