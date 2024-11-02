import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/data_source/local/shared_preferences/shared_preferences_helper.dart';
import '../../../domain/entity/entity.dart';
import '../../../presentation/ar_data_loader/ar_data_loader_screen.dart';
import '../../../presentation/ar_js_webview/ar_js_webview_screen.dart';
import '../../../presentation/onboarding/onboarding_screen.dart';
import '../../../presentation/qr_scanner/qr_scanner_screen.dart';
import '../../../service_locator/sl.dart';
import 'app_routes.dart'; // Import the routes

class AppRouter {
  final SharedPreferencesHelper _prefsHelper = sl<SharedPreferencesHelper>();

  GoRouter get router => GoRouter(
        initialLocation: _prefsHelper.isFirstAppLaunch ? AppRoutes.onboarding : AppRoutes.qrScanner,
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.onboarding,
            name: AppRoutes.onboarding,
            builder: (BuildContext context, GoRouterState state) {
              return const OnboardingScreen();
            },
          ),
          GoRoute(
            path: AppRoutes.qrScanner,
            name: AppRoutes.qrScanner,
            builder: (BuildContext context, GoRouterState state) {
              return const QrScannerScreen();
            },
          ),
          GoRoute(
            path: AppRoutes.arJsWebView,
            name: AppRoutes.arJsWebView,
            builder: (BuildContext context, GoRouterState state) {
              return ArJsWebViewScreen(albumId: state.extra as String);
            },
          ),
          GoRoute(
            path: AppRoutes.arDataLoader,
            name: AppRoutes.arDataLoader,
            builder: (BuildContext context, GoRouterState state) {
              return ArDataLoaderScreen(
                photoAlbum: state.extra as PhotoAlbumEntity?,
              );
            },
          ),
        ],
      );
}
