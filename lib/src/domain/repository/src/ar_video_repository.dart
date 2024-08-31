import '../../entity/entity.dart';

abstract interface class ArVideoRepository {
  Future<List<ArVideoEntity>> getVideos(String albumId);
}
