abstract class AppException implements Exception {
  const AppException(this.message);
  final String message;
}

class CustomException extends AppException {
  CustomException(String message) : super(message);
}
