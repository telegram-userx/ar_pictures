part of '../sl.dart';

Future<void> _initDataLayer() async {
  // Initialize directus
  final String directusBaseUrl = dotenv.env['DIRECTUS_API_URL']!;
  final directusSdk = Directus(directusBaseUrl);
  await directusSdk.init();

  sl.registerSingleton<DirectusCore>(directusSdk);

  // Initialize drift database
  final dbOpener = AppDatabaseOpener.openDatabase(name: dotenv.env['DRIFT_DATABASE_NAME']!);

  sl.registerSingleton<AppDatabase>(
    AppDatabase(dbOpener),
  );
}
