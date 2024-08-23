import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

@RoutePage()
class ArJsWebViewScreen extends StatefulWidget {
  const ArJsWebViewScreen({super.key});

  @override
  State<ArJsWebViewScreen> createState() => _ArJsWebViewScreenState();
}

class _ArJsWebViewScreenState extends State<ArJsWebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri.uri(Uri.parse('file:///android_asset/flutter_assets/assets/js/index.html')),
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          useOnDownloadStart: true,
          mediaPlaybackRequiresUserGesture: false,
          pageZoom: 10,
        ),
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          print("challenge $challenge");
          return ServerTrustAuthResponse(
            action: ServerTrustAuthResponseAction.PROCEED,
          );
        },
        onLoadStart: (controller, url) {
          print("Page started loading: $url");
        },
        onLoadStop: (controller, url) async {
          print("Page finished loading: $url");
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
      ),
    );
  }
}