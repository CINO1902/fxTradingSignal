import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/core/utils/appColors.dart';
import 'package:fx_trading_signal/features/getcopies/domain/usecases/getCopyState.dart';
import 'package:fx_trading_signal/features/getcopies/presentation/provider/CopyTradeProvider.dart';
import 'package:gap/gap.dart';

import '../../../getSIgnals/presentation/widgets/signalShimmer.dart';
import '../../../getTraders/presentation/widgets/signalCardShimmer.dart';
import '../controller/controller.dart';
import '../widgets/completedCopy.dart';
import '../widgets/copyWidget.dart';

class Copies extends ConsumerStatefulWidget {
  const Copies({super.key});

  @override
  ConsumerState<Copies> createState() => _CopiesState();
}

class _CopiesState extends ConsumerState<Copies>
    with SingleTickerProviderStateMixin {
  late final TabController controller = TabController(length: 3, vsync: this)
    ..addListener(() {
      setState(() {});
    });

  @override
  void initState() {
    runOperation();
    super.initState();
  }

  void runOperation() async {
    await Future.delayed(Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(copyTradeController).getCopy(ref);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        centerTitle: false,
        title: Text(
          'My Copies',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        //
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // The top container (wrapped in a SliverToBoxAdapter)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const Gap(20),
                    // Your top container with the two cards
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 163,
                            height: 95,
                            decoration: BoxDecoration(
                              color: AppColors.ksuccessColor100.withOpacity(.2),
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Success Rate',
                                    style: TextStyle(
                                      color: AppColors.kprimaryColor300,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Gap(4),
                                  Text(
                                    '78%',
                                    style: TextStyle(
                                      color: AppColors.kprimaryColor300,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Gap(4),
                                  Text(
                                    '+5% this week',
                                    style: TextStyle(
                                      color: AppColors.ksuccessColor300,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 163,
                            height: 95,
                            decoration: const BoxDecoration(
                              color: Color(0xffFEF5E7),
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Active Copies',
                                    style: TextStyle(
                                      color: AppColors.kBlack,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Gap(4),
                                  Text(
                                    '4',
                                    style: TextStyle(
                                      color: AppColors.kBlack,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Gap(4),
                                  Text(
                                    '2 closing soon',
                                    style: TextStyle(
                                      color: AppColors.kBlack,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
              ),

              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 40,
                  maxHeight: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: AppColors.kgrayColor50),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tab 1
                        GestureDetector(
                          onTap: () {
                            controller.animateTo(0);
                            setState(() {}); // update selected tab style
                          },
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              border: controller.index == 0
                                  ? Border(
                                      bottom: BorderSide(
                                        color: AppColors.kprimaryColor400,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'All',
                                style: TextStyle(
                                  color: controller.index == 0
                                      ? AppColors.kprimaryColor400
                                      : AppColors.kgrayColor100,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Tab 2
                        GestureDetector(
                          onTap: () {
                            controller.animateTo(1);
                            setState(() {});
                          },
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              border: controller.index == 1
                                  ? Border(
                                      bottom: BorderSide(
                                        color: AppColors.kprimaryColor400,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Active',
                                style: TextStyle(
                                  color: controller.index == 1
                                      ? AppColors.kprimaryColor400
                                      : AppColors.kgrayColor100,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Tab 3
                        GestureDetector(
                          onTap: () {
                            controller.animateTo(2);
                            setState(() {});
                          },
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              border: controller.index == 2
                                  ? Border(
                                      bottom: BorderSide(
                                        color: AppColors.kprimaryColor400,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Completed     ',
                                style: TextStyle(
                                  color: controller.index == 2
                                      ? AppColors.kprimaryColor400
                                      : AppColors.kgrayColor100,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          // The TabBarView becomes the body of the NestedScrollView
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TabBarView(
              controller: controller,
              // Remove NeverScrollableScrollPhysics if you want swipe support
              children: [
                // For nested scrolling, it's best not to use shrinkWrap: true.
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: buildCopyWidget(ref, null),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: buildCopyWidget(ref, true),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: buildCopyWidget(ref, false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

Widget buildCopyWidget(WidgetRef ref, bool? active) {
  final conpyTradeContollerWatch = ref.watch(copyTradeController);
  final copyTradeResponseResult = conpyTradeContollerWatch.getCopyResult;
  final providerCopy = ref.watch(copiedTradeProvider);
  final state = copyTradeResponseResult.state;
  final copyTrade = active == null
      ? providerCopy.where((element) => element.relatedData != null).toList()
      : providerCopy
          .where((element) =>
              element.relatedData != null &&
              element.relatedData!.active == active)
          .toList();

  if (state == GetCopyResultState.isLoading) {
    return ListView(
      children: [
        SignalWidgetShimmer(),
        Gap(15),
        SignalWidgetShimmer(),
        Gap(15),
        SignalWidgetShimmer(),
      ],
    );
  }

  if (state == GetCopyResultState.isEmpty) {
    return Center(
      child: Text(
        active == false
            ? 'You don\'t have a completed Copy Trade'
            : 'You are not copying any trade yet \nClick the favourite icon on the signal to copy a trade',
        textAlign: TextAlign.center,
      ),
    );
  }

  if (state == GetCopyResultState.isError) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(copyTradeResponseResult.response.msg ?? ''),
          Gap(15),
          GestureDetector(
            onTap: () async {
              ref.read(copyTradeController).getCopy(ref);
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
    onRefresh: () => ref.read(copyTradeController).getCopy(ref),
    child: ListView.builder(
      itemCount: copyTrade.length,
      itemBuilder: (context, index) {
        // final signal = copyTrade![index];
        if (copyTrade[index].relatedData!.active!) {
          return continueCopy(
            refo: ref,
            copydata: copyTrade[index],
          );
        } else {
          return CompletedCopy(
            refo: ref,
            copydata: copyTrade[index],
          );
        }
      },
    ),
  );
}
