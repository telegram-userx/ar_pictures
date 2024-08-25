import '../../../domain/entity/src/ar_image_entity.dart';
import '../../../domain/repository/repository.dart';
import '../../data_source/directus_sdk/directus_sdk.dart';

class ArImageRepositoryImpl implements ArImageRepository {
  final ArImageSdk _arImageSdk;

  ArImageRepositoryImpl({
    required ArImageSdk arImageSdk,
  }) : _arImageSdk = arImageSdk;

  @override
  Future<List<ArImageEntity>> getArImages({required String photoAlbumId}) async {
    final arImagesDto = await _arImageSdk.getByPhotoAlbumId(photoAlbumId);

    return arImagesDto.map(_mapArImageDtoToEntity).toList();
  }

  @override
  Future<ArImageEntity> downloadMindFile({required ArImageEntity image}) {
    // TODO: implement downloadMindFile
    throw UnimplementedError();
  }

  @override
  Future<ArImageEntity> downloadVideo({required ArImageEntity image}) {
    // TODO: implement downloadVideo
    throw UnimplementedError();
  }

  @override
  Stream<ArImageEntity> downloadArData({required List<ArImageEntity> images}) {
    // TODO: implement downloadArData
    throw UnimplementedError();
  }
}

ArImageEntity _mapArImageDtoToEntity(ArImageDto dto) {
  return ArImageEntity(
    id: dto.id,
    photoAlbumId: dto.photoAlbum,
    videoUrl: dto.videoUrl,
    mindFileUrl: dto.imageMarkerUrl,
  );
}
