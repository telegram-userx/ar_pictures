import 'dart:async';

import 'package:directus/directus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../generated/strings.g.dart';
import '../../data/data_source/local/shared_preferences/shared_preferences_helper.dart';
import '../config/router/app_router.dart';
import '../constant/app_constants.dart';
import '../services/permissions_service/permissions_service.dart';

part 'src/common.dart';
part 'src/data_layer.dart';
part 'src/domain_layer.dart';
part 'src/presentation_layer.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  await _initCommon();
  await _initDataLayer();
  await _initDomainLayer();
  await _initPresentationLayer();
}
