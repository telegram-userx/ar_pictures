import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          useShouldOverrideUrlLoading: true,
          pageZoom: 10,
        ),
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
