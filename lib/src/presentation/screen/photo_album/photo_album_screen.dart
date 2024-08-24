import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../common/config/router/app_router.gr.dart';
import '../../../common/extension/src/build_context.dart';
import '../../../common/widget/cached_image.dart';
import '../../../common/widget/space.dart';
import '../../../service_locator/sl.dart';
import 'store/photo_album_store.dart';

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
      body: Observer(builder: (_) {
        if (sl<PhotoAlbumStore>().photoAlbums.isEmpty) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.navigateTo(const MobileScannerRoute());
              },
              child: Text('Scan now'),
            ),
          );
        }

        return ListView.separated(
          separatorBuilder: (context, index) => Space.v10,
          itemCount: sl<PhotoAlbumStore>().photoAlbums.length,
          itemBuilder: (context, index) {
            final photoAlbum = sl<PhotoAlbumStore>().photoAlbums[index];

            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: context.height * 0.24,
                    child: CachedImage(
                      imageUrl: photoAlbum.posterImageUrl,
                    ),
                  ),
                  Text(
                    photoAlbum.title,
                    style: context.textTheme.titleMedium,
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
