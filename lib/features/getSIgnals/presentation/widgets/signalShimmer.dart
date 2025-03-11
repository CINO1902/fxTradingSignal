
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../constant/shimmer.dart';

class SignalWidgetShimmer extends StatelessWidget {
  const SignalWidgetShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      height: 201,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ShimmerWidget.rectangle(width: 40, height: 33),
                  Gap(10),
                  ShimmerWidget.rectangle(width: 80, height: 14),
                ],
              ),
              ShimmerWidget.rectangle(width: 100, height: 30),
            ],
          ),
          Gap(10),
          ShimmerWidget.rectangle(width: 200, height: 14),
          Gap(10),
          Row(
            children: [
              ShimmerWidget.rectangle(width: 24, height: 24),
              Gap(15),
              ShimmerWidget.rectangle(width: 100, height: 14),
            ],
          ),
          Gap(10),
          SizedBox(
            width: width * 0.8,
            height: 40,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                ShimmerWidget.rectangle(width: 70, height: 32),
                Gap(20),
                ShimmerWidget.rectangle(width: 70, height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






