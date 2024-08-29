import 'package:equatable/equatable.dart';
import 'package:mobx/mobx.dart';

import '../entity.dart';

class PhotoAlbumEntity extends Equatable {
  final String? id;
  final String? titleRu;
  final String? titleTk;
  final String? titleEn;
  final String? contentRu;
  final String? contentTk;
  final String? contentEn;
  final String? posterImageUrl;
  final String mindFileUrl;
  final bool isFullyDownloaded;
  final double? markersSizeInMegaBytes;
  final ObservableList<ArImageEntity>? arImages;

  const PhotoAlbumEntity({
    this.id,
    this.titleRu,
    this.titleTk,
    this.titleEn,
    this.contentRu,
    this.contentTk,
    this.contentEn,
    this.posterImageUrl,
    this.mindFileUrl = '',
    this.isFullyDownloaded = false,
    this.markersSizeInMegaBytes,
    this.arImages,
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
    String? mindFileUrl,
    bool? isFullyDownloaded,
    double? markersSizeInMegaBytes,
    ObservableList<ArImageEntity>? arImages,
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
      mindFileUrl: mindFileUrl ?? this.mindFileUrl,
      isFullyDownloaded: isFullyDownloaded ?? this.isFullyDownloaded,
      markersSizeInMegaBytes: markersSizeInMegaBytes ?? this.markersSizeInMegaBytes,
      arImages: arImages ?? this.arImages,
    );
  }

  // TODO Return according to current locale
  String get title => titleTk ?? '';
  String get content => contentTk ?? '';

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
        mindFileUrl,
        isFullyDownloaded,
        markersSizeInMegaBytes,
        arImages,
      ];
}
