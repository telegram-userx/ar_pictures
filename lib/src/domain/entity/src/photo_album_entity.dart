import 'package:json_annotation/json_annotation.dart';

part '../../../../generated/src/domain/entity/src/photo_album_entity.g.dart';

@JsonSerializable()
class PhotoAlbumEntity {
  final String? id;
  final String? titleRu;
  final String? titleTm;
  final String? titleEn;
  final String? descriptionRu;
  final String? descriptionTm;
  final String? descriptionEn;
  final String? posterImageUrl;
  final bool isFullyDownloaded;

  PhotoAlbumEntity({
    this.id,
    this.titleRu,
    this.titleTm,
    this.titleEn,
    this.descriptionRu,
    this.descriptionTm,
    this.descriptionEn,
    this.posterImageUrl,
    this.isFullyDownloaded = false,
  });

  PhotoAlbumEntity copyWith({
    String? id,
    String? titleRu,
    String? titleTm,
    String? titleEn,
    String? descriptionRu,
    String? descriptionTm,
    String? descriptionEn,
    String? posterImageUrl,
    bool? isFullyDownloaded,
  }) {
    return PhotoAlbumEntity(
      id: id ?? this.id,
      titleRu: titleRu ?? this.titleRu,
      titleTm: titleTm ?? this.titleTm,
      titleEn: titleEn ?? this.titleEn,
      descriptionRu: descriptionRu ?? this.descriptionRu,
      descriptionTm: descriptionTm ?? this.descriptionTm,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      posterImageUrl: posterImageUrl ?? this.posterImageUrl,
      isFullyDownloaded: isFullyDownloaded ?? this.isFullyDownloaded,
    );
  }

  // TODO Return according to current locale
  String get title => titleTm ?? '';
  String get description => descriptionTm ?? '';

  /// Connect the generated [_$PhotoAlbumEntityFromJson] function to the `fromJson`
  /// factory.
  factory PhotoAlbumEntity.fromJson(Map<String, dynamic> json) => _$PhotoAlbumEntityFromJson(json);

  /// Connect the generated [_$PhotoAlbumEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PhotoAlbumEntityToJson(this);
}
