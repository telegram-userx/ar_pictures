import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobx/mobx.dart';

import '../../common/extension/extensions.dart';
import '../../common/logger/logger.dart';
import '../../common/widget/space.dart';
import '../../service_locator/sl.dart';
import '../../common/config/router/app_routes.dart';
import 'store/qr_scanner_store.dart';

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
    sl<QrScannerStore>().reset();

    _disposers = [
      reaction(
        (_) => sl<QrScannerStore>().albumStatus,
        (status) {
          if (status.isFulfilled) {
            final album = sl<QrScannerStore>().album;

            if (album?.isFullyDownloaded ?? false) {
              context.replace(
                AppRoutes.arJsWebView,
                extra: album?.id ?? '',
              );
            } else {
              context.push(
                AppRoutes.arDataLoader,
                extra: album,
              );
            }
          }
        },
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

    if (barcodeValue.isUUID && GoRouterState.of(context).name == AppRoutes.qrScanner) {
      Logger.i('Detected UUID: $barcodeValue');
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
            onPressed: () => context.push(AppRoutes.onboarding),
            icon: const Icon(
              CupertinoIcons.info,
            ),
          ),
        ],
      ),
      body: Observer(builder: (_) {
        final albumStatus = sl<QrScannerStore>().albumStatus;
        final album = sl<QrScannerStore>().album;

        if (albumStatus.isPending) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (album != null && GoRouterState.of(context).name == AppRoutes.qrScanner) {
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
