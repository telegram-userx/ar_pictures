import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  PermissionsService() {
    _init();
  }

  _init() async {
    hasCameraPermission = await requestCameraPermission();
    hasStoragePermission = await requestStoragePermission();
  }

  bool hasCameraPermission = false;
  bool hasStoragePermission = false;

  Future<bool> requestCameraPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestStoragePermission() async {
    final PermissionStatus status = await Permission.storage.request();
    return status.isGranted;
  }
}
