import 'package:equatable/equatable.dart';

class ArVideoEntity extends Equatable {
  final String id;
  final String albumId;
  final String videoUrl;
  final double videoSizeInBytes;
  final String videoLocation;
  final bool isVideoDownloaded;

  const ArVideoEntity({
    this.id = '',
    this.albumId = '',
    this.videoUrl = '',
    this.videoSizeInBytes = 0,
    this.videoLocation = '',
    this.isVideoDownloaded = false,
  });

  ArVideoEntity copyWith({
    String? id,
    String? albumId,
    String? videoUrl,
    double? videoSizeInBytes,
    String? videoLocation,
    bool? isVideoDownloaded,
  }) {
    return ArVideoEntity(
      id: id ?? this.id,
      albumId: albumId ?? this.albumId,
      videoUrl: videoUrl ?? this.videoUrl,
      videoSizeInBytes: videoSizeInBytes ?? this.videoSizeInBytes,
      videoLocation: videoLocation ?? this.videoLocation,
      isVideoDownloaded: isVideoDownloaded ?? this.isVideoDownloaded,
    );
  }

  @override
  List<Object?> get props => [
        id,
        albumId,
        videoUrl,
        videoSizeInBytes,
        videoLocation,
        isVideoDownloaded,
      ];
}
