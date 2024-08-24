import 'package:json_annotation/json_annotation.dart';

part '../../../../../generated/src/data/data_source/directus_sdk/dto/photo_album_dto.g.dart';

@JsonSerializable()
class PhotoAlbumDto {
  final String? id;
  final String? titleRu;
  final String? titleTk;
  final String? titleEn;
  final String? contentRu;
  final String? contentTk;
  final String? contentEn;
  final String? posterImageUrl;

  PhotoAlbumDto({
    this.id,
    this.titleRu,
    this.titleTk,
    this.titleEn,
    this.contentRu,
    this.contentTk,
    this.contentEn,
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
