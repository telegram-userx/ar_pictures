import 'package:auto_route/auto_route.dart';

import '../../../data/data_source/shared_preferences/shared_preferences_helper.dart';
import '../../../service_locator/sl.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: OnboardingRoute.page,
          guards: [
            _isFirstAppLaunchGuard(),
          ],
        ),
        AutoRoute(
          page: PhotoAlbumRoute.page,
        ),
        AutoRoute(
          page: ArJsWebViewRoute.page,
        ),
      ];

  AutoRouteGuard _isFirstAppLaunchGuard() {
    return AutoRouteGuard.simple(
      (resolver, router) {
        if (!sl<SharedPreferencesHelper>().isFirstAppLaunch) {
          sl<SharedPreferencesHelper>().setIsFirstAppLaunch(false);

          resolver.redirect(const PhotoAlbumRoute());
        }
      },
    );
  }
}
