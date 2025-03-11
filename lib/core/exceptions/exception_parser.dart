import 'dart:io';

import 'package:dio/dio.dart';

import '../../constant/enum.dart';
import 'network_exception.dart';

NetworkException parseNetworkException(DioException e) {
  late NetworkException networkException;
  if (e.error is SocketException) {
    networkException =
        NetworkException(NetworkExceptionType.noInternetConnection);
  } else if (e.error is FormatException) {
    networkException = NetworkException(NetworkExceptionType.invalidFormat);
  }
  switch (e.type) {
    case DioExceptionType.unknown:
      networkException = NetworkException(
        NetworkExceptionType.unExpected,
        errorMessage: 'Unexpected Error',
      );
      break;
    case DioExceptionType.receiveTimeout:
      networkException = NetworkException(
        NetworkExceptionType.requestTimeOut,
        errorMessage: 'Receive Timed Out', // Corrected typo
      );
      break;
    case DioExceptionType.connectionTimeout:
      networkException = NetworkException(
        NetworkExceptionType.requestTimeOut,
        errorMessage: 'Request Timed Out',
      );
      break;
    case DioExceptionType.sendTimeout:
      networkException = NetworkException(
        NetworkExceptionType.sendTimeOut,
        errorMessage: 'Request Timed Out',
      );
      break;
    case DioExceptionType.cancel:
      networkException = NetworkException(
        NetworkExceptionType.requestCancelled,
        errorMessage: 'Request has been cancelled',
      );
      break;
    case DioExceptionType.badResponse:
      switch (e.response!.statusCode) {
        case 401:
          networkException = NetworkException(
              NetworkExceptionType.unauthorizedRequest,
              errorMessage: e.response!.data['error'] ??
                  e.response!.data['message'] ??
                  e.response!.data['detail']);
          break;
        case 403:
          networkException = NetworkException(
            NetworkExceptionType.unauthorizedRequest,
            errorMessage: e.response!.data['detail'] ??
                e.response!.data['errors'] ??
                e.response!.data['message'] ??
                e.response!.data['detail'],
          );
          break;
        case 404:
          networkException = NetworkException(
            NetworkExceptionType.notFound,
            errorMessage: e.response!.data['detail'] ??
                e.response!.data['errors'] ??
                e.response!.data['message'] ??
                e.response!.data['msg'],
          );
          break;

        case 408:
          networkException = NetworkException(
            NetworkExceptionType.requestTimeOut,
            errorMessage: e.response!.data['error_message'] ??
                e.response!.data['errors'] ??
                e.response!.data['message'] ??
                e.response!.data['detail'],
          );
          break;
        case 409:
          networkException = NetworkException(
            NetworkExceptionType.conflict,
            errorMessage: e.response!.data['errors'] ??
                e.response!.data['message'] ??
                e.response!.data['detail'],
          );
          break;
        case 500:
          networkException = NetworkException(
            NetworkExceptionType.internalServerError,
            errorMessage: e.response!.data['errors'] ??
                e.response!.data['msg'] ??
                e.response!.data['message'] ??
                e.response!.data['detail'],
          );
          break;
        case 400:
          networkException = NetworkException(
            NetworkExceptionType.internalServerError,
            errorMessage: e.response!.data['errors'] ??
                e.response!.data['message'] ??
                e.response!.data['detail'],
          );
          break;
        case 503:
          networkException = NetworkException(
            NetworkExceptionType.serviceUnavailable,
            errorMessage: e.response!.data['msg'],
          );
          break;
        default:
          networkException = NetworkException(
            NetworkExceptionType.unExpected,
            errorMessage: e.response?.data['message'],
          );
      }
      break;
    default:
      networkException = NetworkException(
        NetworkExceptionType.unExpected,
        errorMessage: e.response?.data['message'],
      );
  }
  return networkException;
}
