import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../data/data_source/local/shared_preferences/shared_preferences_helper.dart';
import '../../service_locator/sl.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: sl<SharedPreferencesHelper>().isFirstAppLaunch,
          page: OnboardingRoute.page,
        ),
        AutoRoute(
          initial: !sl<SharedPreferencesHelper>().isFirstAppLaunch,
          page: QrScannerRoute.page,
        ),
        AutoRoute(
          page: ArJsWebviewRoute.page,
        ),
        CustomRoute(
          customRouteBuilder: <T>(context, child, page) {
            return PageRouteBuilder<T>(
              fullscreenDialog: page.fullscreenDialog,
              // this is important
              settings: page,
              pageBuilder: (_, __, ___) => child,
            );
          },
          page: ArDataLoaderRoute.page,
        )
      ];
}
