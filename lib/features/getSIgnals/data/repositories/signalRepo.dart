import '../../domain/usecases/signalStates.dart';

abstract class SignalDatasource {
  Future<SignalResponseResult> getSignal(accesstoken);
  Future<SignalResponseByIDResult> getSignalbyId(accesstoken, id);
}
