part of '../sl.dart';

Future<void> _initDomainLayer() async {
  // Initialize repository
  sl.registerSingleton<ArImageRepository>(
    ArImageRepositoryImpl(
      arImageDao: sl<ArImageDao>(),
      arImageSdk: sl<ArImageSdk>(),
      fileSystemService: sl<FileSystemService>(),
      httpClient: sl<DioHttpClient>(),
    ),
  );

  sl.registerSingleton<PhotoAlbumRepository>(
    PhotoAlbumRepositoryImpl(
      arImageRepository: sl<ArImageRepository>(),
      photoAlbumSdk: sl<PhotoAlbumSdk>(),
      photoAlbumDao: sl<PhotoAlbumDao>(),
      arImageDao: sl<ArImageDao>(),
    ),
  );
}
