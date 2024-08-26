import 'dart:convert';
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
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          useOnDownloadStart: true,
          mediaPlaybackRequiresUserGesture: false,
          pageZoom: 10,
        ),
        onWebViewCreated: (controller) async {
          webViewController = controller;

          // Generate entities and assets
          List<String> assets = [];
          List<String> entities = [];

          for (var e in widget.arImages) {
            final videoFile = await sl<FileSystemService>().getFile(e.videoLocation!);
            final videoBase64 = base64Encode(videoFile);

            // If you still want to keep assets in <a-assets>
            assets.add('''
              <video id="${e.id ?? ''}" src="data:video/mp4;base64,$videoBase64"></video>
            ''');

            // Set the video source directly in the entity
            entities.add('''
      <a-entity mindar-image-target="targetIndex: ${widget.arImages.indexOf(e)}">
        <a-video webkit-playsinline playsinline width="1" height="1" position="0 0 0"
            autoplay="false" src="#${e.id ?? ''}">
        </a-video>
      </a-entity>
    ''');
          }

          // Create the full a-scene HTML with <a-assets>
          String sceneHtml = '''
    <a-scene
        mindar-image="imageTargetSrc: https://cdn.jsdelivr.net/gh/telegram-userx/ar_pictures@master/assets/js/multi_target.mind; filterMinCF: 10; filterBeta: 10000"
        color-space="sRGB" renderer="colorManagement: true, physicallyCorrectLights" vr-mode-ui="enabled: false"
        device-orientation-permission-ui="enabled: false">

        <a-assets id="aAssets">
          ${assets.join('\n')}
        </a-assets>

        <a-camera position="0 0 0" look-controls="enabled: false"></a-camera>

        ${entities.join('\n')}

    </a-scene>
  ''';

          // Load the HTML into the WebView
          webViewController.loadData(
            data: '''
      <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <script src="https://aframe.io/releases/1.5.0/aframe.min.js"></script>
            <script src="https://cdn.jsdelivr.net/gh/donmccurdy/aframe-extras@v7.0.0/dist/aframe-extras.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/mind-ar@1.2.5/dist/mindar-image-aframe.prod.js"></script>
        </head>
        <body>
            $sceneHtml
        </body>
      </html>
    ''',
            mimeType: 'text/html',
            encoding: 'utf-8',
            baseUrl: WebUri.uri(
              Uri.parse('file:///android_asset/flutter_assets/assets/js/index.html'),
            ),
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
      ),
    );
  }
}
