import 'package:equatable/equatable.dart';
import 'package:mobx/mobx.dart';

import '../entity.dart';

class PhotoAlbumEntity extends Equatable {
  final String id;
  final String markerFileUrl;
  final double markerFileSizeInBytes;
  final String markerFileLocation;
  final bool isMarkerFileDownloaded;
  final ObservableList<ArVideoEntity>? arVideos;

  const PhotoAlbumEntity({
    this.id = '',
    this.markerFileUrl = '',
    this.markerFileSizeInBytes = 0,
    this.markerFileLocation = '',
    this.isMarkerFileDownloaded = false,
    this.arVideos,
  });

  PhotoAlbumEntity copyWith({
    String? id,
    String? markerFileUrl,
    double? markerFileSizeInBytes,
    String? markerFileLocation,
    bool? isMarkerFileDownloaded,
    ObservableList<ArVideoEntity>? arVideos,
  }) {
    return PhotoAlbumEntity(
      id: id ?? this.id,
      markerFileUrl: markerFileUrl ?? this.markerFileUrl,
      markerFileSizeInBytes: markerFileSizeInBytes ?? this.markerFileSizeInBytes,
      markerFileLocation: markerFileLocation ?? this.markerFileLocation,
      isMarkerFileDownloaded: isMarkerFileDownloaded ?? this.isMarkerFileDownloaded,
      arVideos: arVideos ?? this.arVideos,
    );
  }

  double get totalDownloadSize {
    final arVideosSize = arVideos?.fold<double>(
          0,
          (previousValue, arVideo) => previousValue + arVideo.videoSizeInBytes,
        ) ??
        0;

    return bytesToMegabytes(markerFileSizeInBytes + arVideosSize);
  }

  double bytesToMegabytes(double bytes) {
    return bytes / (1024 * 1024);
  }

  @override
  List<Object?> get props => [
        id,
        markerFileUrl,
        markerFileSizeInBytes,
        markerFileLocation,
        isMarkerFileDownloaded,
        arVideos,
      ];
}
