import 'package:equatable/equatable.dart';
import 'package:mobx/mobx.dart';

import '../entity.dart';

class PhotoAlbumEntity extends Equatable {
  final String id;
  final String markerFileUrl;
  final double markerFileSizeInBytes;
  final bool isMarkerFileDownloaded;
  final ObservableList<ArVideoEntity>? arVideos;

  const PhotoAlbumEntity({
    this.id = '',
    this.markerFileUrl = '',
    this.markerFileSizeInBytes = 0,
    this.isMarkerFileDownloaded = false,
    this.arVideos,
  });

  PhotoAlbumEntity copyWith({
    String? id,
    String? markerFileUrl,
    double? markerFileSizeInBytes,
    bool? isMarkerFileDownloaded,
    ObservableList<ArVideoEntity>? arVideos,
  }) {
    return PhotoAlbumEntity(
      id: id ?? this.id,
      markerFileUrl: markerFileUrl ?? this.markerFileUrl,
      markerFileSizeInBytes: markerFileSizeInBytes ?? this.markerFileSizeInBytes,
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

    return _bytesToMegabytes(markerFileSizeInBytes + arVideosSize);
  }

  bool get isFullyDownloaded {
    final isVideosDownloaded = arVideos?.fold<bool>(
          false,
          (previousValue, arVideo) {
            if (previousValue) return previousValue;

            return arVideo.isVideoDownloaded;
          },
        ) ??
        false;

    return isMarkerFileDownloaded && isVideosDownloaded;
  }

  double _bytesToMegabytes(double bytes) {
    return bytes / (1024 * 1024);
  }

  factory PhotoAlbumEntity.fromJson(Map<String, dynamic> json) {
    return PhotoAlbumEntity(
      id: json['id'] as String? ?? '',
      markerFileUrl: json['markerFileUrl'] as String? ?? '',
      markerFileSizeInBytes: (json['markerFileSizeInBytes'] as num?)?.toDouble() ?? 0,
      isMarkerFileDownloaded: json['isMarkerFileDownloaded'] as bool? ?? false,
      arVideos: (json['arVideos'] as List<dynamic>?)
          ?.map((video) => ArVideoEntity.fromJson(video as Map<String, dynamic>))
          .toList()
          .asObservable(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'markerFileUrl': markerFileUrl,
      'markerFileSizeInBytes': markerFileSizeInBytes,
      'isMarkerFileDownloaded': isMarkerFileDownloaded,
      'arVideos': arVideos?.map((video) => video.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        markerFileUrl,
        markerFileSizeInBytes,
        isMarkerFileDownloaded,
        arVideos,
      ];
}
