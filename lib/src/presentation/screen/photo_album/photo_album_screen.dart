import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../generated/strings.g.dart';
import '../../../common/config/router/app_router.gr.dart';
import '../../../common/constant/app_constants.dart';
import '../../../common/extension/src/build_context.dart';
import '../../../common/extension/src/future_status.dart';
import '../../../common/widget/space.dart';
import '../../../service_locator/sl.dart';
import 'store/photo_album_store.dart';
import 'widget/photo_album_card_widget.dart';

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

        return FilledButton(
          onPressed: () {
            context.pushRoute(const MobileScannerRoute());
          },
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.all(AppConstants.padding * 1.4),
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
          IconButton.filled(
            onPressed: () {
              context.navigateTo(const OnboardingRoute());
            },
            icon: Icon(
              CupertinoIcons.info_circle,
              color: context.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      body: Observer(builder: (_) {
        final getPhotoAlbumByIdStatus = sl<PhotoAlbumStore>().getPhotoAlbumByIdStatus;

        if (getPhotoAlbumByIdStatus.isPending) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final albums = sl<PhotoAlbumStore>().photoAlbums;
        if (albums.isEmpty) {
          return Center(
            child: FilledButton(
              onPressed: () {
                context.pushRoute(const MobileScannerRoute());
              },
              child: Text(context.translations.scan),
            ),
          );
        }

        return ListView.separated(
          separatorBuilder: (context, index) => Space.v10,
          itemCount: albums.length,
          padding: const EdgeInsets.all(AppConstants.padding),
          itemBuilder: (context, index) {
            final photoAlbum = albums[index];

            return PhotoAlbumCardWidget(photoAlbum: photoAlbum);
          },
        );
      }),
    );
  }
}
