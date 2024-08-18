import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'src/presentation/application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();

  runApp(const Application());
}
