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

  sl.registerSingleton<AppRouter>(
    AppRouter(),
  );
}

_setOrientation() async {
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
}
