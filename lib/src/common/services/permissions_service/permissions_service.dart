import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  PermissionsService() {
    _init();
  }

  _init() async {
    hasCameraPermission = Observable(await requestCameraPermission());
  }

  Observable<bool> hasCameraPermission = Observable(false);

  Future<bool> requestCameraPermission() async {
    final PermissionStatus status = await Permission.camera.request();

    return status.isGranted;
  }
}
