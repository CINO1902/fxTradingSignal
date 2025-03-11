import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/core/utils/appColors.dart';
import 'package:fx_trading_signal/features/notification/presentation/provider/notifcationProvider.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../getTraders/presentation/widgets/signalCardShimmer.dart';
import '../../domain/usecases/NotificatonResult.dart';
import '../widgets/notificationWidget.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.kgrayColor50,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          centerTitle: false,
          title: Text(
            'Notification',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
          ),
        ),
        body: _buildNotificationContent(ref));
  }
}

Widget _buildNotificationContent(WidgetRef ref) {
  final notificationControllerWatch = ref.watch(notificationproviderController);
  final signalResponseResult = notificationControllerWatch.notificatonResult;
  final state = signalResponseResult.state;
  final notification = notificationControllerWatch.notification;
  // final signals = ref.watch(signalProvider);

  if (state == NotificationState.isLoading) {
    return ListView(
      children: [
        SignalShimmerCard(),
        Gap(15),
        SignalShimmerCard(),
        Gap(15),
        SignalShimmerCard(),
      ],
    );
  }

  if (state == NotificationState.isEmpty) {
    return Center(
      child: Text('There are no signals yet'),
    );
  }

  if (state == NotificationState.isError) {
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
              ref.read(notificationproviderController).getNotificationn();
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
    onRefresh: () =>
        ref.read(notificationproviderController).getNotificationn(),
    child: ListView.builder(
      itemCount: notification.length,
      itemBuilder: (context, index) {
        final signal = notification[index];
        return GestureDetector(
          onTap: () {
            if (signal.signalId != null) {
              context.push('/SignaldetailsNotification',
                  extra: {"refo": ref, "signalId": signal.signalId});
            }
          },
          child: NotificationContainer(signal.title ?? '', signal.body ?? '',
              signal.date ?? DateTime.now()),
        );
      },
    ),
  );
}
