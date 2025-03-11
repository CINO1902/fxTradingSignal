enum RequestMethod { post, get, put, delete, patch }
enum NetworkExceptionType {
  badRequest('Bad request'),
  noInternetConnection('No internet connection'),
  conflict('Conflict'),
  requestTimeOut('Request time out'),
  unauthorizedRequest('Unauthorize request'),
  invalidFormat('Invalid format'),
  notFound('Not found'),
  unExpected('Unexpected error'),
  internalServerError('Internal server error'),
  serviceUnavailable('Service unavailable'),
  notImplemented('Not implemented'),
  sendTimeOut('Time out error'),
  requestCancelled('Request cancelled');

  const NetworkExceptionType(this.description);
  final String description;

  @override
  String toString() => 'NetworkExceptionType($description)';
}