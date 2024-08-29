import 'package:auto_route/auto_route.dart';

import '../../../data/data_source/shared_preferences/shared_preferences_helper.dart';
import '../../../service_locator/sl.dart';
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
          page: MobileScannerRoute.page,
        ),
        AutoRoute(
          page: ArJsWebViewRoute.page,
        ),
      ];
}
