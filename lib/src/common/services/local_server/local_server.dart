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
          List<String> scripts = [];

          for (final arVideo in arVideos) {
            // Ensure correct MIME type and format
            assets.add('''
              <video id="${arVideo.id}" loop="true" src="http://localhost:3333/videos/${arVideo.id}"></video>
            ''');

            entities.add('''
              <a-entity data-${arVideo.id} mindar-image-target="targetIndex: ${arVideos.indexOf(arVideo)}"></a-entity>
            ''');

            scripts.add('''
                AFRAME.registerComponent('data-${arVideo.id}', {
                  init: function () {
                    const videoElement = document.getElementById('${arVideo.id}');

                    this.el.addEventListener('targetFound', event => {
                      console.log("target found");
                      document.querySelector('[data-${arVideo.id}]').innerHTML = `<a-video src="#${arVideo.id}" width="1" height="${(arVideo.height == 0 ? 768 : arVideo.height) / 1000}"></a-video>`;
                      videoElement.play();
                    });

                    this.el.addEventListener('targetLost', event => {
                      console.log("target lost");
                      document.querySelector('[data-${arVideo.id}]').innerHTML = '';
                      videoElement.pause();
                    });
                  }
                });
            ''');
          }

          final aframe = await rootBundle.loadString('assets/js/aframe.min.js');

          final html = '''
            <html>
              <head>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <meta name="apple-mobile-web-app-capable" content="yes">
                <script>$aframe</script>
                <script src="http://localhost/libs/aframe-extras.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/mind-ar@1.2.5/dist/mindar-image-aframe.prod.js"></script>
              </head>
              <body>
                <a-scene stats
                  mindar-image="imageTargetSrc: http://localhost:3333/targets/$arMarkerId;
                  uiError:no; uiScanning:no;
                  filterMinCF: 0.0001; filterBeta: 0.001; 
                  missTolerance: 1; warmupTolerance: 1;"
                  color-space="sRGB" renderer="colorManagement: true, physicallyCorrectLights" 
                  vr-mode-ui="enabled: false" device-orientation-permission-ui="enabled: false">

                  <a-assets>
                    ${assets.join('\n')}
                  </a-assets>

                  <a-camera position="0 0 0" look-controls="enabled: false"></a-camera>
                  
                  ${entities.join('\n')}
                
                </a-scene>

                <script>${scripts.join('\n')}</script>
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

    app.get('/targets/<fileName>', (Request request, String fileName) async {
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
