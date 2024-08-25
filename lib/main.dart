import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'generated/strings.g.dart';
import 'src/common/logger/logger.dart';
import 'src/presentation/screen/application.dart';
import 'src/service_locator/sl.dart';

void main() => runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        FlutterError.onError = Logger.logFlutterError;
        PlatformDispatcher.instance.onError = Logger.logPlatformDispatcherError;

        // TODO Remove from here
        LocaleSettings.useDeviceLocale();

        if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
          await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
        }

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
