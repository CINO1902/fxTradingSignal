import '../../constant/enum.dart';

class NetworkException {
  NetworkException(this.type, {this.errorMessage});
  final NetworkExceptionType type;
  final String? errorMessage;
  String get message => errorMessage ?? type.description;

  @override
  String toString() =>
      'NetworkException(type: $type, errorMessage: $errorMessage)';
}
