import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/src/build_context.dart';
import '../../../../common/extension/src/future_status.dart';
import '../../../../common/widget/cached_image.dart';
import '../../../../domain/entity/src/photo_album_entity.dart';
import '../../../../service_locator/sl.dart';
import '../store/ar_image_store.dart';

class PhotoAlbumCardWidget extends StatelessWidget {
  const PhotoAlbumCardWidget({
    super.key,
    required this.photoAlbum,
  });

  final PhotoAlbumEntity photoAlbum;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          if (photoAlbum.isFullyDownloaded) {
          } else {
            sl<ArImageStore>().downloadArImages(photoAlbum.id);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: context.height * 0.24,
              child: CachedImage(
                imageUrl: photoAlbum.posterImageUrl,
                borderRadius: AppConstants.borderRadius - 10,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      photoAlbum.title,
                      style: context.textTheme.titleMedium,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  _DownloadButton(
                    photoAlbum: photoAlbum,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final PhotoAlbumEntity photoAlbum;

  const _DownloadButton({
    required this.photoAlbum,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final getArImagesStatus = sl<ArImageStore>().getArImagesStatus;

      return ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 40,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
          ),
          onPressed: getArImagesStatus[photoAlbum.id]?.isPending ?? false
              ? () {}
              : () {
                  sl<ArImageStore>().downloadArImages(photoAlbum.id);
                },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: getArImagesStatus[photoAlbum.id]?.isPending ?? false
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const Icon(Icons.download_outlined),
          ),
        ),
      );
    });
  }
}
