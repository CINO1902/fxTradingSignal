import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../getTraders/presentation/pages/home.dart';
import '../../../getTraders/presentation/widgets/signalCardShimmer.dart';
import '../../domain/usecases/signalStates.dart';
import '../provider/signalProvider.dart';
import 'signalShimmer.dart';
import 'signalwidget.dart';

Widget buildSignalContent(WidgetRef ref, String? signalType, String filter) {
  final signalControllerWatch = ref.watch(signalController);
  final signalResponseResult = signalControllerWatch.signalResponseResult;
  final state = signalResponseResult.state;
  final realSignal = ref.watch(signalProvider);
  final baseSignals = signalType == null
      ? realSignal
      : realSignal
          .where((element) => element.signalType == signalType)
          .toList();

  final signals = filter == 'All'
      ? baseSignals
      : filter == 'Running Trade'
          ? baseSignals.where((element) => element.active!).toList()
          : baseSignals.where((element) => !element.active!).toList();

  if (state == SignalResponseResultState.isLoading) {
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

  if (state == SignalResponseResultState.isEmpty) {
    return Center(
      child: Text('There are no ${signalType} signals yet'),
    );
  }

  if (state == SignalResponseResultState.isError) {
    return Center(
      child: Text(signalResponseResult.response.msg ?? ''),
    );
  }

  return RefreshIndicator(
    onRefresh: () => ref.read(signalController).getsignal(ref),
    child: ListView.builder(
      itemCount: signals.length,
      itemBuilder: (context, index) {
        final signal = signals[index];
        return SignalWidget(
          refo: ref,
          copyTraded: signal.copyTraded ?? false,
          signalId: signal.signalId ?? '',
          takeprofit: signal.takeProfit ?? '',
          status: signal.signalType ?? '',
          stoploss: signal.stopLoss ?? '',
          entries: signal.entries ?? '',
          entry: signal.entry ?? '',
          active: signal.active ?? false,
          pair: signal.signalName ?? '',
          order: signal.order ?? '',
          accesstype: signal.accessType ?? '',
          createdDate: signal.dateCreated ?? DateTime.now(),
        );
      },
    ),
  );
}
