part of '../sl.dart';

Future<void> _initPresentationLayer() async {
  sl.registerSingleton<AppRouter>(
    AppRouter(),
  );

  sl.registerSingleton<QrScannerStore>(
    QrScannerStore(
      albumRepository: sl<PhotoAlbumRepository>(),
    ),
  );
}
