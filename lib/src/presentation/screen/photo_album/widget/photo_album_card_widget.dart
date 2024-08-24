import 'package:flutter/material.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/src/build_context.dart';
import '../../../../common/widget/cached_image.dart';
import '../../../../domain/entity/src/photo_album_entity.dart';

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
          } else {}
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
                  _DownloadButton(),
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
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 40,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
        ),
        onPressed: () {},
        child: const Icon(Icons.download_outlined),
      ),
    );
  }
}
