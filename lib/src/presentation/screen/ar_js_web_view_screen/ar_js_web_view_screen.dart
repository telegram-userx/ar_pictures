import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../common/services/services.dart';
import '../../../domain/entity/entity.dart';
import '../../../service_locator/sl.dart';

@RoutePage()
class ArJsWebViewScreen extends StatefulWidget {
  const ArJsWebViewScreen({
    super.key,
    required this.arImages,
  });

  final List<ArImageEntity> arImages;

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
        initialUrlRequest: URLRequest(
          url: WebUri.uri(Uri.parse('file:///android_asset/flutter_assets/assets/js/index.html')),
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          useOnDownloadStart: true,
          mediaPlaybackRequiresUserGesture: false,
          pageZoom: 10,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;

          // webViewController.addJavaScriptHandler(
          //   handlerName: 'requestAssetData',
          //   callback: (args) {
          //     // Create a list of assets from widget.arImages
          //     List<Map<String, String>> assets = widget.arImages.map((e) {
          //       return {
          //         'id': e.id ?? '',
          //         'mindFileUrl': e.mindFileUrl ?? '',
          //         'videoUrl': e.videoUrl ?? '',
          //       };
          //     }).toList();

          //     return assets;
          //   },
          // );
        },
        onLoadStop: (controller, url) async {
          print("Page finished loading: $url");

          // // Inject JavaScript to request data from Flutter
          // await controller.evaluateJavascript(source: """
          //   window.requestFlutterData();
          // """);
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
        // onLoadResourceWithCustomScheme: (controller, request) async {
        //   if (request.url.toString().contains('.mind') || request.url.toString().contains('.mp4')) {
        //     try {
        //       final file = await sl<FileSystemService>().getFile(
        //         request.url.toString(),
        //       );

        //       final response = CustomSchemeResponse(
        //         data: Uint8List.fromList(file),
        //         contentType: "image/jpeg",
        //         contentEncoding: "utf-8",
        //       );
        //       return response;
        //     } catch (error, stackTrace) {
        //       print("Error: $error, StackTrace: $stackTrace");
        //     }
        //   }

        //   return null;
        // },
      ),
    );
  }
}
