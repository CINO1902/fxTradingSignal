import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fx_trading_signal/constant/snackBar.dart';
import 'package:fx_trading_signal/features/getSIgnals/presentation/widgets/timeformatter.dart';
import 'package:fx_trading_signal/features/getTraders/domain/entities/getcommentModel.dart';
import 'package:fx_trading_signal/features/getTraders/domain/usecases/pricesResult.dart';
import 'package:fx_trading_signal/features/getTraders/presentation/pages/home.dart';
import 'package:gap/gap.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../../../core/utils/appColors.dart';
import '../../../getcopies/domain/usecases/addCopyState.dart';
import '../../../getcopies/presentation/provider/CopyTradeProvider.dart';
import '../../domain/usecases/dateFormater.dart';
import '../../domain/usecases/pnlCalculator.dart';
import '../provider/homeProvider.dart';
import '../widgets/traderWidget.dart';

class Signaldetails extends ConsumerStatefulWidget {
  const Signaldetails(
      {super.key,
      required this.entry,
      required this.signalId,
      required this.index,
      required this.pair,
      required this.refo,
      required this.entries,
      required this.active,
      required this.accesstype,
      required this.order,
      required this.copyTraded,
      required this.stoploss,
      required this.status,
      required this.createdDate,
      required this.takeprofit});

  final String status;
  final WidgetRef refo;
  final int index;
  final String entries;
  final String pair;
  final String signalId;
  final bool active;
  final String accesstype;
  final String order;
  final bool copyTraded;
  final String stoploss;
  final String takeprofit;
  final DateTime createdDate;
  final String entry;
  @override
  ConsumerState<Signaldetails> createState() => _SignaldetailsState();
}

