import 'package:equatable/equatable.dart';
import 'package:mobx/mobx.dart';

import '../entity.dart';

class PhotoAlbumEntity extends Equatable {
  final String id;
  final ObservableList<ArVideoEntity>? arVideos;

  const PhotoAlbumEntity({
    this.id = '',
    this.arVideos,
  });

  PhotoAlbumEntity copyWith({
    String? id,
    ObservableList<ArVideoEntity>? arVideos,
  }) {
    return PhotoAlbumEntity(
      id: id ?? this.id,
      arVideos: arVideos ?? this.arVideos,
    );
  }

  double get totalDownloadSize {
    final arVideosSize = arVideos?.fold<double>(
          0,
          (previousValue, arVideo) => previousValue + arVideo.videoSizeInBytes,
        ) ??
        0;

    final arPicturesSize = arVideos?.fold<double>(
          0,
          (previousValue, arVideo) => previousValue + arVideo.pictureSizeInBytes,
        ) ??
        0;

    return _bytesToMegabytes(arVideosSize + arPicturesSize);
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
    
    final isPicturesDownloaded = arVideos?.fold<bool>(
          false,
          (previousValue, arVideo) {
            if (previousValue) return previousValue;

            return arVideo.isPictureDownloaded;
          },
        ) ??
        false;

    return isPicturesDownloaded && isVideosDownloaded;
  }

  double _bytesToMegabytes(double bytes) {
    return bytes / (1024 * 1024);
  }

  factory PhotoAlbumEntity.fromJson(Map<String, dynamic> json) {
    return PhotoAlbumEntity(
      id: json['id'] as String? ?? '',
      arVideos: (json['arVideos'] as List<dynamic>?)
          ?.map((video) => ArVideoEntity.fromJson(video as Map<String, dynamic>))
          .toList()
          .asObservable(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arVideos': arVideos?.map((video) => video.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        arVideos,
      ];
}
