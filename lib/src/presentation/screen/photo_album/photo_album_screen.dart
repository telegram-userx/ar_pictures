import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../common/config/router/app_router.gr.dart';
import '../../../common/constant/app_constants.dart';
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
      floatingActionButton: Observer(builder: (_) {
        final albums = sl<PhotoAlbumStore>().photoAlbums;

        if (albums.isEmpty) {
          return Space.empty;
        }

        return ElevatedButton(
          onPressed: () {
            context.pushRoute(const MobileScannerRoute());
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(AppConstants.padding * 1.6),
            shape: const CircleBorder(),
          ),
          child: const Icon(
            Icons.qr_code,
            size: AppConstants.iconSizeMedium,
          ),
        );
      }),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        final albums = sl<PhotoAlbumStore>().photoAlbums;

        if (albums.isEmpty) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.pushRoute(const MobileScannerRoute());
              },
              child: Text('Scan now'),
            ),
          );
        }

        return ListView.separated(
          separatorBuilder: (context, index) => Space.v10,
          itemCount: albums.length,
          padding: const EdgeInsets.all(AppConstants.padding),
          itemBuilder: (context, index) {
            final photoAlbum = albums[index];

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
