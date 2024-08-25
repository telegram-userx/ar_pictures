import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../../../generated/src/domain/entity/src/ar_image_entity.g.dart';

@JsonSerializable()
class ArImageEntity extends Equatable {
  final String? id;
  final String? photoAlbumId;
  final String? videoUrl;
  final String? mindFileUrl;
  final String? videoLocation;
  final String? mindFileLocation;
  final bool isVideoDownloaded;
  final bool isMindFileDownloaded;

  const ArImageEntity({
    this.id,
    this.photoAlbumId,
    this.videoUrl,
    this.mindFileUrl,
    this.videoLocation,
    this.mindFileLocation,
    this.isVideoDownloaded = false,
    this.isMindFileDownloaded = false,
  });

  ArImageEntity copyWith({
    String? id,
    String? photoAlbumId,
    String? name,
    String? videoUrl,
    String? mindFileUrl,
    String? videoLocation,
    String? mindFileLocation,
    bool? isVideoDownloaded,
    bool? isMindFileDownloaded,
  }) {
    return ArImageEntity(
      id: id ?? this.id,
      photoAlbumId: photoAlbumId ?? this.photoAlbumId,
      videoUrl: videoUrl ?? this.videoUrl,
      mindFileUrl: mindFileUrl ?? this.mindFileUrl,
      videoLocation: videoLocation ?? this.videoLocation,
      mindFileLocation: mindFileLocation ?? this.mindFileLocation,
      isVideoDownloaded: isVideoDownloaded ?? this.isVideoDownloaded,
      isMindFileDownloaded: isMindFileDownloaded ?? this.isMindFileDownloaded,
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
        mindFileUrl,
        videoLocation,
        mindFileLocation,
        isVideoDownloaded,
        isMindFileDownloaded,
      ];
}
