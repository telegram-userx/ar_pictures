import 'package:directus/directus.dart';

import '../../dto/src/ar_video_dto.dart';

class ArVideoSdk {
  final DirectusCore _directusSdk;

  ArVideoSdk({
    required DirectusCore directusSdk,
  }) : _directusSdk = directusSdk;

  Future<List<ArVideoDto>> getByAlbumId(String photoAlbumId) async {
    final response = await _directusSdk.items(ArVideoDto.className).readMany(
          query: Query(
            limit: 999,
          ),
          filters: Filters(
            {
              ArVideoDto.kPhotoAlbum: Filter.eq(photoAlbumId),
            },
          ),
        );

    final arVideos = response.data
        .map(
          (e) => ArVideoDto.fromJson(e),
        )
        .toList();

    return arVideos;
  }
}
