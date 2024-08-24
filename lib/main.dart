import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/common/logger/logger.dart';
import 'src/presentation/screen/application.dart';
import 'src/service_locator/sl.dart';

void main() => runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        FlutterError.onError = Logger.logFlutterError;
        PlatformDispatcher.instance.onError = Logger.logPlatformDispatcherError;

        // Init service locator
        await initServiceLocator();

        runApp(const Application());
      },
      Logger.logZoneError,
    );
