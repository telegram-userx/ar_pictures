import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobx/mobx.dart';

import '../../common/config/router/app_router.gr.dart';
import '../../common/extension/extensions.dart';
import '../../common/widget/space.dart';
import '../../service_locator/sl.dart';
import 'store/qr_scanner_store.dart';

@RoutePage()
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late final List<ReactionDisposer> _disposers;

  late final MobileScannerController _scannerController;

  @override
  void initState() {
    _disposers = [
      reaction(
        (_) => sl<QrScannerStore>().albumFuture.status,
        (status) {
          if (status.isFulfilled) {
            final album = sl<QrScannerStore>().albumFuture.value;

            if (album?.isFullyDownloaded ?? false) {
              context.pushRoute(
                ArJsWebViewRoute(
                  albumId: album?.id ?? '',
                ),
              );
            } else {
              context.pushRoute(
                ArDataLoaderRoute(
                  photoAlbum: album,
                ),
              );
            }
          }
        },
        delay: 3000,
      ),
    ];

    _scannerController = MobileScannerController();

    super.initState();
  }

  @override
  void dispose() async {
    for (final disposer in _disposers) {
      disposer();
    }

    super.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    final barcodeValue = barcodes.barcodes.firstOrNull?.rawValue ?? '';

    if (barcodeValue.isUUID) {
      sl<QrScannerStore>().getAlbum(barcodeValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GÖZEL AÝ'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => context.pushRoute(const OnboardingRoute()),
            icon: const Icon(
              CupertinoIcons.info,
            ),
          ),
        ],
      ),
      body: Observer(builder: (_) {
        final albumFuture = sl<QrScannerStore>().albumFuture;

        if (albumFuture.status.isPending) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (albumFuture.value != null || AutoRouter.of(context, watch: true).current.name != QrScannerRoute.name) {
          return Space.empty;
        }

        return MobileScanner(
          controller: _scannerController,
          onDetect: _handleBarcode,
        );
      }),
    );
  }
}
