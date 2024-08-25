part of '../sl.dart';

Future<void> _initDataLayer() async {
  // Initialize directus
  final String directusBaseUrl = dotenv.env[kVarDirectusApiUrl]!;
  final directusSdk = Directus(directusBaseUrl);
  await directusSdk.init();

  sl.registerSingleton<DirectusCore>(directusSdk);

  // Initialize drift database
  final dbOpener = AppDatabaseOpener.openDatabase(name: dotenv.env['DRIFT_DATABASE_NAME']!);

  sl.registerSingleton<AppDatabase>(
    AppDatabase(dbOpener),
  );

  // Init sdk
  sl.registerSingleton<PhotoAlbumSdk>(
    PhotoAlbumSdk(directusSdk: directusSdk),
  );

  sl.registerSingleton<ArImageSdk>(
    ArImageSdk(directusSdk: directusSdk),
  );

  // Init database
  sl.registerSingleton<PhotoAlbumDao>(
    PhotoAlbumDao(database: sl<AppDatabase>()),
  );

  sl.registerSingleton<ArImageDao>(
    ArImageDao(database: sl<AppDatabase>()),
  );
}
