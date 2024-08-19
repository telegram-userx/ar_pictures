import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: OnboardingRoute.page,
        ),
        AutoRoute(
          page: PhotoAlbumRoute.page,
        ),
        AutoRoute(
          page: ArJsWebViewRoute.page,
        ),
      ];
}
