import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../common/config/router/app_router.gr.dart';
import '../../common/extension/extensions.dart';

@RoutePage()
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with WidgetsBindingObserver {
  late final MobileScannerController _scannerController;
  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    _scannerController = MobileScannerController();

    _subscription = _scannerController.barcodes.listen(_handleBarcode);

    unawaited(_scannerController.start());

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the _scannerController is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the _scannerController is ready.
    if (!_scannerController.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = _scannerController.barcodes.listen(_handleBarcode);

        unawaited(_scannerController.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(_scannerController.stop());
    }
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);

    unawaited(_subscription?.cancel());

    _subscription = null;

    super.dispose();

    await _scannerController.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    final barcode = barcodes.barcodes.firstOrNull;

    if (barcode?.rawValue != null && (barcode?.rawValue?.isUUID ?? false)) {
      // TODO
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
      body: MobileScanner(
        controller: _scannerController,
        onDetect: _handleBarcode,
      ),
    );
  }
}