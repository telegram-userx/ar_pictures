import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../common/config/router/app_router.gr.dart';

@RoutePage()
class PhotoAlbumScreen extends StatelessWidget {
  const PhotoAlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.navigateTo(const OnboardingRoute());
            },
            icon: const Icon(
              Icons.info_outline,
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Photo Album Screen',
        ),
      ),
    );
  }
}
