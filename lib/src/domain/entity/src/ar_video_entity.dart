import 'package:equatable/equatable.dart';

class ArVideoEntity extends Equatable {
  final String id;
  final String albumId;
  final String videoUrl;
  final double videoSizeInBytes;
  final bool isVideoDownloaded;
  String get localVideoUrl => 'http://localhost:5441/videos/$id.mp4';

  final String pictureUrl;
  final double pictureSizeInBytes;
  final bool isPictureDownloaded;
  String get localPictureUrl => 'http://localhost:5441/images/$id.jpeg';

  final double height;

  const ArVideoEntity({
    this.id = '',
    this.albumId = '',
    this.videoUrl = '',
    this.videoSizeInBytes = 0,
    this.height = 0,
    this.isVideoDownloaded = false,
    this.pictureUrl = '',
    this.pictureSizeInBytes = 0,
    this.isPictureDownloaded = false,
  });

  ArVideoEntity copyWith({
    String? id,
    String? albumId,
    String? videoUrl,
    double? videoSizeInBytes,
    double? height,
    bool? isVideoDownloaded,
    String? pictureUrl,
    double? pictureSizeInBytes,
    bool? isPictureDownloaded,
  }) {
    return ArVideoEntity(
      id: id ?? this.id,
      albumId: albumId ?? this.albumId,
      videoUrl: videoUrl ?? this.videoUrl,
      videoSizeInBytes: videoSizeInBytes ?? this.videoSizeInBytes,
      height: height ?? this.height,
      isVideoDownloaded: isVideoDownloaded ?? this.isVideoDownloaded,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      pictureSizeInBytes: pictureSizeInBytes ?? this.pictureSizeInBytes,
      isPictureDownloaded: isPictureDownloaded ?? this.isPictureDownloaded,
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
      pictureUrl: json['pictureUrl'] as String? ?? '',
      pictureSizeInBytes: (json['pictureSizeInBytes'] as num?)?.toDouble() ?? 0,
      isPictureDownloaded: json['isPictureDownloaded'] as bool? ?? false,
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
      'pictureUrl': pictureUrl,
      'pictureSizeInBytes': pictureSizeInBytes,
      'isPictureDownloaded': isPictureDownloaded,
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
        pictureUrl,
        pictureSizeInBytes,
        isPictureDownloaded,
      ];
}
