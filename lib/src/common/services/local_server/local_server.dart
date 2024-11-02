import 'dart:convert';
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
      '/ar_pictures',
      (Request request, String id) async {
        try {
          final arVideos = sl<QrScannerStore>().album?.arVideos?.nonObservableInner ?? [];

          final pictures = arVideos
              .map(
                (video) => {
                  "id": video.id,
                  "image": video.localPictureUrl,
                  "video": video.localVideoUrl,
                },
              )
              .toList();

          return Response.ok(
            jsonEncode(pictures),
            headers: {
              'Content-Type': 'application/json',
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

    app.get('/images/<fileName>', (Request request, String fileName) async {
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

    httpServer = await io.serve(handler, 'localhost', 5441);
    Logger.i('Local server running at http://${httpServer.address.host}:${httpServer.port}');
  }
}
