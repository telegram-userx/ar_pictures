import 'package:get_it/get_it.dart';

import '../common/config/router/app_router.dart';

part 'src/data_layer.dart';
part 'src/domain_layer.dart';
part 'src/presentation_layer.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  await _initDataLayer();
  await _initDomainLayer();
  await _initPresentationLayer();
}