class _SignaldetailsState extends ConsumerState<Signaldetails> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(getTraderController).getComment(widget.signalId, widget.refo);
    });
  }

  @override
  Widget build(BuildContext context) {
    final signal = ref.watch(signalProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Signal Details'),
        actions: [
          GestureDetector(
            onTap: () async {
              if (ref.watch(copyTradeController).addCopyResult.state !=
                  AddCopyResultState.isLoading) {
                await widget.refo
                    .read(copyTradeController)
                    .addCopy(widget.refo, widget.signalId);
              }
            },
            child: Container(
              margin: EdgeInsets.only(right: 30),
              height: 30,
              width: 30,
              child: ref.watch(addCopyProvider(widget.signalId)).state ==
                      AddCopyResultState.isLoading
                  ? SvgPicture.asset('assets/svg/star-favourite.svg',
                      color: Colors.grey)
                  : signal[widget.index].copyTraded!
                      ? SvgPicture.asset('assets/svg/star-favourite.svg',
                          allowDrawingOutsideViewBox: true, color: Colors.amber)
                      : SvgPicture.asset('assets/svg/favourite.svg',
                          allowDrawingOutsideViewBox: true, color: Colors.grey),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.pair,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          formatDateTime(widget.createdDate),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Gap(5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                              color: Color(0xff737789),
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                        ),
                        widget.active
                            ? Text(
                                'Active',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.ksuccessColor500,
                                    fontWeight: FontWeight.w600),
                              )
                            : Text(
                                widget.entries.contains(widget.stoploss) ||
                                        widget.entries
                                            .contains(widget.takeprofit)
                                    ? 'Trade Completed'
                                    : 'Signal Canceled',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 10),
                              ),
                      ],
                    )
                  ],
                ),
                Gap(20),
                Row(
                  children: [
                    Text(
                      calculatePNL(
                        tradeType: widget.order.toUpperCase(),
                        currencyPair: widget.pair,
                        entryPrice: double.parse(widget.entry),
                        currentPrice: double.parse(
                            ref.watch(getpriceProvider(widget.pair)).price ??
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
                  ],
                ),
                Gap(10),
                Container(
                  color: AppColors.kgrayColor50,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ENTRY',
                            style: TextStyle(
                                color: Color(0xff737789), fontSize: 10),
                          ),
                          Gap(5),
                          Text(
                            widget.entry,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STOP',
                            style: TextStyle(
                                color: Color(0xff737789), fontSize: 10),
                          ),
                          Gap(5),
                          Text(
                            widget.stoploss,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TARGET',
                            style: TextStyle(
                                color: Color(0xff737789), fontSize: 10),
                          ),
                          Gap(5),
                          DynamicTextColumn(
                            text: widget.takeprofit,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Gap(20),
                Text(
                  'Signal Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Duration',
                      style: TextStyle(color: Color(0xff737789)),
                    ),
                    Text(
                      '1 Month',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Success Rate',
                      style: TextStyle(color: Color(0xff737789)),
                    ),
                    Text(
                      '85%',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Risk Level',
                      style: TextStyle(color: Color(0xff737789)),
                    ),
                    Text(
                      'Medium',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                Gap(40),

                //A new Header
                StickyHeader(
                  header: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    color: Colors.white, // same as your background to blend in
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Comments',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  content: Builder(
                    builder: (context) {
                      final commentResult =
                          ref.watch(getTraderController).getCommentResult;
                      if (commentResult.state ==
                          GetCommentResultState.isLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (commentResult.state ==
                          GetCommentResultState.isError) {
                        return Center(
                          child: Text(commentResult.response.msg ?? ''),
                        );
                      } else if (commentResult.state ==
                          GetCommentResultState.isEmpty) {
                        return const Text(
                            'There are no comments on this signal');
                      } else {
                        final comments = List.from(
                            commentResult.response.comment ?? <Comment>[])
                          ..sort(
                              (a, b) => b.dateCreated.compareTo(a.dateCreated));
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return CommentWidget(context, comments[index]);
                          },
                        );
                      }
                    },
                  ),
                ),

                Gap(60)
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding:
                  EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
              child: SafeArea(
                bottom: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .76,
                      child: TextFormField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment',
                          filled: true,
                          fillColor: AppColors.kgrayColor50,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xff9C9FAC),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.kprimaryColor300,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        SmartDialog.showLoading();
                        await ref.read(getTraderController).sendComment(
                            ref
                                .watch(getTraderController)
                                .userData['firstname'],
                            ref.watch(getTraderController).userData['lastname'],
                            _commentController.text,
                            ref.watch(getTraderController).userData['imageUrl'],
                            widget.signalId,
                            ref);
                        if (ref
                                .watch(getTraderController)
                                .sendCommentResult
                                .state ==
                            SendCommentResultState.isData) {
                          _commentController.clear();
                          SnackBarService.notifyAction(context,
                              message: ref
                                      .watch(getTraderController)
                                      .sendCommentResult
                                      .response
                                      .msg ??
                                  '',
                              status: SnackbarStatus.success);
                        } else {
                          SnackBarService.notifyAction(context,
                              message: ref
                                      .watch(getTraderController)
                                      .sendCommentResult
                                      .response
                                      .msg ??
                                  '',
                              status: SnackbarStatus.fail);
                        }
                        SmartDialog.dismiss();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.kgrayColor50,
                        ),
                        child: SvgPicture.asset('assets/svg/send.svg'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container CommentWidget(BuildContext context, Comment comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          comment.imageUrl == ""
              ? SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.asset('assets/images/images.png'))
              : SizedBox(
                  height: 40,
                  width: 40,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: comment.imageUrl!,
                      fit: BoxFit
                          .cover, // Ensures the image fills the circle properly
                    ),
                  ),
                ),
          Gap(20),
          SizedBox(
            width: MediaQuery.of(context).size.width * .7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${comment.firstname} ${comment.lastname}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(timeAgo(comment.dateCreated!)),
                  ],
                ),
                Gap(10),
                Text(
                  comment.comment!,
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
