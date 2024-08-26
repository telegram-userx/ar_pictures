import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import '../../../presentation/screen/photo_album/store/ar_image_store.dart';
import '../../../service_locator/sl.dart';
import '../../logger/logger.dart';
import '../services.dart';

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
  final FileSystemService _fileSystemService;
  late final HttpServer httpServer;

  LocalServer({
    required FileSystemService fileSystemService,
  })  : _fileSystemService = fileSystemService,
        app = Router() {
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
          final arImages = sl<ArImageStore>().arImages[id] ?? [];

          // Generate entities and assets
          List<String> assets = [];
          List<String> entities = [];

          for (final e in arImages) {
            // Ensure correct MIME type and format
            assets.add('''
              <video id="${e.id ?? ''}" autoplay="false" loop="true" src="http://localhost:8080/videos/${e.videoLocation}"></video>
            ''');

            entities.add('''
              <a-entity mindar-image-target="targetIndex: ${arImages.indexOf(e)}">
                <a-video autoplay="false" webkit-playsinline playsinline width="1" height="1" 
                          position="0 0 0" src="#${e.id ?? ''}">
                </a-video>
              </a-entity>
            ''');
          }

          final html = '''
            <html>
              <head>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <script src="https://aframe.io/releases/1.5.0/aframe.min.js"></script>
                <script src="http://localhost:8080/assets/js/aframe-extras.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/mind-ar@1.2.5/dist/mindar-image-aframe.prod.js"></script>
              </head>
              <body>
                <a-scene mindar-image="imageTargetSrc: https://cdn.jsdelivr.net/gh/telegram-userx/ar_pictures@master/assets/js/targets.mind; 
                filterMinCF: 10; filterBeta: 10000" 
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

    // Define a route to serve assets
    app.get('/assets/js/<fileName>', (Request request, String fileName) async {
      try {
        final assetPath = 'assets/js/$fileName'; // Construct asset path
        final assetData = await rootBundle.load(assetPath); // Load asset from bundle
        final mimeType = _getMimeType(assetPath); // Get MIME type based on file extension
        return Response.ok(
          assetData.buffer.asUint8List(), // Convert ByteData to Uint8List
          headers: {
            'Content-Type': mimeType,
          },
        );
      } catch (e) {
        Logger.e(e);

        return Response.notFound('Asset not found: $fileName');
      }
    });

    // Define a route to serve video files
    app.get('/videos/<fileName>', (Request request, String fileName) async {
      try {
        final file = await _fileSystemService.getFile(fileName);

        return Response.ok(
          file,
          headers: {
            'Content-Type': 'video/mp4', // Ensure the correct content type is set
          },
        );
      } catch (e) {
        return Response.notFound('File not found');
      }
    });

    httpServer = await io.serve(handler, 'localhost', 8080);
    print('Local server running at http://${httpServer.address.host}:${httpServer.port}');
  }

  // Helper method to determine MIME type based on file extension
  String _getMimeType(String path) {
    if (path.endsWith('.js')) return 'application/javascript';
    if (path.endsWith('.html')) return 'text/html';
    if (path.endsWith('.css')) return 'text/css';
    if (path.endsWith('.mp4')) return 'video/mp4';
    if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return 'image/jpeg';
    if (path.endsWith('.png')) return 'image/png';
    return 'application/octet-stream'; // Default for unknown types
  }
}
