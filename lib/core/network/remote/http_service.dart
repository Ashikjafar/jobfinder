import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../config/constants/api_endpoint.dart';
import 'dio_error_interceptor.dart';

final httpServiceProvider = Provider<Dio>(
  (ref) => HttpService(Dio()).dio,
);

class HttpService {
  final Dio _dio;

  Dio get dio => _dio;

  HttpService(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor())
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

    // Only log traffic in debug builds, and never headers (they carry the
    // auth token) or response headers.
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
          requestHeader: false, requestBody: true, responseHeader: false));
    }
  }
}
