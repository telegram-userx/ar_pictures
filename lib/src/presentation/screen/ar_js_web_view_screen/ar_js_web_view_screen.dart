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

          // Requesting assets for <a-assets>
          webViewController.addJavaScriptHandler(
            handlerName: 'requestAAssets',
            callback: (args) {
              List<String> assets = widget.arImages.map<String>(
                (e) {
                  return '''
                    <a-asset-item id="${e.id ?? ''}"
                      src="${e.videoUrl ?? ''}"></a-asset-item>
                  ''';
                },
              ).toList();

              return assets;
            },
          );

          // Requesting entities for <a-scene>
          webViewController.addJavaScriptHandler(
            handlerName: 'requestAEntities',
            callback: (args) {
              List<String> entities = widget.arImages.map<String>(
                (e) {
                  return '''
                    <a-entity mindar-image-target="targetIndex: 1">
                      <a-video src="#${e.id ?? ''}" webkit-playsinline playsinline width="1" height="0.552" position="0 0 0"
                          autoplay="false"></a-video>
                    </a-entity>
                  ''';
                },
              ).toList();

              return entities;
            },
          );
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
