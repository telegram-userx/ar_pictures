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

      // Convert lists within the map to ObservableLists
      arImages = ObservableMap.of(
        groupBy(
          allArImages,
          (e) => e.photoAlbumId ?? '',
        ).map(
          (key, value) => MapEntry(key, ObservableList.of(value)),
        ),
      );
    });
  }

  @observable
  @readonly
  List<PhotoAlbumEntity> photoAlbums = [];

  @observable
  @readonly
  ObservableMap<String, ObservableList<ArImageEntity>> arImages = ObservableMap();

  @observable
  @readonly
  ObservableMap<String, FutureStatus> getArImagesDataStatus = ObservableMap();

  @observable
  @readonly
  ObservableMap<String, double> downloadProgress = ObservableMap();

  @action
  Future<void> fetchAndDownloadArImages(String? photoAlbumId) async {
    if (photoAlbumId == null) return;

    // Check if the status is pending for the specific album
    if (getArImagesDataStatus[photoAlbumId]?.isPending ?? false) return;

    try {
      // Set status to pending for the specific album
      getArImagesDataStatus[photoAlbumId] = FutureStatus.pending;
      downloadProgress[photoAlbumId] = 0.0;

      // Fetch AR images for the specific album
      arImages[photoAlbumId] = ObservableList.of(await _arImageRepository.getArImages(photoAlbumId: photoAlbumId));

      final albumImages = arImages[photoAlbumId];
      if (albumImages == null) return; // Exit if no images are found

      final totalFiles = albumImages.length * 2;
      int downloadedFilesCount = 0;

      // Stream for downloading AR data
      final Stream<ArImageEntity> arImageStream = _arImageRepository.downloadVideos(images: albumImages.toList());

      // Process each image as it gets downloaded
      await for (final image in arImageStream) {
        final index = albumImages.indexWhere((img) => img.id == image.id);
        if (index != -1) {
          albumImages[index] = image; // ObservableList supports index assignment
        }

        downloadedFilesCount++;
        downloadProgress[photoAlbumId] = (downloadedFilesCount / totalFiles) * 100;
      }

      // Update status to fulfilled once all downloads are complete
      getArImagesDataStatus[photoAlbumId] = FutureStatus.fulfilled;
    } catch (error, stackTrace) {
      Logger.e(error, stackTrace);

      // Set status to rejected in case of an error
      getArImagesDataStatus[photoAlbumId] = FutureStatus.rejected;
    }
  }
}
