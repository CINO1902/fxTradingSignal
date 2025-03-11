import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fx_trading_signal/features/getSIgnals/presentation/widgets/timeformatter.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/appColors.dart';
import '../../../getTraders/presentation/widgets/traderWidget.dart';
import '../../../getcopies/domain/usecases/addCopyState.dart';
import '../../../getcopies/presentation/provider/CopyTradeProvider.dart';

class SignalWidget extends ConsumerStatefulWidget {
  const SignalWidget({
    super.key,
    required this.entry,
    required this.pair,
    required this.signalId,
    required this.refo,
    required this.accesstype,
    required this.entries,
    required this.copyTraded,
    required this.order,
    required this.stoploss,
    required this.status,
    required this.createdDate,
    required this.takeprofit,
    required this.active,
  });

  final String status;
  final WidgetRef refo;
  final bool copyTraded;
  final bool active;
  final String signalId;
  final String pair;
  final String accesstype;
  final String entries; // comma-separated entries
  final String order;
  final String stoploss;
  final String takeprofit;
  final DateTime createdDate;
  final String entry;

  @override
  ConsumerState<SignalWidget> createState() => _SignalWidgetState();
}

class _SignalWidgetState extends ConsumerState<SignalWidget> {
  @override
  Widget build(BuildContext context) {
    // Parse entries to check for matching values.
    final List<String> entryValues =
        widget.entries.split(',').map((e) => e.trim()).toList();

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
          // Header Row.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 33,
                    width: 40,
                    color: widget.accesstype == 'Pro'
                        ? AppColors.kprimaryColor300
                        : AppColors.kwarningColor50,
                    child: Center(
                      child: Text(
                        widget.accesstype,
                        style: TextStyle(
                          color: widget.accesstype == 'Pro'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Gap(10),
                  Text(timeAgo(widget.createdDate))
                ],
              ),
              GestureDetector(
                onTap: () async {
                  if (ref.watch(copyTradeController).addCopyResult.state !=
                      AddCopyResultState.isLoading) {
                    await ref
                        .read(copyTradeController)
                        .addCopy(ref, widget.signalId);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 30,
                  width: 100,
                  child: widget.active
                      ? Align(
                          alignment: Alignment
                              .centerRight, // Ensure alignment applies correctly
                          child: SizedBox(
                            width: 33, // Takes full width of parent
                            child: ref
                                        .watch(addCopyProvider(widget.signalId))
                                        .state ==
                                    AddCopyResultState.isLoading
                                ? SvgPicture.asset(
                                    'assets/svg/star-favourite.svg',
                                    color: Colors.grey,
                                  )
                                : widget.copyTraded
                                    ? SvgPicture.asset(
                                        'assets/svg/star-favourite.svg',
                                        allowDrawingOutsideViewBox: true,
                                        color: Colors.amber,
                                      )
                                    : SvgPicture.asset(
                                        'assets/svg/favourite.svg',
                                        allowDrawingOutsideViewBox: true,
                                        color: Colors.grey,
                                      ),
                          ),
                        )
                      : Text(
                          widget.entries.contains(widget.stoploss) ||
                                  widget.entries.contains(widget.takeprofit)
                              ? 'Trade Completed'
                              : 'Signal Canceled',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 10),
                        ),
                ),
              )
            ],
          ),
          Gap(10),
          Text(
            '${widget.pair} ${widget.order == 'Buy' ? 'Long' : 'Short'} Position',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  widget.order == 'Buy'
                      ? SvgPicture.asset('assets/svg/bullishArrow.svg')
                      : SvgPicture.asset('assets/svg/bearishArrow.svg'),
                  Gap(15),
                  Text('Entry: ${widget.entry}'),
                ],
              ),
            ],
          ),
          Gap(10),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 32,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: entryValues.contains(widget.stoploss)
                        ? AppColors.kErrorColor400
                        : Color(0xffF6F6F6),
                  ),
                  child: Center(
                    child: Text(
                      'SL: ${widget.stoploss}',
                      style: TextStyle(
                          fontSize: 10,
                          color: entryValues.contains(widget.stoploss)
                              ? AppColors.kWhite
                              : Colors.black),
                    ),
                  ),
                ),
                Gap(20),
                // Pass the entries to DynamicTextRow.
                DynamicTextRow(
                  text: widget.takeprofit,
                  entries: widget.entries,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicTextRow extends StatelessWidget {
  final String text;
  final String entries;

  const DynamicTextRow({
    super.key,
    required this.text,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    // Split the take profit string into values.
    List<String> values = text.split(',').map((e) => e.trim()).toList();
    // Parse the entries.
    List<String> selectedEntries =
        entries.split(',').map((e) => e.trim()).toList();

    if (values.length > 1) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          values.length,
          (index) {
            // Color the container green if this TP value is in the entries.
            bool isSelected = selectedEntries.contains(values[index]);
            return Container(
              height: 32,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color:
                    isSelected ? AppColors.ksuccessColor500 : Color(0xffF6F6F6),
              ),
              margin: EdgeInsets.only(right: 10),
              child: Center(
                child: Text(
                  'TP ${index + 1}: ${values[index]}',
                  style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? AppColors.kWhite : Colors.black),
                ),
              ),
            );
          },
        ),
      );
    } else {
      bool isSelected = selectedEntries.contains(text.trim());
      return Container(
        height: 32,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isSelected ? AppColors.ksuccessColor500 : Color(0xffF6F6F6),
        ),
        child: Center(
          child: Text(
            'TP: $text',
            style: TextStyle(fontSize: 10),
          ),
        ),
      );
    }
  }
}
