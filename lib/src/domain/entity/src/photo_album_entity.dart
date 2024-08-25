import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../../../generated/src/domain/entity/src/photo_album_entity.g.dart';

@JsonSerializable()
class PhotoAlbumEntity extends Equatable {
  final String? id;
  final String? titleRu;
  final String? titleTk;
  final String? titleEn;
  final String? contentRu;
  final String? contentTk;
  final String? contentEn;
  final String? posterImageUrl;

  const PhotoAlbumEntity({
    this.id,
    this.titleRu,
    this.titleTk,
    this.titleEn,
    this.contentRu,
    this.contentTk,
    this.contentEn,
    this.posterImageUrl,
  });

  PhotoAlbumEntity copyWith({
    String? id,
    String? titleRu,
    String? titleTk,
    String? titleEn,
    String? contentRu,
    String? contentTk,
    String? contentEn,
    String? posterImageUrl,
  }) {
    return PhotoAlbumEntity(
      id: id ?? this.id,
      titleRu: titleRu ?? this.titleRu,
      titleTk: titleTk ?? this.titleTk,
      titleEn: titleEn ?? this.titleEn,
      contentRu: contentRu ?? this.contentRu,
      contentTk: contentTk ?? this.contentTk,
      contentEn: contentEn ?? this.contentEn,
      posterImageUrl: posterImageUrl ?? this.posterImageUrl,
    );
  }

  // TODO Return according to current locale
  String get title => titleTk ?? '';
  String get content => contentTk ?? '';

  /// Connect the generated [_$PhotoAlbumEntityFromJson] function to the `fromJson`
  /// factory.
  factory PhotoAlbumEntity.fromJson(Map<String, dynamic> json) => _$PhotoAlbumEntityFromJson(json);

  /// Connect the generated [_$PhotoAlbumEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PhotoAlbumEntityToJson(this);

  @override
  List<Object?> get props => [
        id,
        titleRu,
        titleTk,
        titleEn,
        contentRu,
        contentTk,
        contentEn,
        posterImageUrl,
      ];
}
