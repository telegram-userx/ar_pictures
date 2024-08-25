import 'package:directus/directus.dart';

import '../directus_sdk.dart';

class ArImageSdk {
  final DirectusCore _directusSdk;

  ArImageSdk({
    required DirectusCore directusSdk,
  }) : _directusSdk = directusSdk;

  Future<List<ArImageDto>> getByPhotoAlbumId(String photoAlbumId) async {
    final response = await _directusSdk.items(ArImageDto.className).readMany(
          query: Query(
            limit: 999,
          ),
          filters: Filters(
            {
              'photoAlbumId': Filter.eq(photoAlbumId),
            },
          ),
        );

    final arImagesDto = response.data
        .map(
          (e) => ArImageDto.fromJson(e),
        )
        .toList();

    return arImagesDto;
  }
}
