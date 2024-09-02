import 'dart:async';

import 'package:dio/dio.dart';
import 'package:directus/directus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../generated/strings.g.dart';
import '../../data/data_source/local/drift/app_database.dart';
import '../../data/data_source/local/drift/dao/ar_video_dao.dart';
import '../../data/data_source/local/drift/dao/photo_album_dao.dart';
import '../../data/data_source/local/shared_preferences/shared_preferences_helper.dart';
import '../../data/data_source/remote/directus_sdk/src/ar_video_sdk.dart';
import '../../data/data_source/remote/directus_sdk/src/photo_album_sdk.dart';
import '../../data/repository/repository.dart';
import '../../data/repository/src/local_photo_album_repository_impl.dart';
import '../../data/repository/src/remote_photo_album_repository_impl.dart';
import '../../domain/repository/repository.dart';
import '../../presentation/qr_scanner/store/qr_scanner_store.dart';
import '../config/router/app_router.dart';
import '../constant/app_constants.dart';
import '../logger/logger_observer.dart';
import '../services/download_file/download_file_service.dart';
import '../services/permissions_service/permissions_service.dart';
import '../utility/database_opener/database_opener.dart';

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
