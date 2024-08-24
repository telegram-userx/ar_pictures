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

  // Init database
  sl.registerSingleton<PhotoAlbumDao>(
    PhotoAlbumDao(database: sl<AppDatabase>()),
  );

  // Initialize repository
  sl.registerSingleton<PhotoAlbumRepository>(
    PhotoAlbumRepositoryImpl(
      photoAlbumSdk: sl<PhotoAlbumSdk>(),
      photoAlbumDao: sl<PhotoAlbumDao>(),
    ),
  );
}
