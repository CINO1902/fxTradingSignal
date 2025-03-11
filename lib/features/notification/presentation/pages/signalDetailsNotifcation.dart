import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fx_trading_signal/features/getSIgnals/domain/entities/signalByIDRes.dart';
import 'package:fx_trading_signal/features/getSIgnals/domain/usecases/signalStates.dart';
import 'package:fx_trading_signal/features/notification/presentation/provider/notifcationProvider.dart';
import 'package:gap/gap.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../../../constant/shimmer.dart';
import '../../../../constant/snackBar.dart';
import '../../../../core/utils/appColors.dart';
import '../../../getSIgnals/presentation/provider/signalProvider.dart';
import '../../../getSIgnals/presentation/widgets/timeformatter.dart';
import '../../../getTraders/domain/entities/getcommentModel.dart';
import '../../../getTraders/domain/usecases/dateFormater.dart';
import '../../../getTraders/domain/usecases/pnlCalculator.dart';
import '../../../getTraders/domain/usecases/pricesResult.dart';
import '../../../getTraders/presentation/provider/homeProvider.dart';
import '../../../getTraders/presentation/widgets/traderWidget.dart';
import '../../../getcopies/domain/usecases/addCopyState.dart';
import '../../../getcopies/presentation/provider/CopyTradeProvider.dart';

class SignaldetailsNotification extends ConsumerStatefulWidget {
  const SignaldetailsNotification({
    super.key,
    required this.refo,
    required this.signalId,
  });

  final WidgetRef refo;
  final String signalId;

  @override
  ConsumerState<SignaldetailsNotification> createState() =>
      _SignaldetailsState();
}

class _SignaldetailsState extends ConsumerState<SignaldetailsNotification> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref
          .read(signalController)
          .getsignalbyId(ref, widget.signalId)
          .then((val) => {
                if (ref.read(signalController).signalResponsebyIdResult.state ==
                    SignalResponseByIDResultState.isData)
                  {
                    setState(() {
                      signal = ref
                          .read(signalController)
                          .signalResponsebyIdResult
                          .response
                          .signals!;
                    }),
                    ref.read(getTraderController).getComment(
                        ref
                            .read(signalController)
                            .signalResponsebyIdResult
                            .response
                            .signals!
                            .signalsId,
                        widget.refo)
                  }
              });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.refo.read(signalController).reverseNotification();
    });
    super.dispose();
  }

  Signals signal = Signals();

  @override
  Widget build(BuildContext context) {
    // final signal = ref.watch(signalProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text('Signal Details'),
          actions: [
            (ref.watch(signalController).signalResponsebyIdResult.state ==
                    SignalResponseByIDResultState.isData)
                ? GestureDetector(
                    onTap: () async {
                      if (ref.watch(copyTradeController).addCopyResult.state !=
                          AddCopyResultState.isLoading) {
                        await widget.refo
                            .read(copyTradeController)
                            .addCopy(widget.refo, signal.id);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 30),
                      height: 30,
                      width: 30,
                      child: ref
                                  .watch(
                                      addCopyProvider(signal.signalsId ?? ''))
                                  .state ==
                              AddCopyResultState.isLoading
                          ? SvgPicture.asset('assets/svg/star-favourite.svg',
                              color: Colors.grey)
                          : signal.copyTraded ?? false
                              ? SvgPicture.asset(
                                  'assets/svg/star-favourite.svg',
                                  allowDrawingOutsideViewBox: true,
                                  color: Colors.amber)
                              : SvgPicture.asset('assets/svg/favourite.svg',
                                  allowDrawingOutsideViewBox: true,
                                  color: Colors.grey),
                    ),
                  )
                : SizedBox()
          ],
        ),
        body: buildSignalDetailsContent(
            ref, signal, context, _commentController));
  }
}

