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
    // ignore: unused_element
    this.photoAlbum,
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
  int _totalBytesReceived = 0;

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
        onReceiveProgress: (received, total) => updateProgress(received, total),
      );
    }

    final videos = photoAlbum?.arVideos?.nonObservableInner ?? [];
    if (videos.isNotEmpty) {
      await Future.forEach(videos, (video) async {
        if (video.videoUrl.isNotEmpty) {
          await _downloadFileService.downloadFile(
            video.videoUrl, // Corrected to use the actual video URL
            '${appCacheDirectory.path}/${photoAlbum!.id}',
            onReceiveProgress: (received, total) => updateProgress(received, total),
          );
        }
      });

      isDownloadSuccess = true;
    }

    isDownloading = false;
  }

  @action
  updateProgress(int bytesReceived, int totalBytes) async {
    _totalBytesReceived = bytesReceived; // Keep track of total bytes received
    downloadProgressTotal = _bytesToMegabytes(_totalBytesReceived); // Convert to MB for UI display
  }

  double _bytesToMegabytes(num bytes) {
    return bytes / (1024 * 1024);
  }
}
