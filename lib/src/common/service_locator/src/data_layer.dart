part of '../sl.dart';

Future<void> _initDataLayer() async {
  // Initialize directus
  final String directusBaseUrl = dotenv.env[kVarDirectusApiUrl]!;
  final directusSdk = Directus(directusBaseUrl);
  await directusSdk.init();

  sl.registerSingleton<DirectusCore>(directusSdk);

  // Init database
  final dbOpener = AppDatabaseOpener.openDatabase(name: kVarDatabaseName);

  sl.registerSingleton<AppDatabase>(
    AppDatabase(dbOpener),
  );

  // Init sdk
  sl.registerSingleton<ArVideoSdk>(
    ArVideoSdk(directusSdk: directusSdk),
  );

  sl.registerSingleton<PhotoAlbumSdk>(
    PhotoAlbumSdk(directusSdk: directusSdk),
  );

  // Init database
  sl.registerSingleton<PhotoAlbumDao>(
    PhotoAlbumDao(database: sl<AppDatabase>()),
  );

  sl.registerSingleton<ArVideoDao>(
    ArVideoDao(database: sl<AppDatabase>()),
  );
}
