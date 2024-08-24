import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constant/app_constants.dart';
import 'shimmer_container.dart';

class CachedImage extends StatelessWidget {
  final String? imageUrl;

  final double borderRadius;

  final double? width;
  final double? height;

  final BoxFit fit;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.borderRadius = AppConstants.borderRadius,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || (imageUrl?.isEmpty ?? false)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: CachedNetworkImage(
          imageUrl: imageUrl!.replaceAll('192.168.10.234:1337', '95.85.112.134:1338'),
          fit: fit,
          httpHeaders: const {
            'Connection': 'Keep-Alive',
          },
          memCacheWidth: 1024,
          progressIndicatorBuilder: (context, url, progress) {
            return ShimmerContainer(
              height: height ?? double.infinity,
              width: width ?? double.infinity,
            );
          },
          errorWidget: (context, url, error) {
            return SizedBox(
              width: width ?? double.infinity,
              height: height ?? double.infinity,
              child: const Card(
                margin: EdgeInsets.zero,
                elevation: 4,
              ),
            );
          },
        ),
      ),
    );
  }
}
