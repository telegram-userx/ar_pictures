import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../common/config/router/app_router.gr.dart';
import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/src/build_context.dart';
import '../../../../common/extension/src/future_status.dart';
import '../../../../common/widget/cached_image.dart';
import '../../../../common/widget/space.dart';
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
          if (sl<ArImageStore>().isFullyDownloaded[photoAlbum.id!] ?? false) {
            context.pushRoute(
              ArJsWebViewRoute(
                albumId: photoAlbum.id ?? '',
              ),
            );
          } else {
            sl<ArImageStore>().fetchAndDownloadArImages(photoAlbum.id!);
          }
        },
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: context.height * 0.24,
                  child: CachedImage(
                    imageUrl: photoAlbum.posterImageUrl,
                    borderRadius: AppConstants.borderRadius - 10,
                  ),
                ),
                Space.v10,
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
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: _DownloadButton(
                photoAlbum: photoAlbum,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadButton extends StatefulWidget {
  final PhotoAlbumEntity photoAlbum;

  const _DownloadButton({
    required this.photoAlbum,
  });

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final isPending = sl<ArImageStore>().getArImagesDataStatus[widget.photoAlbum.id!]?.isPending ?? false;

      if (sl<ArImageStore>().isFullyDownloaded[widget.photoAlbum.id!] ?? false) {
        return Space.empty;
      }

      return Container(
        height: 50,
        width: 50,
        padding: const EdgeInsets.fromLTRB(
          0,
          0,
          AppConstants.padding,
          AppConstants.padding,
        ),
        child: FilledButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
          ),
          onPressed: isPending
              ? () {}
              : () {
                  sl<ArImageStore>().fetchAndDownloadArImages(widget.photoAlbum.id);
                },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: isPending
                ? Stack(
                    children: [
                      const SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              '${sl<ArImageStore>().downloadProgress[widget.photoAlbum.id!]}%',
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Icon(Icons.download_outlined),
          ),
        ),
      );
    });
  }
}
