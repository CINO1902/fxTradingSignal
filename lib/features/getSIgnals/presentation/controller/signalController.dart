import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/constant/snackBar.dart';
import 'package:fx_trading_signal/features/getSIgnals/domain/entities/SignalResponse.dart';
import 'package:fx_trading_signal/features/getTraders/presentation/pages/home.dart';

import '../../../getTraders/presentation/provider/homeProvider.dart';

import '../../domain/entities/signalByIDRes.dart';
import '../../domain/repositories/signalRepo.dart';
import '../../domain/usecases/signalStates.dart';

class SignalController with ChangeNotifier {
  final SignalRepository signalRepository;
  SignalController(this.signalRepository);

  SignalResponseResult signalResponseResult = SignalResponseResult(
    SignalResponseResultState.isLoading,
    SignalResponse(),
  );
  SignalResponseByIDResult signalResponsebyIdResult = SignalResponseByIDResult(
      SignalResponseByIDResultState.isLoading, SignalById());

  bool _newSignalAdded = false;
  bool get newSignalAdded => _newSignalAdded;
  bool _newSignalUpdated = false;
  bool get newSignalUpdated => _newSignalUpdated;
  String message = '';
  Future<void> getsignal(
    WidgetRef ref,
  ) async {
    final userId = ref.watch(getTraderController).userData['email'];
    print(userId);
    signalResponseResult = SignalResponseResult(
        SignalResponseResultState.isLoading, SignalResponse());
    notifyListeners();

    final response = await signalRepository.getSignal(userId);
    signalResponseResult = response;
    ref.read(signalProvider.notifier).state =
        signalResponseResult.response.signals ?? [];
    notifyListeners();
  }

  Future<void> reverseNotification() async {
    signalResponsebyIdResult = SignalResponseByIDResult(
        SignalResponseByIDResultState.isLoading, SignalById());

    notifyListeners();
  }

  Future<SignalResponseByIDResult> getsignalbyId(
      WidgetRef ref, String signalId) async {
    final userId = ref.watch(getTraderController).userData['email'];
    print(userId);
    signalResponsebyIdResult = SignalResponseByIDResult(
        SignalResponseByIDResultState.isLoading, SignalById());
    notifyListeners();

    final response = await signalRepository.getSignalbyId(userId, signalId);
    signalResponsebyIdResult = response;
    notifyListeners();
    // ref.read(signalProvider.notifier).state =
    //     signalResponseResult.response.signals ?? [];

    return signalResponsebyIdResult;
  }

  /// Update the list by matching the signalId field.
  void updateSignalFromSocket(Signal newSignal, Ref ref) {
    // final signals = signalResponseResult.response.signals;
    final List<Signal> signals = ref.read(signalProvider.notifier).state;
    // if (signals == null) return;

    final index =
        signals.indexWhere((signal) => signal.signalId == newSignal.signalId);

    if (index != -1) {
      print(signals[index].signalId);
      // Option 1: Replace the entire signal object:
      signals[index] = newSignal;
      _newSignalAdded = true;
      message = '${signals[index].signalName} have been adjusted';
      // Option 2: Alternatively, update only specific fields:
      // signals[index] = signals[index].copyWith(
      //     signalName: newSignal.signalName,
      //     stopLoss: newSignal.stopLoss,
      //     takeProfit: newSignal.takeProfit
      //     // add other fields as needed
      //     );
      notifyListeners();
    } else {
      print(newSignal);
      message = '${newSignal.signalName} have been added';
      _newSignalUpdated = true;
      // Optionally add the signal if not found.
      signals.insert(0, newSignal);
      notifyListeners();
    }
  }

  void resetNewSignalFlag() {
    _newSignalAdded = false;
    _newSignalUpdated = false;
    message = '';
  }
}
