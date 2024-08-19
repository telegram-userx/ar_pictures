import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'src/presentation/screen/application.dart';
import 'src/service_locator/sl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();

  await initServiceLocator();

  runApp(const Application());
}
