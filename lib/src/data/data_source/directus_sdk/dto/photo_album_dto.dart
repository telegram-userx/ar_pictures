import 'package:json_annotation/json_annotation.dart';

part '../../../../../generated/src/data/data_source/directus_sdk/dto/photo_album_dto.g.dart';

@JsonSerializable()
class PhotoAlbumDto {
  final String? id;
  final String? titleRu;
  final String? titleTm;
  final String? titleEn;
  final String? descriptionRu;
  final String? descriptionTm;
  final String? descriptionEn;
  final String? posterImageUrl;

  PhotoAlbumDto({
    this.id,
    this.titleRu,
    this.titleTm,
    this.titleEn,
    this.descriptionRu,
    this.descriptionTm,
    this.descriptionEn,
    this.posterImageUrl,
  });

  // Static getters
  static const className = 'photo_album';

  /// Connect the generated [_$PhotoAlbumDtoFromJson] function to the `fromJson`
  /// factory.
  factory PhotoAlbumDto.fromJson(Map<String, dynamic> json) => _$PhotoAlbumDtoFromJson(json);

  /// Connect the generated [_$PhotoAlbumDtoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PhotoAlbumDtoToJson(this);
}
