import 'package:dio/dio.dart';

class DownloadFileService {
  final Dio _dio;

  DownloadFileService({
    required Dio dio,
  }) : _dio = dio;

  Future<void> downloadFile(String urlPath, String savePath, {void Function(int, int)? onReceiveProgress}) async {
    await _dio.download(
      urlPath,
      savePath,
      onReceiveProgress: (received, total) {
        // int percentage = ((received / total) * 100).floor();

        if (onReceiveProgress != null) {
          onReceiveProgress(received, total);
        }
      },
    );
  }
}
