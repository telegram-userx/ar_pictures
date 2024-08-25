import 'package:directus/directus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../common/config/router/app_router.dart';
import '../common/services/services.dart';
import '../common/utility/database_opener/database_opener.dart';
import '../data/data_source/directus_sdk/directus_sdk.dart';
import '../data/data_source/drift/drift.dart';
import '../data/data_source/shared_preferences/shared_preferences_helper.dart';
import '../data/repository/repository.dart';
import '../domain/repository/repository.dart';
import '../presentation/screen/photo_album/store/photo_album_store.dart';

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
