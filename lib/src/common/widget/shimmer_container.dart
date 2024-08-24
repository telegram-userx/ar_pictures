import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/extension/extensions.dart';
import '../constant/app_constants.dart';

class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final BoxShape shape;
  final Color? backgroundColor;

  const ShimmerContainer({
    super.key,
    this.width = double.infinity,
    this.height = 80,
    this.shape = BoxShape.rectangle,
    this.borderRadius = AppConstants.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.theme.cardColor,
      highlightColor: context.theme.cardColor.withOpacity(0.1),
      period: const Duration(milliseconds: 1000),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? context.theme.cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: const SizedBox.shrink(),
      ),
    );
  }
}
