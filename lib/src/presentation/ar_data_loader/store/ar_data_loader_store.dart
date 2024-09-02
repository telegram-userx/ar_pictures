import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';

import '../../../common/services/download_file/download_file_service.dart';
import '../../../domain/entity/entity.dart';

part '../../../../generated/src/presentation/ar_data_loader/store/ar_data_loader_store.g.dart';

class ArDataLoaderStore = _ArDataLoaderStoreBase with _$ArDataLoaderStore;

abstract class _ArDataLoaderStoreBase with Store {
  final DownloadFileService _downloadFileService;

  _ArDataLoaderStoreBase({
    required DownloadFileService downloadFileService,
  }) : _downloadFileService = downloadFileService;

  @observable
  @readonly
  PhotoAlbumEntity? photoAlbum;

  @computed
  double get totalSizeInMegaBytes => photoAlbum?.totalDownloadSize ?? 0;

  @observable
  @readonly
  double downloadProgressTotal = 0;

  @observable
  @readonly
  double _downloadProgress = 0;

  @observable
  @readonly
  bool isDownloading = false;

  @observable
  @readonly
  bool isDownloadSuccess = false;

  @action
  setIsDownloading(bool value) => isDownloading = value;

  @action
  startDownloading() async {
    if (photoAlbum == null || isDownloading) return;

    isDownloading = true;

    final appCacheDirectory = await getApplicationDocumentsDirectory();

    if (!photoAlbum!.isMarkerFileDownloaded) {
      await _downloadFileService.downloadFile(
        photoAlbum!.markerFileUrl,
        '${appCacheDirectory.path}/${photoAlbum!.id}',
        onReceiveProgress: (received, total) => updateProgress(received),
      );
    }

    final videos = photoAlbum?.arVideos ?? [];
    if (videos.isNotEmpty) {
      await Future.forEach(videos, (video) async {
        await _downloadFileService.downloadFile(
          photoAlbum!.markerFileUrl,
          '${appCacheDirectory.path}/${photoAlbum!.id}',
          onReceiveProgress: (received, total) => updateProgress(received),
        );
      });

      isDownloadSuccess = true;
    }
  }

  @action
  updateProgress(int bytes) async {
    downloadProgressTotal -= _downloadProgress;
    _downloadProgress = _bytesToMegabytes(bytes);
    downloadProgressTotal += _downloadProgress;
  }

  double _bytesToMegabytes(num bytes) {
    return bytes / (1024 * 1024);
  }
}
