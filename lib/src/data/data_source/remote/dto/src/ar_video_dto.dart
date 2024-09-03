import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../common/constant/app_constants.dart';

part '../../../../../../generated/src/data/data_source/remote/dto/src/ar_video_dto.g.dart';

@JsonSerializable()
class ArVideoDto {
  final String? id;
  final String? photoAlbumId;
  final String? video;
  final double? videoSizeInBytes;

  ArVideoDto({
    this.id,
    this.video,
    this.photoAlbumId,
    this.videoSizeInBytes,
  });

  // ClassName
  static const className = 'ar_video';
  static const kPhotoAlbum = 'photoAlbumId';

  String? get videoUrl =>video == null? '': '${dotenv.env[kVarDirectusApiUrl]!}/assets/$video';

  /// Connect the generated [_$ArVideoDtoFromJson] function to the `fromJson`
  /// factory.
  factory ArVideoDto.fromJson(Map<String, dynamic> json) => _$ArVideoDtoFromJson(json);

  /// Connect the generated [_$ArVideoDtoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ArVideoDtoToJson(this);
}
