part of '../sl.dart';

Future<void> _initDataLayer() async {
  // Initialize directus
  final String directusBaseUrl = dotenv.env[kVarDirectusApiUrl]!;
  final directusSdk = Directus(directusBaseUrl);
  await directusSdk.init();

  sl.registerSingleton<DirectusCore>(directusSdk);

  // Init sdk
  sl.registerSingleton<ArVideoSdk>(
    ArVideoSdk(directusSdk: directusSdk),
  );

  sl.registerSingleton<PhotoAlbumSdk>(
    PhotoAlbumSdk(directusSdk: directusSdk),
  );
}
