import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:turkmen_localization_support/turkmen_localization_support.dart';

import '../../../generated/strings.g.dart';
import '../common/config/router/app_router.dart';
import '../common/config/theme/theme.dart';
import '../service_locator/sl.dart';
import '../common/widget/space.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      initial: AdaptiveThemeMode.system,
      light: AppTheme.lightTheme,
      dark: AppTheme.darkTheme,
      builder: (theme, darkTheme) => MaterialApp.router(
        // Theme mode
        theme: theme,
        darkTheme: darkTheme,

        // Localization
        locale: LocaleSettings.currentLocale.flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: const [
          ...TkDelegates.delegates,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],

        // Router
        routerConfig: sl<AppRouter>().config(
          navigatorObservers: () => [
            TalkerRouteObserver(sl<Talker>()),
          ],
        ),

        // Builder
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: child ?? Space.empty,
        ),

        // Debug banner
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
