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

  // Locale settings
  LocaleSettings.setLocaleRaw(sl<SharedPreferencesHelper>().locale ?? '');

  LocaleSettings.getLocaleStream().listen(
    (event) {
      sl<SharedPreferencesHelper>().setLocale(event.languageTag);
    },
  );

  sl.registerSingleton<Talker>(
    Talker(),
  );
}

_setOrientation() async {
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
}
