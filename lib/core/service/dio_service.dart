import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../constant/enum.dart';
import '../../constant/network_api.dart';
import '../exceptions/app_exceptions.dart';
import '../exceptions/exception_parser.dart';

import 'http_service.dart';

class DioService implements HttpService {
  final Dio dio;

  DioService(this.dio) {
    dio.options.baseUrl = baseUrl;

    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);

    dio.options.headers.addAll({'Content-Type': 'application/json'});

    if (kDebugMode) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (requestOptions, handler) {
            log(
              'REQUEST[${requestOptions.method}] => PATH: ${requestOptions.path}'
              '=> REQUEST VALUES: ${requestOptions.queryParameters} => HEADERS: ${requestOptions.headers}',
            );
            return handler.next(requestOptions);
          },
          onResponse: (response, handler) {
            log(
              'RESPONSE[${response.statusCode}] => DATA: ${response.data}',
            );
            return handler.next(response);
          },
          onError: (err, handler) async {
            //   final SharedPreferences prefs =
            //       await SharedPreferences.getInstance();
            //   log('request failed: ${err.response?.statusCode}');
            //   // log('contains refresh token in storgae: ${prefs.containsKey('refreshToken')}');
            //   if ((err.response?.statusCode == 401 &&
            //       err.response?.data['msg'] == "Unauthorized")) {
            //     if (prefs.containsKey('refreshToken')) {
            //       // will throw error below
            //       await refreshToken();
            //       // return handler.resolve(await _retry(err.requestOptions));
            //     }
            //   }
            log('Error[${err.response?.statusCode}]');
            // log('Error[${err.response?.data}]');
            return handler.next(err);
          },
        ),
      );
    }
  }

  @override
  Future<Response> request({
    required String url,
    required RequestMethod methodrequest,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    String? authtoken,
    dynamic data,
  }) async {
    Response response;
    try {
      if (methodrequest == RequestMethod.post) {
        response = await dio.post(url, data: data, cancelToken: cancelToken);
      } else if (methodrequest == RequestMethod.delete) {
        response = await dio.delete(url);
      } else if (methodrequest == RequestMethod.patch) {
        response = await dio.patch(url, data: data);
      } else if (methodrequest == RequestMethod.put) {
        response = await dio.put(url, data: params);
      } else if (methodrequest == RequestMethod.postWithToken) {
        response = await dio.post(
          url,
          data: data,
          cancelToken: cancelToken,
          options: Options(
            headers: {
              'Authorization': 'Bearer $authtoken',
            },
          ),
        );
      } else if (methodrequest == RequestMethod.getWithToken) {
        response = await dio.get(
          url,
          data: data,
          cancelToken: cancelToken,
          options: Options(
            headers: {
              'Authorization': 'Bearer $authtoken',
            },
          ),
        );
      } else {
        response = await dio.get(url,
            queryParameters: params, cancelToken: cancelToken);
      }
      return response;
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
        if (e.response == null) {
          CustomException('Something Went wrong');
        }
        CustomException(e.error.toString());
        throw parseNetworkException(e);
      }

      throw Exception(e);
    }
  }

  @override
  set header(
    Map<String, dynamic> header,
  ) {
    dio.options.headers = header;
  }

  @override
  Future<Map<String, dynamic>> formdata({
    required String key,
    required String path,
    String? name,
  }) async {
    final formdata = <String, dynamic>{
      key: await MultipartFile.fromFile(path, filename: name),
    };
    return formdata;
  }

  // Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
  //   log('retrying request');
  //   final options = Options(
  //     method: requestOptions.method,
  //     headers: requestOptions.headers,
  //   );
  //   return dio.request<dynamic>(requestOptions.path,
  //       data: requestOptions.data,
  //       queryParameters: requestOptions.queryParameters,
  //       options: options);
  // }
}
