import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../../../generated/src/domain/entity/src/ar_image_entity.g.dart';

@JsonSerializable()
class ArImageEntity extends Equatable {
  final String? id;
  final String? photoAlbumId;
  final String? videoUrl;
  final String? videoLocation;
  final bool isVideoDownloaded;
  final double? videoSize;

  const ArImageEntity({
    this.id,
    this.photoAlbumId,
    this.videoUrl,
    this.videoLocation,
    this.isVideoDownloaded = false,
    this.videoSize,
  });

  ArImageEntity copyWith({
    String? id,
    String? photoAlbumId,
    String? name,
    String? videoUrl,
    String? videoLocation,
    bool? isVideoDownloaded,
    double? videoSize,
  }) {
    return ArImageEntity(
      id: id ?? this.id,
      photoAlbumId: photoAlbumId ?? this.photoAlbumId,
      videoUrl: videoUrl ?? this.videoUrl,
      videoLocation: videoLocation ?? this.videoLocation,
      isVideoDownloaded: isVideoDownloaded ?? this.isVideoDownloaded,
      videoSize: videoSize ?? this.videoSize,
    );
  }

  /// Connect the generated [_$ArImageEntityFromJson] function to the `fromJson`
  /// factory.
  factory ArImageEntity.fromJson(Map<String, dynamic> json) => _$ArImageEntityFromJson(json);

  /// Connect the generated [_$ArImageEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ArImageEntityToJson(this);

  @override
  List<Object?> get props => [
        id,
        photoAlbumId,
        videoUrl,
        videoLocation,
        isVideoDownloaded,
        videoSize,
      ];
}
