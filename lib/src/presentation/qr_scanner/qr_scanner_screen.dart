import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/config/router/app_router.gr.dart';

@RoutePage()
class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GÖZEL AÝ'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => context.pushRoute(const OnboardingRoute()),
            icon: const Icon(
              CupertinoIcons.info,
            ),
          ),
        ],
      ),
    );
  }
}
