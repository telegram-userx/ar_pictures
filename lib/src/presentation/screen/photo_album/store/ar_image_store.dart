import 'package:mobx/mobx.dart';

import '../../../../common/extension/src/future_status.dart';
import '../../../../common/logger/logger.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/repository/repository.dart';

part '../../../../../generated/src/presentation/screen/photo_album/store/ar_image_store.g.dart';

class ArImageStore = _ArImageStoreBase with _$ArImageStore;

abstract class _ArImageStoreBase with Store {
  final ArImageRepository _arImageRepository;

  _ArImageStoreBase({
    required ArImageRepository arImageRepository,
  }) : _arImageRepository = arImageRepository;

  @observable
  @readonly
  List<ArImageEntity> arImages = [];

  @observable
  @readonly
  FutureStatus getArImagesStatus = FutureStatus.fulfilled;

  @action
  downloadArImages(String photoAlbumId) async {
    if (getArImagesStatus.isPending) return;

    try {
      getArImagesStatus = FutureStatus.pending;

      arImages = await _arImageRepository.getArImages(photoAlbumId: photoAlbumId);

      getArImagesStatus = FutureStatus.fulfilled;
    } catch (error, stackTrace) {
      Logger.e(error, stackTrace);

      getArImagesStatus = FutureStatus.rejected;
    }
  }

  @observable
  @readonly
  FutureStatus getArImagesDataStatus = FutureStatus.fulfilled;

  @observable
  double downloadProgress = 0.0;

  @action
  Future<void> downloadArImagesData() async {
    if (getArImagesDataStatus.isPending) return;

    try {
      getArImagesDataStatus = FutureStatus.pending;

      downloadProgress = 0.0;

      final totalFiles = arImages.length;
      int downloadedFilesCount = 0;

      final Stream<ArImageEntity> arImageStream = _arImageRepository.downloadArData(images: arImages.toList());

      await for (final image in arImageStream) {
        final index = arImages.indexWhere((img) => img.id == image.id);
        if (index != -1) {
          arImages[index] = image;
        }

        downloadedFilesCount++;
        downloadProgress = (downloadedFilesCount / totalFiles) * 100;
      }

      getArImagesDataStatus = FutureStatus.fulfilled;
    } catch (error, stackTrace) {
      Logger.e(error, stackTrace);
      getArImagesDataStatus = FutureStatus.rejected;
    }
  }
}
