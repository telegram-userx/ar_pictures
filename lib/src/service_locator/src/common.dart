part of '../sl.dart';

Future<void> _initCommon() async {
  await _setOrientation();

  sl.registerSingleton<Talker>(
    Talker(),
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
