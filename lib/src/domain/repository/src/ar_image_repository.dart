import '../../entity/entity.dart';

/// A repository interface for managing AR images associated with photo albums.
abstract interface class ArImageRepository {
  /// Fetches a list of AR images associated with a specific photo album from a remote source.
  ///
  /// This method retrieves all the AR images linked to the specified [photoAlbumId]
  /// from a remote server or API. It is used to get the AR data associated with
  /// a particular photo album.
  ///
  /// [photoAlbumId] is the unique identifier of the photo album whose AR images
  /// are to be fetched.
  ///
  /// Returns a [Future] containing a list of [ArImageEntity] objects.
  Future<List<ArImageEntity>> getArImages({required String photoAlbumId});

  /// Fetches a list of AR images associated with a specific photo album from a local source.
  ///
  /// This method retrieves all the AR images linked to the specified [photoAlbumId]
  /// from a local database or file storage. It is used to get the AR data associated with
  /// a particular photo album that is stored locally.
  ///
  /// [photoAlbumId] is the unique identifier of the photo album whose AR images
  /// are to be fetched.
  ///
  /// Returns a [Future] containing a list of [ArImageEntity] objects.
  Future<List<ArImageEntity>> getArImagesFromLocal();

  /// Downloads the video associated with the specified AR image from a remote source.
  ///
  /// This method downloads the video file linked to the provided [ArImageEntity]
  /// from a remote server or API and stores it in local storage. The returned
  /// [ArImageEntity] will have `isVideoDownloaded` set to `true` and `videoLocation`
  /// updated to point to the local storage location of the downloaded video.
  ///
  /// [image] is the [ArImageEntity] object whose video is to be downloaded.
  ///
  /// Returns a [Future] containing a new [ArImageEntity] with updated download status
  /// and local storage path.
  Future<ArImageEntity> downloadVideo({required ArImageEntity image});

  /// Downloads the video associated with the specified AR image from a remote source.
  ///
  /// This method downloads the video file linked to the provided [ArImageEntity]
  /// from a remote server or API and stores it in local storage. The returned
  /// [ArImageEntity] will have `isVideoDownloaded` set to `true` and `videoLocation`
  /// updated to point to the local storage location of the downloaded video.
  ///
  /// [image] is the [ArImageEntity] object whose video is to be downloaded.
  ///
  /// Returns a [Future] containing a new [ArImageEntity] with updated download status
  /// and local storage path.
  Stream<ArImageEntity> downloadVideos({required List<ArImageEntity> images});
}