Widget buildSignalDetailsContent(WidgetRef ref, Signals signal,
    BuildContext context, TextEditingController _commentController) {
  final signalControllerWatch = ref.watch(signalController);
  final signalResponseResult = signalControllerWatch.signalResponsebyIdResult;
  final state = signalResponseResult.state;

  if (state == SignalResponseByIDResultState.isLoading) {
    return SignalDetailsShimmer();
  }

  if (state == SignalResponseByIDResultState.isNull) {
    return Center(
      child: Text('Something Went Wrong loading the document of this signal'),
    );
  }

  if (state == SignalResponseByIDResultState.isError) {
    return Center(
      child: Text(signalResponseResult.response.msg ?? ''),
    );
  }

  return Stack(
    children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signal.signalName!,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      formatDateTime(signal.dateCreated!),
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
                      'Status',
                      style: TextStyle(
                          color: Color(0xff737789),
                          fontSize: 10,
                          fontWeight: FontWeight.w400),
                    ),
                    signal.active!
                        ? Text(
                            'Active',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.ksuccessColor500,
                                fontWeight: FontWeight.w600),
                          )
                        : Text(
                            signal.entries!.contains(signal.stopLoss!) ||
                                    signal.entries!.contains(signal.takeProfit!)
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
                    tradeType: signal.order!.toUpperCase(),
                    currencyPair: signal.signalName!,
                    entryPrice: double.parse(signal.entry!),
                    currentPrice: double.parse(
                        ref.watch(getpriceProvider(signal.signalName!)).price ??
                            '0.0'),
                  ).toString(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: calculatePNL(
                        tradeType: signal.order!.toUpperCase(),
                        currencyPair: signal.signalName!,
                        entryPrice: double.parse(signal.entry!),
                        currentPrice: double.parse(ref
                                .watch(getpriceProvider(signal.signalName!))
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
                      Text('ENTRY',
                          style: TextStyle(
                              color: Color(0xff737789), fontSize: 10)),
                      Gap(5),
                      Text(signal.entry!,
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('STOP',
                          style: TextStyle(
                              color: Color(0xff737789), fontSize: 10)),
                      Gap(5),
                      Text(signal.stopLoss!,
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TARGET',
                          style: TextStyle(
                              color: Color(0xff737789), fontSize: 10)),
                      Gap(5),
                      DynamicTextColumn(text: signal.takeProfit!)
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
                Text('Duration', style: TextStyle(color: Color(0xff737789))),
                Text('1 Month',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400))
              ],
            ),
            Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Success Rate',
                    style: TextStyle(color: Color(0xff737789))),
                Text('85%',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400))
              ],
            ),
            Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Risk Level', style: TextStyle(color: Color(0xff737789))),
                Text('Medium',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400))
              ],
            ),
            Gap(40),
            StickyHeader(
              header: Container(
                margin: EdgeInsets.only(bottom: 20),
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.centerLeft,
                child: const Text('Comments',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              content: Builder(
                builder: (context) {
                  final commentResult =
                      ref.watch(getTraderController).getCommentResult;
                  if (commentResult.state == GetCommentResultState.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (commentResult.state ==
                      GetCommentResultState.isError) {
                    return Center(
                        child: Text(commentResult.response.msg ?? ''));
                  } else if (commentResult.state ==
                      GetCommentResultState.isEmpty) {
                    return const Text('There are no comments on this signal');
                  } else {
                    final comments = List.from(
                        commentResult.response.comment ?? <Comment>[])
                      ..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
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
          padding: EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
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
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
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
                        ref.watch(getTraderController).userData['firstname'],
                        ref.watch(getTraderController).userData['lastname'],
                        _commentController.text,
                        ref.watch(getTraderController).userData['imageUrl'],
                        signal.signalsId!,
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
                    fit: BoxFit.cover,
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
                  Text('${comment.firstname} ${comment.lastname}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text(timeAgo(comment.dateCreated!)),
                ],
              ),
              Gap(10),
              Text(comment.comment!, style: TextStyle(fontSize: 14))
            ],
          ),
        )
      ],
    ),
  );
}

class SignalDetailsShimmer extends StatelessWidget {
  const SignalDetailsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget.rectangle(width: width * 0.5, height: 14),
                      Gap(5),
                      ShimmerWidget.rectangle(width: width * 0.3, height: 14),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget.rectangle(width: 40, height: 10),
                      Gap(5),
                      ShimmerWidget.rectangle(width: 40, height: 14),
                    ],
                  ),
                ],
              ),
              Gap(20),
              ShimmerWidget.rectangle(width: width * 0.3, height: 20),
              Gap(10),
              Container(
                color: AppColors.kgrayColor50,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerWidget.rectangle(width: width * 0.25, height: 14),
                    ShimmerWidget.rectangle(width: width * 0.25, height: 14),
                    ShimmerWidget.rectangle(width: width * 0.25, height: 14),
                  ],
                ),
              ),
              Gap(20),
              ShimmerWidget.rectangle(width: width * 0.4, height: 16),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget.rectangle(width: width * 0.2, height: 14),
                  ShimmerWidget.rectangle(width: width * 0.2, height: 14),
                ],
              ),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget.rectangle(width: width * 0.2, height: 14),
                  ShimmerWidget.rectangle(width: width * 0.2, height: 14),
                ],
              ),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget.rectangle(width: width * 0.2, height: 14),
                  ShimmerWidget.rectangle(width: width * 0.2, height: 14),
                ],
              ),
              Gap(40),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.centerLeft,
                child: ShimmerWidget.rectangle(width: width * 0.3, height: 16),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget.circle(radius: 20),
                        Gap(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerWidget.rectangle(
                                  width: width * 0.5, height: 16),
                              Gap(10),
                              ShimmerWidget.rectangle(
                                  width: width * 0.7, height: 14),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              Gap(60)
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
            child: SafeArea(
              bottom: true,
              child: ShimmerWidget.rectangle(width: width * 0.76, height: 40),
            ),
          ),
        ),
      ],
    );
  }
}
