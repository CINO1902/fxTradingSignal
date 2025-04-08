import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/getSIgnals/domain/entities/SignalResponse.dart';
import 'package:fx_trading_signal/features/getTraders/presentation/provider/homeProvider.dart';
import 'package:fx_trading_signal/features/getcopies/domain/entities/addCopyResponse.dart';
import 'package:fx_trading_signal/features/getcopies/domain/repositories/getCopyRepo.dart';

import '../../../getTraders/presentation/pages/home.dart';
import '../../../getTraders/presentation/widgets/traderWidget.dart';
import '../../domain/entities/getCopyModel.dart';
import '../../domain/usecases/addCopyState.dart';
import '../../domain/usecases/getCopyState.dart';

final copiedTradeProvider = StateProvider<List<CopyTrade>>((ref) => []);

class CopyTradeContoller with ChangeNotifier {
  final CopyTradeRepository copyTradeRepository;
  CopyTradeContoller(this.copyTradeRepository);

  AddCopyResult addCopyResult =
      AddCopyResult(AddCopyResultState.idle, AddCopyResponse());
  GetCopyResult getCopyResult =
      GetCopyResult(GetCopyResultState.isLoading, GetCopyResponse());

  Future<void> getCopy(WidgetRef ref) async {
    final token = ref.watch(getTraderController).userData['token'];
    getCopyResult =
        GetCopyResult(GetCopyResultState.isLoading, GetCopyResponse());

    notifyListeners();
    final response = await copyTradeRepository.getCopy(token);
    getCopyResult = response;
    if (getCopyResult.response.copyTrade != null) {
      ref.read(copiedTradeProvider.notifier).state =
          getCopyResult.response.copyTrade!;
    }

    notifyListeners();
  }

  Future<void> addCopy(WidgetRef ref, signalId) async {
    final token = ref.watch(getTraderController).userData['token'];
    addCopyResult =
        AddCopyResult(AddCopyResultState.isLoading, AddCopyResponse());
    ref.read(addCopyProvider(signalId).notifier).state = addCopyResult;
    notifyListeners();
    final response = await copyTradeRepository.addCopy(signalId, token);
    addCopyResult = response;

    ref.read(addCopyProvider(signalId).notifier).state = addCopyResult;
    if (addCopyResult.state == AddCopyResultState.isAdded) {
      ref.read(signalProvider.notifier).update((state) {
        return state.map((signal) {
          if (signal.signalId == signalId) {
            return signal.copyWith(copyTraded: true);
          }
          return signal;
        }).toList();
      });
      // CopyTrade copyTrade = CopyTrade()

      ref.read(copiedTradeProvider.notifier).update((state) {
        return [addCopyResult.response.data!, ...state];
      });
    }

    if (addCopyResult.state == AddCopyResultState.isRemoved) {
      ref.read(signalProvider.notifier).update((state) {
        return state.map((signal) {
          if (signal.signalId == signalId) {
            return signal.copyWith(copyTraded: false);
          }
          return signal;
        }).toList();
      });
      ref.read(copiedTradeProvider.notifier).update((state) {
        return state.where((trade) => trade.signalId != signalId).toList();
      });
    }
    notifyListeners();
  }

  void updateCopyTradeFromSocket(Signal newSignal, Ref ref) {
    // Get the current list of copy trades from the provider.
    final List<CopyTrade> copyTrades =
        ref.read(copiedTradeProvider.notifier).state;

    // Find the index where the signalId matches.
    final index =
        copyTrades.indexWhere((ct) => ct.signalId == newSignal.signalId);

    if (index != -1) {
      // Update the copy trade's relatedData with the new signal.
      copyTrades[index] = copyTrades[index].copyWith(
        relatedData: newSignal,
      );

      // Reassign the provider state with a new list to trigger listeners.
      ref.read(copiedTradeProvider.notifier).state = List.from(copyTrades);
    } else {
      // Optionally, add a new copy trade if none exists.
      // copyTrades.add(CopyTrade(
      //   signalId: newSignal.signalId,
      //   relatedData: newSignal,
      //   // Add other required fields here.
      // ));
      // ref.read(copiedTradeProvider.notifier).state = List.from(copyTrades);
    }
  }
}
