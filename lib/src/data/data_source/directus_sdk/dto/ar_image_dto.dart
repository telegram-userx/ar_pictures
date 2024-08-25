import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

import '../directus_sdk.dart';

part '../../../../../generated/src/data/data_source/directus_sdk/dto/ar_image_dto.g.dart';

@JsonSerializable()
class ArImageDto extends DirectusDtoBase {
  final String? id;
  final String? image;
  final String? imageMarker;
  final String? arVideo;
  final String? photoAlbum;

  ArImageDto({
    this.id,
    this.image,
    this.imageMarker,
    this.arVideo,
    this.photoAlbum,
  }) : super(className);

  // Static getters
  static const className = 'ar_photo';

  String? get imageUrl => '${dotenv.env[kVarDirectusApiUrl]!}/assets/$image';
  String? get imageMarkerUrl => '${dotenv.env[kVarDirectusApiUrl]!}/assets/$imageMarker';
  String? get videoUrl => '${dotenv.env[kVarDirectusApiUrl]!}/assets/$arVideo';

  /// Connect the generated [_$ArImageDtoFromJson] function to the `fromJson`
  /// factory.
  factory ArImageDto.fromJson(Map<String, dynamic> json) => _$ArImageDtoFromJson(json);

  /// Connect the generated [_$ArImageDtoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ArImageDtoToJson(this);
}
