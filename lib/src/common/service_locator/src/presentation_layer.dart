part of '../sl.dart';

Future<void> _initPresentationLayer() async {
  sl.registerSingleton<AppRouter>(
    AppRouter(),
  );
}
