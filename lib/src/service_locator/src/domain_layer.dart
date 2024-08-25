part of '../sl.dart';

Future<void> _initDomainLayer() async {
  // Initialize repository
  sl.registerSingleton<PhotoAlbumRepository>(
    PhotoAlbumRepositoryImpl(
      photoAlbumSdk: sl<PhotoAlbumSdk>(),
      photoAlbumDao: sl<PhotoAlbumDao>(),
    ),
  );

  sl.registerSingleton<ArImageRepository>(
    ArImageRepositoryImpl(
      arImageDao: sl<ArImageDao>(),
      arImageSdk: sl<ArImageSdk>(),
      fileSystemService: sl<FileSystemService>(),
      httpClient: sl<DioHttpClient>(),
    ),
  );
}
