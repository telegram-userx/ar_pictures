part of '../sl.dart';

Future<void> _initPresentationLayer() async {
  sl.registerSingleton<PhotoAlbumStore>(
    PhotoAlbumStore(
      albumRepository: sl<PhotoAlbumRepository>(),
    ),
  );
}
