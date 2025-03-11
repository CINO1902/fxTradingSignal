import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/appColors.dart';
import '../provider/socketProvider.dart';
import '../widgets/buildSignalWidget.dart';

class SignalsPages extends ConsumerStatefulWidget {
  const SignalsPages({super.key});

  @override
  ConsumerState<SignalsPages> createState() => _SignalsPagesState();
}

class _SignalsPagesState extends ConsumerState<SignalsPages>
    with SingleTickerProviderStateMixin {
  late final TabController controller = TabController(length: 3, vsync: this)
    ..addListener(() {
      setState(() {});
    });

  String selectedFilter = 'All';
  bool isSearchFocused = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Total available width after applying horizontal margins of 20 on each side
    final double fullWidth = MediaQuery.of(context).size.width - 40;
    // When not focused, the search field takes up 55% of the screen width.
    final double searchWidth =
        isSearchFocused ? fullWidth : MediaQuery.of(context).size.width * 0.55;

    ref.watch(socketServiceProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Signal',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
        ),
      ),
      // Wrap body in a GestureDetector to unfocus the search field on tap outside.
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Animated search field
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: searchWidth,
                    child: TextFormField(
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Search Signals',
                        prefixIcon: GestureDetector(
                          onTap: () {},
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: SvgPicture.asset(
                              'assets/svg/search-normal.svg',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.kgrayColor50,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                      ),
                    ),
                  ),
                  // Animated filter dropdown container
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: isSearchFocused ? 0 : 135,
                    child: isSearchFocused
                        ? const SizedBox.shrink()
                        : PopupMenuButton<String>(
                            onSelected: (value) {
                              // Unfocus the search field to keep it collapsed.
                              // FocusScope.of(context).unfocus();

                              setState(() {
                                selectedFilter = value;
                              });
                              Future.delayed(Duration(milliseconds: 500))
                                  .then((val) {
                                FocusScope.of(context).unfocus();
                              });
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'All',
                                child: Text('All'),
                              ),
                              const PopupMenuItem(
                                value: 'Running Trade',
                                child: Text('Running Trade'),
                              ),
                              const PopupMenuItem(
                                value: 'Completed Trade',
                                child: Text('Completed Trade'),
                              ),
                            ],
                            child: Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.kgrayColor50),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedFilter,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const Gap(30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width * 0.85,
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  ActionChip(
                    padding: const EdgeInsets.all(5),
                    backgroundColor: controller.index == 0
                        ? const Color(0xff580FEA)
                        : AppColors.kgrayColor50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      controller.animateTo(0);
                      FocusScope.of(context).unfocus();
                    },
                    label: Text(
                      "All",
                      style: controller.index == 0
                          ? const TextStyle(color: Colors.white)
                          : const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ActionChip(
                    padding: const EdgeInsets.all(5),
                    backgroundColor: controller.index == 1
                        ? const Color(0xff580FEA)
                        : AppColors.kgrayColor50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      controller.animateTo(1);
                      FocusScope.of(context).unfocus();
                    },
                    label: Text(
                      "Forex",
                      style: controller.index == 1
                          ? const TextStyle(color: Colors.white)
                          : const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ActionChip(
                    padding: const EdgeInsets.all(5),
                    backgroundColor: controller.index == 2
                        ? const Color(0xff580FEA)
                        : AppColors.kgrayColor50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      controller.animateTo(2);
                      FocusScope.of(context).unfocus();
                    },
                    label: Text(
                      "Crypto",
                      style: controller.index == 2
                          ? const TextStyle(color: Colors.white)
                          : const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              // Listen to scroll notifications to unfocus the search field when scrolling.
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  FocusScope.of(context).unfocus();
                  return false;
                },
                child: TabBarView(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: buildSignalContent(ref, null, selectedFilter),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: buildSignalContent(ref, 'Forex', selectedFilter),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: buildSignalContent(ref, 'Crypto', selectedFilter),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
