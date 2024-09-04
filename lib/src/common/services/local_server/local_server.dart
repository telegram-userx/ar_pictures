import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import '../../../presentation/qr_scanner/store/qr_scanner_store.dart';
import '../../../service_locator/sl.dart';
import '../../logger/logger.dart';

// Function to add CORS headers
Middleware _addCorsHeaders() {
  return createMiddleware(
    responseHandler: (Response response) {
      return response.change(headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': '*', // Allow all origins
        'Access-Control-Allow-Methods': 'GET, OPTIONS', // Allow specific methods
        'Access-Control-Allow-Headers': 'Origin, Content-Type', // Allow specific headers
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
          // TODO
          // final arMarkerId = sl<QrScannerStore>().albumFuture.value?.id ?? '';
          final arVideos = sl<QrScannerStore>().albumFuture.value?.arVideos?.nonObservableInner ?? [];

          // Generate entities and assets
          List<String> assets = [];
          List<String> entities = [];

          for (final arVideo in arVideos) {
            // Ensure correct MIME type and format
            assets.add('''
              <video id="${arVideo.id}" autoplay="false" loop="true" src="http://localhost:8080/files/${arVideo.id}" crossorigin="anonymous"></video>
            ''');

            entities.add('''
              <a-entity mindar-image-target="targetIndex: ${arVideos.indexOf(arVideo)}">
                <a-video autoplay="false" webkit-playsinline playsinline width="1" height="1" 
                          position="0 0 0" src="#${arVideo.id}">
                </a-video>
              </a-entity>
            ''');
          }

          final html = '''
            <html>
              <head>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <script src="https://aframe.io/releases/1.5.0/aframe.min.js"></script>
                <script src="https://cdn.jsdelivr.net/gh/donmccurdy/aframe-extras@v7.0.0/dist/aframe-extras.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/mind-ar@1.2.5/dist/mindar-image-aframe.prod.js"></script>
              </head>
              <body>
                <a-scene mindar-image="imageTargetSrc: https://cdn.jsdelivr.net/gh/telegram-userx/ar_pictures@master/assets/js/targets.mind;
                uiError:no; uiScanning:no;
                filterMinCF: 0.1; filterBeta: 100" 
                color-space="sRGB" renderer="colorManagement: true, physicallyCorrectLights" 
                vr-mode-ui="enabled: false" device-orientation-permission-ui="enabled: false">
                  
                  <a-assets>
                    ${assets.join('\n')}
                  </a-assets>

                  <a-camera position="0 0 0" look-controls="enabled: false"></a-camera>
                  
                  ${entities.join('\n')}

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

    // Define a route to serve video files
    app.get('/files/<fileName>', (Request request, String fileName) async {
      try {
        final appCacheDirectory = await getApplicationDocumentsDirectory();
        final file = await File('${appCacheDirectory.path}/$fileName').readAsBytes();
        Logger.i('App cache directory: ${appCacheDirectory.path}');

        return Response.ok(
          file,
          headers: {
            'Content-Type': 'application/octet-stream',
          },
        );
      } catch (e) {
        return Response.notFound('File not found');
      }
    });

    httpServer = await io.serve(handler, 'localhost', 8080);
    Logger.i('Local server running at http://${httpServer.address.host}:${httpServer.port}');
  }
}
