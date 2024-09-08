import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../common/config/router/app_router.gr.dart';
import '../../common/logger/logger.dart';

@RoutePage()
class ArJsWebViewScreen extends StatefulWidget {
  const ArJsWebViewScreen({
    super.key,
    required this.albumId,
  });

  final String albumId;

  @override
  State<ArJsWebViewScreen> createState() => _ArJsWebViewScreenState();
}

class _ArJsWebViewScreenState extends State<ArJsWebViewScreen> {
  late InAppWebViewController webViewController;

  @override
  void dispose() {
    webViewController.loadUrl(
      urlRequest: URLRequest(
        url: WebUri(
          'https://google.com',
        ),
      ),
    );
    webViewController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.replaceRoute(
              const QrScannerRoute(),
            );
          },
          icon: const Icon(
            CupertinoIcons.chevron_left,
          ),
        ),
      ),
      body: InAppWebView(
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          useOnDownloadStart: true,
          mediaPlaybackRequiresUserGesture: false,
          pageZoom: 10,
        ),
        initialUrlRequest: URLRequest(
          url: WebUri(
            'http://localhost:3333/albums/${widget.albumId}',
          ),
        ),
        onWebViewCreated: (controller) async {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          Logger.i("Page finished loading: $url");
        },
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          Logger.i("challenge $challenge");
          return ServerTrustAuthResponse(
            action: ServerTrustAuthResponseAction.PROCEED,
          );
        },
        onReceivedError: (controller, url, error) {
          Logger.i("Error loading page: ${error.description}");
        },
        onPermissionRequest: (controller, request) async {
          return PermissionResponse(
            resources: request.resources,
            action: PermissionResponseAction.GRANT,
          );
        },
        onLoadStart: (controller, url) {
          Logger.i("Page started loading: $url");
        },
      ),
    );
  }
}
