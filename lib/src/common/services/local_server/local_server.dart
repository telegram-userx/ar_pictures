import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import '../../../presentation/qr_scanner/store/qr_scanner_store.dart';
import '../../../service_locator/sl.dart';
import '../../logger/logger.dart';

Middleware _addCorsHeaders() {
  return createMiddleware(
    responseHandler: (Response response) {
      return response.change(headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type',
      });
    },
  );
}

class LocalServer {
  final Router app;
  late final HttpServer httpServer;

  LocalServer() : app = Router() {
    _init();
  }

  _init() async {
    // CORS Headers Middleware
    var handler = const Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(_addCorsHeaders()) // Add the CORS middleware here
        .addHandler(app.call);

    app.get(
      '/albums/<id>',
      (Request request, String id) async {
        try {
          final arMarkerId = sl<QrScannerStore>().album?.id ?? '';
          final arVideos = sl<QrScannerStore>().album?.arVideos?.nonObservableInner ?? [];

          // Generate entities and assets
          List<String> assets = [];
          List<String> entities = [];

          for (final arVideo in arVideos) {
            // Ensure correct MIME type and format
            assets.add('''
              <video id="${arVideo.id}" autoplay="false" loop="true" preload="none" src="http://localhost:3333/videos/${arVideo.id}"></video>
            ''');

            entities.add('''
              <a-entity mindar-image-target="targetIndex: ${arVideos.indexOf(arVideo)}">
                <a-video autoplay="false" webkit-playsinline playsinline width="1" height="1" preload="none"
                          position="0 0 0" src="#${arVideo.id}">
                </a-video>
              </a-entity>
            ''');
          }

          final aframe = await rootBundle.loadString('assets/js/aframe.min.js');
          final aframeAr = await rootBundle.loadString('assets/js/aframe-ar-nft.js');

          const eventListeners = '''
            window.onload = function () {
              AFRAME.registerComponent('videohandler', {
                init: function () {
                    var marker = this.el;

                    this.vid = document.querySelector("#vid");

                    marker.addEventListener('markerFound', function () {
                      this.vid.play();
                    }.bind(this));

                    marker.addEventListener('markerLost', function () {
                      this.vid.pause();
                      this.vid.currentTime = 0;
                    }.bind(this));
                }
              });
          };
          ''';

          final html = '''
            <html>
              <head>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <meta name="apple-mobile-web-app-capable" content="yes">
                <script>$aframe</script>
                <script>$aframeAr</script>

                <script>$eventListeners</script>

                <!-- style for the loader -->
                <style>
                  .arjs-loader {
                    height: 100%;
                    width: 100%;
                    position: absolute;
                    top: 0;
                    left: 0;
                    background-color: rgba(0, 0, 0, 0.8);
                    z-index: 9999;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                  }

                  .arjs-loader div {
                    text-align: center;
                    font-size: 1.25em;
                    color: white;
                  }
                </style>
              </head>
              
              <body style="margin : 0px; overflow: hidden;">
                <!-- minimal loader shown until image descriptors are loaded. Loading may take a while according to the device computational power -->
                <div class="arjs-loader">
                  <div>Loading, please wait...</div>
                </div>

                <!-- a-frame scene -->
                <a-scene
                  stats
                  vr-mode-ui="enabled: false;"
                  renderer="logarithmicDepthBuffer: true;"
                  embedded
                  arjs="trackingMethod: best; sourceType: webcam;debugUIEnabled: false;"
                >
                  $assets
                  <!-- a-nft is the anchor that defines an Image Tracking entity -->
                  <!-- on 'url' use the path to the Image Descriptors created before. -->
                  <!-- the path should end with the name without the extension e.g. if file is 'pinball.fset' the path should end with 'pinball' -->
                  <a-nft
                    type="nft"
                    url="http://localhost:3333/targets/4"
                    smooth="true"
                    smoothCount="10"
                    smoothTolerance=".01"
                    smoothThreshold="5"
                  >
                    <!-- as a child of the a-nft entity, you can define the content to show. here's a GLTF model entity -->
                    <a-entity mindar-image-target="targetIndex: 0">
                      <a-video autoplay="false" webkit-playsinline playsinline width="1" height="1" preload="none"
                                position="0 0 0" src="#20fb751f-a6e5-4877-ab01-33b304bf4a36">
                      </a-video>
                    </a-entity>
                  </a-nft>
                  <!-- static camera that moves according to the device movemenents -->
                  <a-entity camera></a-entity>
                </a-scene>
              </body>
            </html>
          ''';

          return Response.ok(
            html,
            headers: {
              'Content-Type': 'text/html',
            },
          );
        } catch (e) {
          Logger.e(e);

          return '<h1>Hello<h1>';
        }
      },
    );

    app.get('/videos/<fileName>', (Request request, String fileName) async {
      try {
        final appCacheDirectory = await getApplicationDocumentsDirectory();
        final file = await File('${appCacheDirectory.path}/$fileName').readAsBytes();
        Logger.i('App cache directory: ${appCacheDirectory.path}');

        return Response.ok(
          file,
          headers: {'Content-Type': 'application/octet-stream'},
        );
      } catch (e) {
        Logger.e(e);
        return Response.notFound('File not found');
      }
    });

    app.get('/targets/<fileName>.iset', (Request request, String fileName) async {
      try {
        final asset = await rootBundle.loadString('assets/js/$fileName.iset');

        return Response.ok(
          asset,
          headers: {'Content-Type': 'application/octet-stream'},
        );
      } catch (e) {
        Logger.e(e);
        return Response.notFound('File not found');
      }
    });

    app.get('/targets/<fileName>.fset3', (Request request, String fileName) async {
      try {
        final asset = await rootBundle.loadString('assets/js/$fileName.fset3');

        return Response.ok(
          asset,
          headers: {'Content-Type': 'application/octet-stream'},
        );
      } catch (e) {
        Logger.e(e);
        return Response.notFound('File not found');
      }
    });

    app.get('/targets/<fileName>.fset', (Request request, String fileName) async {
      try {
        final asset = await rootBundle.loadString('assets/js/$fileName.fset');

        return Response.ok(
          asset,
          headers: {'Content-Type': 'application/octet-stream'},
        );
      } catch (e) {
        Logger.e(e);
        return Response.notFound('File not found');
      }
    });

    app.get('/libs/<assetName>', (Request request, String assetName) async {
      try {
        final asset = await rootBundle.loadString('assets/js/$assetName');

        return Response.ok(
          asset,
          headers: {'Content-Type': 'text/javascript'},
        );
      } catch (e) {
        Logger.e(e);
        return Response.notFound('File not found');
      }
    });

    httpServer = await io.serve(handler, 'localhost', 3333);
    Logger.i('Local server running at http://${httpServer.address.host}:${httpServer.port}');
  }
}
