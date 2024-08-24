import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobx/mobx.dart';

import '../../../common/extension/extensions.dart';
import '../../../service_locator/sl.dart';
import 'store/photo_album_store.dart';

@RoutePage()
class MobileScannerScreen extends StatelessWidget {
  const MobileScannerScreen({super.key});

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
            onDetect: _handleBarcode,
          );
        }),
      ),
    );
  }
}
