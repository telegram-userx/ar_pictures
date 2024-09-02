import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../common/constant/app_constants.dart';

part '../../../../../../generated/src/data/data_source/remote/dto/src/photo_album_dto.g.dart';

@JsonSerializable()
class PhotoAlbumDto {
  final String? id;
  final String? markerFile;
  final double? markerFileSizeInBytes;

  PhotoAlbumDto({
    this.id,
    this.markerFile,
    this.markerFileSizeInBytes,
  });

  // ClassName
  static const className = 'photo_album';

  String get markerFileUrl => '${dotenv.env[kVarDirectusApiUrl]!}/assets/$markerFile';

  /// Connect the generated [_$PhotoAlbumDtoFromJson] function to the `fromJson`
  /// factory.
  factory PhotoAlbumDto.fromJson(Map<String, dynamic> json) => _$PhotoAlbumDtoFromJson(json);

  /// Connect the generated [_$PhotoAlbumDtoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PhotoAlbumDtoToJson(this);
}
