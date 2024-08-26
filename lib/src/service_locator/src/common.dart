part of '../sl.dart';

Future<void> _initCommon() async {
  // .env
  await dotenv.load(fileName: ".env");

  await _setOrientation();

  sl.registerSingleton<SharedPreferencesHelper>(
    SharedPreferencesHelper(
      preferences: await SharedPreferences.getInstance(),
    ),
  );

  sl.registerSingleton<Talker>(
    Talker(),
  );

  sl.registerSingleton<PermissionsService>(
    PermissionsService(),
  );

  sl.registerSingleton<FileSystemService>(
    FileSystemService(sl<PermissionsService>()),
  );

  sl.registerSingleton<DioHttpClient>(
    DioHttpClient(),
  );

  sl.registerSingleton<AppRouter>(
    AppRouter(),
  );

  // Register local server
  sl.registerSingleton<LocalServer>(
    LocalServer(
      fileSystemService: sl<FileSystemService>(),
    ),
  );
}

_setOrientation() async {
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
}
