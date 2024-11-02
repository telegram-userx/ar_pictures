import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';

import '../../common/config/router/app_router.gr.dart';

@RoutePage()
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
            context.replaceRoute(
              const QrScannerRoute(),
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
