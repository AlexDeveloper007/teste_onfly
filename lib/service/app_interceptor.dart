import 'dart:async';
import 'package:dio/dio.dart';
import 'package:teste_onfly/util/global.dart';

class AppInterceptor extends Interceptor {
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra['ignoreInterceptor'] == false) {

      String token = await frwkLogin.token;

      if (token.isNotEmpty) {
         var header = <String, String>{'content-type': 'application/json'};
        header['Authorization'] = token;
        options.headers = header;
      }
    }
    return super.onRequest(options, handler);
  }

  @override
  Future onError(
    DioError error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 403 ||
        error.response?.statusCode == 401) {}

    return super.onError(error, handler);
  }
}
