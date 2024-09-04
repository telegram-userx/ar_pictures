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
  ObservableFuture<PhotoAlbumEntity?> albumFuture = ObservableFuture.value(null);

  @action
  reset() {
    albumFuture = ObservableFuture.value(null);
  }

  @action
  getAlbum(String id) async {
    if (albumFuture.status.isPending) return;

    try {
      albumFuture = ObservableFuture(_albumRepository.getAlbum(id));

      await albumFuture;
    } catch (error, stackTrace) {
      Logger.e(error, stackTrace);
    }
  }
}
