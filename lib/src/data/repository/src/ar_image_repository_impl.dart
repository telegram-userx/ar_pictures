import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../../../common/services/file_system_service/file_system_service.dart';
import '../../../common/services/http_service/dio_http_client.dart';
import '../../../domain/entity/src/ar_image_entity.dart';
import '../../../domain/repository/repository.dart';
import '../../data_source/directus_sdk/directus_sdk.dart';
import '../../data_source/drift/drift.dart';

class ArImageRepositoryImpl implements ArImageRepository {
  final ArImageSdk _arImageSdk;
  final ArImageDao _arImageDao;
  final FileSystemService _fileSystemService;
  final DioHttpClient _httpClient;

  ArImageRepositoryImpl({
    required ArImageSdk arImageSdk,
    required ArImageDao arImageDao,
    required FileSystemService fileSystemService,
    required DioHttpClient httpClient,
  })  : _arImageSdk = arImageSdk,
        _arImageDao = arImageDao,
        _fileSystemService = fileSystemService,
        _httpClient = httpClient;

  @override
  Future<List<ArImageEntity>> getArImages({required String photoAlbumId}) async {
    final arImagesDto = await _arImageSdk.getByPhotoAlbumId(photoAlbumId);

    return arImagesDto.map(_mapArImageDtoToEntity).toList();
  }

  @override
  Future<ArImageEntity> downloadVideo({required ArImageEntity image}) async {
    if (image.isVideoDownloaded) return image;

    if (image.videoUrl == null) {
      throw Exception('Video URL is null');
    }

    final getVideoResponse = await _httpClient.get(
      url: image.videoUrl!,
      responseType: ResponseType.bytes,
    );

    if (getVideoResponse.statusCode == 200) {
      final videoFileLocation = '${image.id}.mp4';

      await _fileSystemService.saveFile(videoFileLocation, getVideoResponse.data);

      await _arImageDao.update(
        companion: ArImageTableCompanion(
          id: Value(image.id!),
          isVideoDownloaded: const Value(true),
          videoLocation: Value(videoFileLocation),
        ),
      );

      return image.copyWith(
        isVideoDownloaded: true,
        videoLocation: videoFileLocation,
      );
    }

    throw Exception('Failed to download video, status code: ${getVideoResponse.statusCode}');
  }

  @override
  Future<List<ArImageEntity>> getArImagesFromLocal() async {
    return (await _arImageDao.get()).map(_mapArImageTableDataToEntity).toList();
  }

  @override
  Stream<ArImageEntity> downloadVideos({required List<ArImageEntity> images}) async* {
    for (final image in images) {
      yield await downloadVideo(image: image);
    }
  }
}

ArImageEntity _mapArImageDtoToEntity(ArImageDto dto) {
  return ArImageEntity(
    id: dto.id,
    photoAlbumId: dto.photoAlbum,
    videoUrl: dto.videoUrl,
    videoSize: dto.videoSize,
  );
}

ArImageEntity _mapArImageTableDataToEntity(ArImageTableData dao) {
  return ArImageEntity(
    id: dao.id,
    photoAlbumId: dao.photoAlbumId,
    videoUrl: dao.videoUrl,
    videoLocation: dao.videoLocation,
    isVideoDownloaded: dao.isVideoDownloaded,
  );
}
