import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobx/mobx.dart';

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
          if (!hasCameraPermission.value) {
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

  void _handleBarcode(BarcodeCapture barcodes) {
    final barcode = barcodes.barcodes.firstOrNull;

    if (barcode?.rawValue != null) {
      sl<PhotoAlbumStore>().getPhotoAlbumById(barcode!.rawValue!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReactionBuilder(
      builder: (_) => reaction(
        (_) => sl<PhotoAlbumStore>().getPhotoAlbumByIdStatus,
        (status) {
          if (status.isFulfilled) {
            context.maybePop();
          }
        },
      ),
      child: Scaffold(
        appBar: AppBar(),
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
      ),
    );
  }
}
