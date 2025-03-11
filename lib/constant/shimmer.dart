import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shimmer/shimmer.dart';

import '../core/utils/appColors.dart';

enum Shape { rectangle, circle }

class ShimmerWidget extends ConsumerWidget {
  final double height, width, radius;
  final Shape shape;

  const ShimmerWidget.rectangle({
    Key? key,
    required this.width,
    required this.height,
  })  : shape = Shape.rectangle,
        radius = 0,
        super(key: key);

  const ShimmerWidget.circle({
    Key? key,
    required this.radius,
  })  : shape = Shape.circle,
        height = 0,
        width = 0,
        super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(.3),
      highlightColor: AppColors.kWhite,
      child: shape == Shape.rectangle
          ? Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          : CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey,
            ),
    );
  }
}
