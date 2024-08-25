import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

import '../directus_sdk.dart';

part '../../../../../generated/src/data/data_source/directus_sdk/dto/photo_album_dto.g.dart';

@JsonSerializable()
class PhotoAlbumDto extends DirectusDtoBase {
  final String? id;
  final String? titleRu;
  final String? titleTk;
  final String? titleEn;
  final String? contentRu;
  final String? contentTk;
  final String? contentEn;
  final String? posterImage;

  PhotoAlbumDto({
    this.id,
    this.titleRu,
    this.titleTk,
    this.titleEn,
    this.contentRu,
    this.contentTk,
    this.contentEn,
    this.posterImage,
  }) : super(className);

  // Static getters
  static const className = 'photo_album';

  String? get posterImageUrl => '${dotenv.env[kVarDirectusApiUrl]!}/assets/$posterImage';

  /// Connect the generated [_$PhotoAlbumDtoFromJson] function to the `fromJson`
  /// factory.
  factory PhotoAlbumDto.fromJson(Map<String, dynamic> json) => _$PhotoAlbumDtoFromJson(json);

  /// Connect the generated [_$PhotoAlbumDtoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PhotoAlbumDtoToJson(this);
}
