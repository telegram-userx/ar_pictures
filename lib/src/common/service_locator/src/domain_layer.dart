part of '../sl.dart';

Future<void> _initDomainLayer() async {
  sl.registerSingleton<PhotoAlbumRepository>(
    PhotoAlbumRepositoryImpl(
      remotePhotoAlbumRepository: RemotePhotoAlbumRepositoryImpl(
        albumSdk: sl<PhotoAlbumSdk>(),
        arVideoSdk: sl<ArVideoSdk>(),
      ),
      localPhotoAlbumRepository: LocalPhotoAlbumRepositoryImpl(
        albumDao: sl<PhotoAlbumDao>(),
        arVideoDao: sl<ArVideoDao>(),
      ),
    ),
  );
}
