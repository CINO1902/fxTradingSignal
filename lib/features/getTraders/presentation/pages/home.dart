import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fx_trading_signal/features/chat/presentation/provider/chatProvider.dart';
import 'package:fx_trading_signal/features/getSIgnals/domain/entities/SignalResponse.dart';
import 'package:fx_trading_signal/features/getSIgnals/domain/usecases/signalStates.dart';
import 'package:fx_trading_signal/features/getTraders/presentation/widgets/signalCardShimmer.dart';
import 'package:fx_trading_signal/features/getTraders/presentation/widgets/traderWidget.dart';
import 'package:fx_trading_signal/features/notification/presentation/provider/notifcationProvider.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/appColors.dart';
import '../../../getSIgnals/presentation/provider/signalProvider.dart';
import '../provider/homeProvider.dart';

final signalProvider = StateProvider<List<Signal>>((ref) => []);

class home extends ConsumerStatefulWidget {
  const home({super.key});

  @override
  ConsumerState<home> createState() => _homeState();
}

class _homeState extends ConsumerState<home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ref.read(getTraderController).getUserObject();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   ref.read(signalController).getsignal(ref);
    // });
    runOperation();
  }

  void runOperation() async {
    await ref.read(getTraderController).getUserObject();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(signalController).getsignal(ref);
      ref.read(notificationproviderController).getNotificationn();
      ref
          .read(chatProviderController)
          .getConvoId(ref.watch(getTraderController).userData['token'], ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            // height: 120,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            ref
                                        .watch(getTraderController)
                                        .userData['imageUrl'] ==
                                    ""
                                ? SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: ClipOval(
                                        child: Image.asset(
                                            'assets/images/images.png')))
                                : SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: ref
                                            .watch(getTraderController)
                                            .userData['imageUrl'],
                                        fit: BoxFit
                                            .cover, // Ensures the image fills the circle properly
                                      ),
                                    ),
                                  ),
                            Gap(15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, ${ref.watch(getTraderController).userData['firstname']}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(greetUser()),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push('/notification');
                      },
                      child: SvgPicture.asset(
                        'assets/svg/notification.svg',
                        height: 30,
                        width: 30,
                      ),
                    )
                  ],
                ),
                Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .85,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Search Signals',
                          prefixIcon: GestureDetector(
                            onTap: () {},
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: SvgPicture.asset(
                                'assets/svg/search-normal.svg', // Add an 'eye_off' icon
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.kgrayColor50,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                        ),
                      ),
                    ),
                    // Container(
                    //   height: 40,
                    //   width: 43,
                    //   decoration: BoxDecoration(
                    //       border: Border.all(color: AppColors.kgrayColor50)),
                    //   child: SvgPicture.asset('assets/svg/save-add.svg'),
                    // )
                  ],
                ),
              ],
            ),
          ),
          Gap(20),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(20),
            color: AppColors.kgrayColor50,
            child: _buildSignalContent(ref),
          )),
        ],
      )),
    );
  }
}

Widget _buildSignalContent(WidgetRef ref) {
  final signalControllerWatch = ref.watch(signalController);
  final signalResponseResult = signalControllerWatch.signalResponseResult;
  final state = signalResponseResult.state;
  final signals = ref.watch(signalProvider);

  if (state == SignalResponseResultState.isLoading) {
    return ListView(
      children: [
        TraderBoardShimmer(),
        Gap(15),
        TraderBoardShimmer(),
        Gap(15),
        TraderBoardShimmer(),
      ],
    );
  }

  if (state == SignalResponseResultState.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('There are no signals yet'),
          Gap(15),
          GestureDetector(
            onTap: () async {
              ref.read(signalController).getsignal(ref);
            },
            child: Container(
              height: 47,
              width: 130,
              decoration: BoxDecoration(
                  color: AppColors.kprimaryColor300,
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  if (state == SignalResponseResultState.isError) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            signalResponseResult.response.msg ?? '',
            style: TextStyle(fontSize: 14),
          ),
          Gap(15),
          GestureDetector(
            onTap: () async {
              ref.read(signalController).getsignal(ref);
            },
            child: Container(
              height: 47,
              width: 130,
              decoration: BoxDecoration(
                  color: AppColors.kprimaryColor300,
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  return RefreshIndicator(
    onRefresh: () => ref.read(signalController).getsignal(ref),
    child: ListView.builder(
      itemCount: signals.length,
      itemBuilder: (context, index) {
        final signal = signals[index];
        return traderBoard(
          refo: ref,
          takeprofit: signal.takeProfit ?? '',
          status: signal.signalType ?? '',
          stoploss: signal.stopLoss ?? '',
          entry: signal.entry ?? '',
          index: index,
          active: signal.active ?? false,
          entries: signal.entries ?? '',
          signalId: signal.signalId ?? '',
          pair: signal.signalName ?? '',
          order: signal.order ?? '',
          copyTraded: signal.copyTraded ?? false,
          accesstype: signal.accessType ?? '',
          createdDate: signal.dateCreated ?? DateTime.now(),
        );
      },
    ),
  );
}

String greetUser() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour == 0) {
    return "Good night";
  } else if (hour < 12) {
    return "Good morning";
  } else if (hour < 17) {
    return "Good afternoon";
  } else if (hour < 21) {
    return "Good evening";
  } else {
    return "Good night";
  }
}

void main() {
  print(greetUser());
}
