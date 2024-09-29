import 'package:equatable/equatable.dart';

class ArVideoEntity extends Equatable {
  final String id;
  final String albumId;
  final String videoUrl;
  final double videoSizeInBytes;
  final double height;
  final bool isVideoDownloaded;

  const ArVideoEntity({
    this.id = '',
    this.albumId = '',
    this.videoUrl = '',
    this.videoSizeInBytes = 0,
    this.height = 0,
    this.isVideoDownloaded = false,
  });

  ArVideoEntity copyWith({
    String? id,
    String? albumId,
    String? videoUrl,
    double? videoSizeInBytes,
    double? height,
    String? videoLocation,
    bool? isVideoDownloaded,
  }) {
    return ArVideoEntity(
      id: id ?? this.id,
      albumId: albumId ?? this.albumId,
      videoUrl: videoUrl ?? this.videoUrl,
      videoSizeInBytes: videoSizeInBytes ?? this.videoSizeInBytes,
      isVideoDownloaded: isVideoDownloaded ?? this.isVideoDownloaded,
      height: height ?? this.height,
    );
  }

  factory ArVideoEntity.fromJson(Map<String, dynamic> json) {
    return ArVideoEntity(
      id: json['id'] as String? ?? '',
      albumId: json['albumId'] as String? ?? '',
      videoUrl: json['videoUrl'] as String? ?? '',
      videoSizeInBytes: (json['videoSizeInBytes'] as num?)?.toDouble() ?? 0,
      isVideoDownloaded: json['isVideoDownloaded'] as bool? ?? false,
      height: (json['height'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'albumId': albumId,
      'videoUrl': videoUrl,
      'videoSizeInBytes': videoSizeInBytes,
      'isVideoDownloaded': isVideoDownloaded,
      'height': height,
    };
  }

  @override
  List<Object?> get props => [
        id,
        albumId,
        videoUrl,
        videoSizeInBytes,
        height,
        isVideoDownloaded,
      ];
}
