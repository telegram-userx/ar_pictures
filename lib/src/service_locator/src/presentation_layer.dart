part of '../sl.dart';

Future<void> _initPresentationLayer() async {
  sl.registerSingleton<PhotoAlbumStore>(
    PhotoAlbumStore(
      albumRepository: sl<PhotoAlbumRepository>(),
    ),
  );

  sl.registerSingleton<ArImageStore>(
    ArImageStore(
      arImageRepository: sl<ArImageRepository>(),
      photoAlbumRepository: sl<PhotoAlbumRepository>(),
    ),
  );
}
