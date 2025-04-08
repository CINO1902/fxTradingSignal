import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color color;
  final bool isSender;
  final bool isRead;
  final bool isSent;
  final String timestamp;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.color,
    required this.isRead,
    required this.isSent,
    required this.isSender,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        constraints: const BoxConstraints(
          maxWidth: 200,
          minWidth: 70,
          maxHeight: 500,
          minHeight: 50,
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                  fontSize: 12, color: isSender ? Colors.black : Colors.white),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formattedTime(timestamp),
                  style: TextStyle(
                      fontSize: 10,
                      color: isSender ? Colors.black : Colors.white),
                ),
                Gap(3),
                isSender
                    ? isSent
                        ? SvgPicture.asset('assets/svg/double-tick.svg',
                            height: 18,
                            width: 18,
                            color: isRead ? Colors.blue : Colors.black)
                        : SizedBox(
                            height: 15,
                            width: 15,
                            child: SvgPicture.asset('assets/svg/pending.svg',
                                fit: BoxFit.scaleDown,
                                color: isRead ? Colors.blue : Colors.black),
                          )
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String formattedTime(isoString) {
  DateTime dateTime = DateTime.parse(isoString).toUtc();
  return DateFormat('hh:mm a').format(dateTime);
}
