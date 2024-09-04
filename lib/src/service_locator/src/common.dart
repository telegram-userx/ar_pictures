part of '../sl.dart';

Future<void> _initCommon() async {
  // .env
  await dotenv.load(fileName: ".env");

  await _setOrientation();

  sl.registerSingleton<Talker>(
    Talker(
      observer: LoggerObserver(),
    ),
  );

  sl.registerSingleton<PermissionsService>(
    PermissionsService(),
  );

  sl.registerSingleton<SharedPreferencesHelper>(
    SharedPreferencesHelper(
      preferences: await SharedPreferences.getInstance(),
    ),
  );

  sl.registerSingleton<Dio>(
    Dio(),
  );

  sl.registerSingleton<DownloadFileService>(
    DownloadFileService(
      dio: sl<Dio>(),
    ),
  );

  // Register local server
  sl.registerSingleton<LocalServer>(
    LocalServer(),
  );

  // Locale settings
  LocaleSettings.setLocaleRaw(sl<SharedPreferencesHelper>().locale ?? '');

  LocaleSettings.getLocaleStream().listen(
    (event) {
      sl<SharedPreferencesHelper>().setLocale(event.languageTag);
    },
  );
}

_setOrientation() async {
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
}
