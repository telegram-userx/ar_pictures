import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../generated/strings.g.dart';
import '../../../common/constant/app_constants.dart';
import '../../../common/extension/extensions.dart';
import '../../../common/widget/space.dart';
import '../../../domain/entity/entity.dart';
import '../../../service_locator/sl.dart';
import 'store/photo_album_store.dart';

@RoutePage()
class DownloadAlbumFilesScreen extends StatefulWidget {
  const DownloadAlbumFilesScreen({
    super.key,
    required this.photoAlbumEntity,
  });

  final PhotoAlbumEntity photoAlbumEntity;

  @override
  State<DownloadAlbumFilesScreen> createState() => _DownloadAlbumFilesScreenState();
}

class _DownloadAlbumFilesScreenState extends State<DownloadAlbumFilesScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<PhotoAlbumStore>().getRequiredDownloadSize(widget.photoAlbumEntity.id ?? '');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.padding),
        constraints: BoxConstraints(
          minWidth: context.width * 0.8,
          minHeight: context.height * 0.3,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadius,
          ),
        ),
        child: Observer(builder: (_) {
          final getPhotoAlbumByIdStatus = sl<PhotoAlbumStore>().getPhotoAlbumByIdStatus;

          if (getPhotoAlbumByIdStatus.isPending) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (getPhotoAlbumByIdStatus.isRejected) {
            return Center(
              child: Text(
                context.translations.somethingWentWrong,
                style: context.textTheme.titleLarge,
              ),
            );
          }

          return Column(
            children: [
              ...[
                Text(
                  context.translations.areYouSureDownload(
                    megabytes: widget.photoAlbumEntity.markersSizeInMegaBytes ?? 0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: [
                    FilledButton(
                      onPressed: () {},
                      child: Text(context.translations.download),
                    ),
                    FilledButton(
                      onPressed: () {
                        context.maybePop();
                      },
                      child: Text(context.translations.cancel),
                    ),
                  ],
                ),
              ].expand(
                (e) => [
                  e,
                  Space.v20,
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
