import 'package:mobx/mobx.dart';

import '../../../domain/entity/entity.dart';
import '../../../domain/repository/repository.dart';
import '../../data_source/remote/directus_sdk/src/ar_video_sdk.dart';
import '../../data_source/remote/directus_sdk/src/photo_album_sdk.dart';

class RemotePhotoAlbumRepositoryImpl implements PhotoAlbumRepository {
  final PhotoAlbumSdk _albumSdk;
  final ArVideoSdk _arVideoSdk;

  RemotePhotoAlbumRepositoryImpl({
    required PhotoAlbumSdk albumSdk,
    required ArVideoSdk arVideoSdk,
  })  : _albumSdk = albumSdk,
        _arVideoSdk = arVideoSdk;

  @override
  Future<PhotoAlbumEntity> getAlbum(String id) async {
    final album = await _albumSdk.getById(id);
    final videos = await getVideos(album.id ?? '');

    return PhotoAlbumEntity(
      id: album.id ?? '',
      markerFileSizeInBytes: album.markerFileSizeInBytes ?? 0,
      markerFileUrl: album.markerFileUrl,
      isMarkerFileDownloaded: false,
      arVideos: ObservableList.of(videos),
    );
  }

  @override
  Future<List<ArVideoEntity>> getVideos(String albumId) async {
    final videos = await _arVideoSdk.getByAlbumId(albumId);

    return videos
        .map<ArVideoEntity>(
          (e) => ArVideoEntity(
            id: e.id ?? '',
            albumId: e.photoAlbumId ?? '',
            isVideoDownloaded: false,
            videoSizeInBytes: e.videoSizeInBytes ?? 0,
            videoUrl: e.videoUrl ?? '',
          ),
        )
        .toList();
  }
}
