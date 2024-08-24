import 'package:directus/directus.dart';

import '../directus_sdk.dart';

class PhotoAlbumSdk {
  final DirectusCore _directusSdk;

  PhotoAlbumSdk({
    required DirectusCore directusSdk,
  }) : _directusSdk = directusSdk;

  Future<PhotoAlbumDto> getById(String id) async {
    final response = await _directusSdk.items(PhotoAlbumDto.className).readOne(
          id,
          query: OneQuery(
            fields: [
              '*',
              '$kVarTranslations.*',
            ],
          ),
        );

    final photoAlbumDto = PhotoAlbumDto.fromJson(response.data);

    return photoAlbumDto;
  }
}
