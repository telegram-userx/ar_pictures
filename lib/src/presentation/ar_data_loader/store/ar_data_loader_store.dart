import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';

import '../../../common/services/download_file/download_file_service.dart';
import '../../../domain/entity/entity.dart';
import '../../../domain/repository/repository.dart';

part '../../../../generated/src/presentation/ar_data_loader/store/ar_data_loader_store.g.dart';

class ArDataLoaderStore = _ArDataLoaderStoreBase with _$ArDataLoaderStore;

abstract class _ArDataLoaderStoreBase with Store {
  final DownloadFileService _downloadFileService;
  final PhotoAlbumRepository _albumRepository;

  _ArDataLoaderStoreBase({
    required DownloadFileService downloadFileService,
    required PhotoAlbumRepository albumRepository,
    // ignore: unused_element
    this.photoAlbum,
  })  : _downloadFileService = downloadFileService,
        _albumRepository = albumRepository;

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
            '${appCacheDirectory.path}/${video.id}',
            onReceiveProgress: (received, total) => updateProgress(received, total),
          );
        }
      });

      isDownloadSuccess = true;
    }

    if (photoAlbum != null) {
      await _albumRepository.updateAlbum(
        photoAlbum!.copyWith(
          isMarkerFileDownloaded: true,
          arVideos: ObservableList.of(videos
              .map<ArVideoEntity>(
                (video) => video.copyWith(
                  isVideoDownloaded: true,
                ),
              )
              .toList()),
        ),
        override: true,
      );
    }

    isDownloading = false;
  }

  int latestBytesReceived = 0;
  int latestTotalBytes = 0;

  @action
  updateProgress(int bytesReceived, int totalBytes) async {
    _totalBytesReceived -= latestBytesReceived == latestTotalBytes ? 0 : latestBytesReceived;
    latestBytesReceived = bytesReceived;
    latestTotalBytes = totalBytes;
    _totalBytesReceived += bytesReceived;

    downloadProgressTotal = _bytesToMegabytes(_totalBytesReceived); // Convert to MB for UI display
  }

  double _bytesToMegabytes(num bytes) {
    return bytes / (1024 * 1024);
  }
}
