
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import '../../common/config/router/app_router.dart';
import '../../common/config/router/app_routes.dart';


import '../../service_locator/sl.dart';


class ArJsWebViewScreen extends StatefulWidget {
  const ArJsWebViewScreen({
    super.key,
    required this.albumId,
  });

  final String albumId;

  @override
  State<ArJsWebViewScreen> createState() => _ArJsWebViewScreenState();
}

class _ArJsWebViewScreenState extends State<ArJsWebViewScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            
            sl<AppRouter>().router.replace(
              AppRoutes.qrScanner,
            );
          },
          icon: const Icon(
            CupertinoIcons.chevron_left,
          ),
        ),
      ),
      body: const Stack(
          children: [
            EmbedUnity(),
          ],
        ),
    );
  }
}
