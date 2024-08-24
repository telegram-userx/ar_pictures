import '../../entity/entity.dart';

/// A repository interface for managing photo albums.
abstract interface class PhotoAlbumRepository {
  /// Fetches a list of photo albums from local storage.
  ///
  /// This method retrieves all the photo albums that are stored locally on the device.
  ///
  /// Returns a [Future] containing a list of [PhotoAlbumEntity] objects.
  Future<List<PhotoAlbumEntity>> getAlbums();

  /// Fetches a specific photo album from a remote source by its ID.
  ///
  /// This method retrieves a single photo album from a remote server or API
  /// based on the provided [id]. It is useful for fetching detailed information
  /// about a specific album.
  ///
  /// [id] is the unique identifier of the photo album to be fetched.
  ///
  /// Returns a [Future] containing the [PhotoAlbumEntity] object corresponding
  /// to the specified [id].
  Future<PhotoAlbumEntity> getAlbum({required String id});

  /// Saves a photo album to local storage.
  ///
  /// This method persists the given [PhotoAlbumEntity] to local storage on the device.
  /// It can be used to store albums that have been downloaded or created locally.
  ///
  /// [photoAlbum] is the [PhotoAlbumEntity] object that needs to be saved.
  ///
  /// Returns a [Future] that completes when the album has been successfully saved.
  Future<void> saveAlbum({required PhotoAlbumEntity photoAlbum});

  /// Checks if a photo album is fully downloaded in local storage.
  ///
  /// This method verifies whether all the necessary data for the given [album] is
  /// available locally on the device. It can be used to determine if an album is
  /// ready for offline use.
  ///
  /// [album] is the [PhotoAlbumEntity] object to be checked.
  ///
  /// Returns a [Future] containing a boolean value indicating whether the album is
  /// fully downloaded (true) or not (false).
  Future<bool> isFullyDownloaded({required PhotoAlbumEntity album});
}
