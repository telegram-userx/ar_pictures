import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:turkmen_localization_support/turkmen_localization_support.dart';

import '../../common/config/router/app_router.dart';
import '../../service_locator/sl.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Localization
      localizationsDelegates: const [
        ...TkDelegates.delegates,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      // Router
      routerConfig: sl<AppRouter>().config(),
    );
  }
}
