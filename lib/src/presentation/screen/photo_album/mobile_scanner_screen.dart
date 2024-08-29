import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobx/mobx.dart';

import '../../../common/config/router/app_router.dart';
import '../../../common/config/router/app_router.gr.dart';
import '../../../common/extension/extensions.dart';
import '../../../common/services/permissions_service/permissions_service.dart';
import '../../../service_locator/sl.dart';
import 'store/photo_album_store.dart';

@RoutePage()
class MobileScannerScreen extends StatefulWidget {
  const MobileScannerScreen({super.key});

  @override
  State<MobileScannerScreen> createState() => _MobileScannerScreenState();
}

class _MobileScannerScreenState extends State<MobileScannerScreen> {
  late final List<ReactionDisposer> _disposers;
  late final MobileScannerController _scannerController;

  @override
  void initState() {
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      detectionTimeoutMs: 1000,
    );

    _disposers = [
      reaction(
        (_) => sl<PermissionsService>().hasCameraPermission,
        (hasCameraPermission) {
          if (!hasCameraPermission) {
            sl<PermissionsService>().requestCameraPermission();
          }
        },
      )
    ];

    super.initState();
  }

  @override
  void dispose() {
    _scannerController.dispose();

    for (final dispose in _disposers) {
      dispose();
    }

    super.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    final barcode = barcodes.barcodes.firstOrNull;

    if (barcode?.rawValue != null && (barcode?.rawValue?.isUUID ?? false)) {
      final album = await sl<PhotoAlbumStore>().getPhotoAlbumById(barcode!.rawValue!);

      if (sl<PhotoAlbumStore>().getPhotoAlbumByIdStatus.isFulfilled) {
        if (album?.isFullyDownloaded ?? false) {
          sl<AppRouter>().replace(
            ArJsWebViewRoute(albumId: album?.id ?? ''),
          );
        } else {
          // TODO Show submit dialog route
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gözel aý'),
        automaticallyImplyLeading: false,
      ),
      body: Observer(builder: (_) {
        if (sl<PhotoAlbumStore>().getPhotoAlbumByIdStatus.isPending) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return MobileScanner(
          controller: _scannerController,
          onDetect: _handleBarcode,
        );
      }),
    );
  }
}
