import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../getSIgnals/presentation/widgets/timeformatter.dart';

Container NotificationContainer(String title, String desc, DateTime date) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(8)),
    margin: EdgeInsets.only(bottom: 20),
    padding: EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(desc)
          ],
        ),
        Gap(20),
        Text(timeAgo(date))
      ],
    ),
  );
}
