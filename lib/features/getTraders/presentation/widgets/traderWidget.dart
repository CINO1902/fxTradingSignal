import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fx_trading_signal/core/utils/appColors.dart';
import 'package:fx_trading_signal/features/getTraders/domain/entities/getPricesPerModel.dart';
import 'package:fx_trading_signal/features/getcopies/domain/entities/addCopyResponse.dart';
import 'package:fx_trading_signal/features/getcopies/domain/usecases/addCopyState.dart';
import 'package:fx_trading_signal/features/getcopies/presentation/provider/CopyTradeProvider.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecases/dateFormater.dart';
import '../../domain/usecases/pnlCalculator.dart';
import '../../domain/usecases/pricesResult.dart';
import '../provider/homeProvider.dart';

final getpriceProvider =
    StateProvider.family<PricesList, String>((ref, id) => PricesList());
final addCopyProvider = StateProvider.family<AddCopyResult, String>(
    (ref, id) => AddCopyResult(AddCopyResultState.idle, AddCopyResponse()));

class traderBoard extends ConsumerStatefulWidget {
  const traderBoard(
      {super.key,
      required this.entry,
      required this.pair,
      required this.signalId,
      required this.refo,
      required this.entries,
      required this.active,
      required this.index,
      required this.accesstype,
      required this.order,
      required this.stoploss,
      required this.status,
      required this.copyTraded,
      required this.createdDate,
      required this.takeprofit});

  final String status;
  final WidgetRef refo;
  final String signalId;
  final int index;
  final bool active;
  final String pair;
  final String entries;
  final String accesstype;
  final String order;
  final String stoploss;
  final String takeprofit;
  final DateTime createdDate;
  final String entry;
  final bool copyTraded;

  @override
  ConsumerState<traderBoard> createState() => _traderBoardState();
}

class _traderBoardState extends ConsumerState<traderBoard>
    with AutomaticKeepAliveClientMixin {
  // List<dynamic> priceUpdates = [];

  @override
  bool get wantKeepAlive =>
      true; // Keep this widget alive even when it's offscreen

  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    // Run after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        ref.read(getTraderController).getprice(widget.pair, widget.refo);
        print(widget.pair);
        _hasInitialized = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        context.push('/signalDetails', extra: {
          "status": widget.status,
          "refo": widget.refo,
          "signalId": widget.signalId,
          "pair": widget.pair,
          "index": widget.index,
          "entries": widget.entries,
          "active": widget.active,
          "copyTraded": widget.copyTraded,
          "accesstype": widget.accesstype,
          "order": widget.order,
          "stoploss": widget.stoploss,
          "takeprofit": widget.takeprofit,
          "createdDate": widget.createdDate,
          "entry": widget.entry,
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        // height: 201,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            : Colors.black),
                  )),
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
                    width: widget.active ? 33 : 100,
                    child: widget.active
                        ? ref.watch(addCopyProvider(widget.signalId)).state ==
                                AddCopyResultState.isLoading
                            ? SvgPicture.asset('assets/svg/star-favourite.svg',
                                color: Colors.grey)
                            : widget.copyTraded
                                ? SvgPicture.asset(
                                    'assets/svg/star-favourite.svg',
                                    allowDrawingOutsideViewBox: true,
                                    color: Colors.amber)
                                : SvgPicture.asset('assets/svg/favourite.svg',
                                    allowDrawingOutsideViewBox: true,
                                    color: Colors.grey)
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pair,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      formatDateTime(widget.createdDate),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Gap(5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order',
                      style: TextStyle(
                          color: Color(0xff737789),
                          fontSize: 10,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      widget.order,
                      style: TextStyle(
                          fontSize: 14,
                          color:
                              widget.order == 'Buy' ? Colors.blue : Colors.red,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ],
            ),
            Gap(10),
            ref.watch(getTraderController).getPricesResult.state ==
                    GetPricesResultState.isData
                ? ref.watch(getpriceProvider(widget.pair)).price != null
                    ? Row(
                        children: [
                          Text(
                            calculatePNL(
                              tradeType: widget.order.toUpperCase(),
                              currencyPair: widget.pair,
                              entryPrice: double.parse(widget.entry),
                              currentPrice: double.parse(ref
                                      .watch(getpriceProvider(widget.pair))
                                      .price ??
                                  '0.0'),
                            ).toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: calculatePNL(
                                  tradeType: widget.order.toUpperCase(),
                                  currencyPair: widget.pair,
                                  entryPrice: double.parse(widget.entry),
                                  currentPrice: double.parse(ref
                                          .watch(getpriceProvider(widget.pair))
                                          .price ??
                                      '0.0'),
                                ).toString().contains('-')
                                    ? AppColors.kErrorColor300
                                    : AppColors.ksuccessColor400),
                          ),
                          Gap(10),
                          Text(
                            '(PNL)',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColors.kBlack),
                          )
                        ],
                      )
                    : SizedBox()
                : SizedBox(),
            Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ENTRY',
                      style: TextStyle(color: Color(0xff737789), fontSize: 10),
                    ),
                    Gap(5),
                    Text(
                      widget.entry,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STOP',
                      style: TextStyle(color: Color(0xff737789), fontSize: 10),
                    ),
                    Gap(5),
                    Text(
                      widget.stoploss,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TARGET',
                      style: TextStyle(color: Color(0xff737789), fontSize: 10),
                    ),
                    Gap(5),
                    DynamicTextColumn(
                      text: widget.takeprofit,
                    )
                  ],
                )
              ],
            )
          ],
        ),
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        : Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          );
  }
}
