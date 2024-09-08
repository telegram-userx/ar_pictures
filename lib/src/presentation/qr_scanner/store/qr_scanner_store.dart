import 'package:mobx/mobx.dart';

import '../../../common/extension/src/future_status.dart';
import '../../../common/logger/logger.dart';
import '../../../domain/entity/entity.dart';
import '../../../domain/repository/repository.dart';

part '../../../../generated/src/presentation/qr_scanner/store/qr_scanner_store.g.dart';

class QrScannerStore = _QrScannerStoreBase with _$QrScannerStore;

abstract class _QrScannerStoreBase with Store {
  final PhotoAlbumRepository _albumRepository;

  _QrScannerStoreBase({
    required PhotoAlbumRepository albumRepository,
  }) : _albumRepository = albumRepository;

  @observable
  @readonly
  PhotoAlbumEntity? album;

  @observable
  @readonly
  FutureStatus albumStatus = FutureStatus.fulfilled;

  @action
  reset() {
    album = null;
  }

  @action
  getAlbum(String id) async {
    if (albumStatus.isPending) return;
    albumStatus = FutureStatus.pending;

    try {
      album = await _albumRepository.getAlbum(id);
      albumStatus = FutureStatus.fulfilled;
    } catch (error, stackTrace) {
      Logger.e(error, stackTrace);
      albumStatus = FutureStatus.rejected;
    }
  }
}
