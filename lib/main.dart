import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'generated/strings.g.dart';
import 'src/common/logger/logger.dart';
import 'src/service_locator/sl.dart';
import 'src/presentation/application.dart';

void main() => runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        FlutterError.onError = Logger.logFlutterError;
        PlatformDispatcher.instance.onError = Logger.logPlatformDispatcherError;

        io.HttpOverrides.global = MyHttpOverrides();

        // Init service locator
        await initServiceLocator();

        runApp(
          TranslationProvider(
            child: const Application(),
          ),
        );
      },
      Logger.logZoneError,
    );

class MyHttpOverrides extends io.HttpOverrides {
  @override
  io.HttpClient createHttpClient(io.SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (io.X509Certificate cert, String host, int port) => true;
  }
}
