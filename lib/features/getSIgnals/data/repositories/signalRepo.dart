import '../../domain/usecases/signalStates.dart';

abstract class SignalDatasource {
  Future<SignalResponseResult> getSignal(email);
  Future<SignalResponseByIDResult> getSignalbyId(email, id);
}
