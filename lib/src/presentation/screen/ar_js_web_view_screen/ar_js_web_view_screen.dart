import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InAppWebView(
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          useOnDownloadStart: true,
          mediaPlaybackRequiresUserGesture: false,
          pageZoom: 10,
        ),
        initialUrlRequest: URLRequest(
          url: WebUri(
            'http://localhost:8080/albums/${widget.albumId}',
          ),
        ),
        onWebViewCreated: (controller) async {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          print("Page finished loading: $url");
        },
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          print("challenge $challenge");
          return ServerTrustAuthResponse(
            action: ServerTrustAuthResponseAction.PROCEED,
          );
        },
        onReceivedError: (controller, url, error) {
          print("Error loading page: ${error.description}");
        },
        onPermissionRequest: (controller, request) async {
          return PermissionResponse(
            resources: request.resources,
            action: PermissionResponseAction.GRANT,
          );
        },
        onLoadStart: (controller, url) {
          print("Page started loading: $url");
        },
      ),
    );
  }
}
