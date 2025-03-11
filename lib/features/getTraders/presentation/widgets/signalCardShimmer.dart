import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../constant/shimmer.dart';

class SignalShimmerCard extends StatelessWidget {
  const SignalShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: ShimmerWidget.rectangle(
        height: 10,
        width: 80,
      ),
    );
  }
}



class TraderBoardShimmer extends StatelessWidget {
  const TraderBoardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Access Type and Favourite Icon Shimmers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget.rectangle(width: 40, height: 33),
              ShimmerWidget.rectangle(width: 33, height: 30),
            ],
          ),
          const Gap(10),
          // Pair and Date, and Order Shimmers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget.rectangle(width: width * 0.5, height: 14),
                  const Gap(5),
                  ShimmerWidget.rectangle(width: width * 0.3, height: 14),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget.rectangle(width: 40, height: 10),
                  const Gap(5),
                  ShimmerWidget.rectangle(width: 40, height: 14),
                ],
              ),
            ],
          ),
          const Gap(10),
          // PNL Row Shimmer
          ShimmerWidget.rectangle(width: width * 0.4, height: 20),
          const Gap(10),
          // Entry, Stop, Target Row Shimmers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget.rectangle(width: width * 0.25, height: 14),
              ShimmerWidget.rectangle(width: width * 0.25, height: 14),
              ShimmerWidget.rectangle(width: width * 0.25, height: 14),
            ],
          ),
        ],
      ),
    );
  }
}

class DynamicTextColumn extends StatelessWidget {
  final String text;

  const DynamicTextColumn({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<String> values = text.split(',').map((e) => e.trim()).toList();
    return values.length > 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              values.length,
              (index) => Text(
                'TP ${index + 1}: ${values[index]}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        : Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
  }
}