import 'package:directus/directus.dart';

import '../directus_sdk.dart';

class PhotoAlbumSdk {
  final DirectusCore _directusSdk;

  PhotoAlbumSdk({
    required DirectusCore directusSdk,
  }) : _directusSdk = directusSdk;

  Future<PhotoAlbumDto> getById(String id) async {
    final response = await _directusSdk.items(PhotoAlbumDto.className).readOne(id);

    final photoAlbumDto = PhotoAlbumDto.fromJson(response.data);

    return photoAlbumDto;
  }

  Future<double> getFileSize(String fileId) async {
    final file = await _directusSdk.files.readOne(fileId);

    final fileSizeInBytes = int.tryParse(file.data.filesize.toString()) ?? 0;

    return bytesToMegabytes(fileSizeInBytes.toDouble());
  }

  double bytesToMegabytes(double bytes) {
    return bytes / (1024 * 1024);
  }
}
