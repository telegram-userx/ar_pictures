import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../permissions_service/permissions_service.dart';

class FileSystemService {
  final PermissionsService permissionsService;

  FileSystemService(this.permissionsService);

  /// Saves a file to the filesystem.
  ///
  /// [fileName] is the name of the file to be saved.
  /// [bytes] is the content of the file as a list of bytes.
  ///
  /// Returns the file path where the file is saved.
  Future<String> saveFile(String fileName, List<int> bytes) async {
    if (await permissionsService.requestStoragePermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return filePath;
    } else {
      throw Exception('Storage permission denied');
    }
  }

  /// Reads a file from the filesystem.
  ///
  /// [fileName] is the name of the file to be read.
  ///
  /// Returns the content of the file as a list of bytes.
  Future<List<int>> getFile(String fileName) async {
    if (await permissionsService.requestStoragePermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      } else {
        throw Exception('File not found');
      }
    } else {
      throw Exception('Storage permission denied');
    }
  }
}
