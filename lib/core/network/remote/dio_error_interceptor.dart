import 'package:dio/dio.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      // Handle server errors
      if ((err.response!.statusCode ?? 0) >= 300) {
        final data = err.response!.data;
        final message = data is Map ? data['message'] : null;
        err = DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: message?.toString() ??
              err.response!.statusMessage ??
              'Something went wrong',
          type: err.type,
        );
      } else {
        err = DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: 'Something went wrong',
          type: err.type,
        );
      }
    } else {
      // Handle connection errors
      err = DioException(
        requestOptions: err.requestOptions,
        error: 'Connection error',
        type: err.type,
      );
    }
    super.onError(err, handler);
  }
}




