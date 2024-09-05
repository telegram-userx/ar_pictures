import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../generated/strings.g.dart';
import '../../common/config/router/app_router.dart';
import '../../common/config/router/app_router.gr.dart';
import '../../common/constant/app_constants.dart';
import '../../common/extension/extensions.dart';
import '../../common/logger/logger.dart';
import '../../common/services/download_file/download_file_service.dart';
import '../../common/widget/space.dart';
import '../../domain/entity/entity.dart';
import '../../domain/repository/repository.dart';
import '../../service_locator/sl.dart';
import '../qr_scanner/store/qr_scanner_store.dart';
import 'store/ar_data_loader_store.dart';

part '_screen.dart';

@RoutePage()
class ArDataLoaderScreen extends StatefulWidget {
  final PhotoAlbumEntity? photoAlbum;

  const ArDataLoaderScreen({
    super.key,
    required this.photoAlbum,
  });

  @override
  State<ArDataLoaderScreen> createState() => _ArDataLoaderScreenState();
}

class _ArDataLoaderScreenState extends State<ArDataLoaderScreen> {
  @override
  void dispose() {
    sl<QrScannerStore>().reset();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => ArDataLoaderStore(
        albumRepository: sl<PhotoAlbumRepository>(),
        downloadFileService: sl<DownloadFileService>(),
        photoAlbum: widget.photoAlbum,
      ),
      child: _Screen(photoAlbum: widget.photoAlbum),
    );
  }
}
