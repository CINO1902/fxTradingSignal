import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:fx_trading_signal/features/chat/domain/usecases/sqlite.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/appColors.dart';
import '../../../chat/presentation/pages/chatUi.dart';
import '../../../getTraders/presentation/provider/homeProvider.dart';

class Helpandsupport extends ConsumerStatefulWidget {
  const Helpandsupport({super.key});

  @override
  ConsumerState<Helpandsupport> createState() => _HelpandsupportState();
}

class _HelpandsupportState extends ConsumerState<Helpandsupport> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callmessage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncMessages();
    });
  }

  Future<void> _syncMessages() async {
    bool exists =
        await DatabaseHelper().hasLocalMessages(ref.watch(convoMongoProvider));
    debugPrint('Local messages exist: $exists');
    if (!exists) {
      await DatabaseHelper().getAllMessage(ref.watch(convoMongoProvider), ref);
    } else {
      await DatabaseHelper()
          .incrementalSync(ref.watch(convoMongoProvider), ref);
    }
  }

  Future<void> callmessage() async {
    await _dbHelper.initializeMessage();
  }

  bool _showCartBadge = false;
  @override
  Widget build(BuildContext context) {
    final convoId = ref.watch(convoMongoProvider);
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
        surfaceTintColor: AppColors.kWhite,
        centerTitle: false,
        title: Text(
          'Help & Support',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Center(
          //   child: Container(
          //     color: Colors.white,
          //     width: MediaQuery.of(context).size.width * .85,
          //     height: 60,
          //     child: SizedBox(
          //       height: 40,
          //       child: TextFormField(
          //         decoration: InputDecoration(
          //           hintText: 'Search Signals',
          //           prefixIcon: GestureDetector(
          //             onTap: () {},
          //             child: SizedBox(
          //               height: 25,
          //               width: 25,
          //               child: SvgPicture.asset(
          //                 'assets/svg/search-normal.svg', // Add an 'eye_off' icon
          //                 fit: BoxFit.scaleDown,
          //               ),
          //             ),
          //           ),
          //           filled: true,
          //           fillColor: AppColors.kgrayColor50,
          //           border: OutlineInputBorder(
          //               borderSide: BorderSide.none,
          //               borderRadius: BorderRadius.circular(5)),
          //           contentPadding: const EdgeInsets.symmetric(
          //               horizontal: 10, vertical: 12),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 50),
              color: AppColors.kgrayColor50,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 161,
                  width: 339,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder<List<Map<String, dynamic>>>(
                          stream: _dbHelper.messageStream,
                          builder: (context, snapshot) {
                            final messages = snapshot.data ??
                                []
                                    .where((msg) =>
                                        msg['conversationId'] == convoId)
                                    .toList();
                            final unreadMessages = messages.where((msg) =>
                                msg['isRead'] == 0 &&
                                msg['sender'] !=
                                    ref
                                        .read(getTraderController)
                                        .userData['userId']);
                            final unreadCount = unreadMessages.length;
                            final firstUnreadTimestamp =
                                unreadMessages.isNotEmpty
                                    ? unreadMessages.first['timestamp']
                                    : null;
                            _showCartBadge = unreadCount > 0;
                            DateTime dateTime = DateTime.parse(
                                    firstUnreadTimestamp ??
                                        DateTime.now().toString())
                                .toUtc()
                                .toLocal();
                            return GestureDetector(
                              onTap: () {
                                context.pushNamed('chatUi', extra: {
                                  "UnreadMessage": unreadCount,
                                  "timeslastmessage": dateTime
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                color: AppColors.kgrayColor50,
                                width: 142,
                                height: 107,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: badges.Badge(
                                            position:
                                                badges.BadgePosition.topEnd(
                                                    top: 0, end: 3),
                                            badgeAnimation:
                                                badges.BadgeAnimation.slide(
                                                    // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                                                    // curve: Curves.easeInCubic,
                                                    ),
                                            showBadge: _showCartBadge,
                                            badgeStyle: badges.BadgeStyle(
                                              badgeColor: Colors.red,
                                            ),
                                            badgeContent: Text(
                                              unreadCount.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            child: Image.asset(
                                                'assets/images/helpChat.png'))),
                                    Text(
                                      'Live Chat',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    Text('Avg wait 2 mins')
                                  ],
                                ),
                              ),
                            );
                          }),
                      GestureDetector(
                        onTap: () {
                          DatabaseHelper().reinitializeDatabase();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          color: AppColors.kgrayColor50,
                          width: 142,
                          height: 107,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Image.asset(
                                      'assets/images/helpCall.png')),
                              Text(
                                'Call Us',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              Text('24/7 Support')
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
