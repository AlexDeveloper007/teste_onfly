import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_interceptor.dart';
import 'network_error.dart';

enum HttpMethod { GET, POST, PUT, PATCH, DELETE }

const String ERROR_MESSAGE = 'Não foi possível concluir sua chamada! Tente novamente mais tarde.';
const String ERROR_CONNECTION_MESSAGE = 'Verifique sua conexão!';

class NetworkService {
  static Dio? _dio;

  static BaseOptions _baseOptions = new BaseOptions(
    baseUrl: "https://go-bd-api-3iyuzyysfa-uc.a.run.app/api",
    connectTimeout: 60000,
    receiveTimeout: 60000,
  );

  static final instance = NetworkService._();

  NetworkService._() {
    this._init();
    addInterceptor(AppInterceptor());
  }

  _init() {
    if (_dio == null) {
      _dio = Dio(_baseOptions);
      _configDio(_dio);
    }
  }

  _configDio(Dio? dio) {
      (dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
  }

  addInterceptor(Interceptor interceptor) {
    _dio!.interceptors.add(interceptor);
  }

  Future<dynamic> request(HttpMethod method, String endpoint, {Map<String, String>? headers, body, @required bool? ignoreInterceptor, bool withHeaders = false, bool withResponseBytes = false}) async {
    dynamic response;

    try {
      if (method == HttpMethod.GET) {
        response = await this._get(endpoint, headers: headers, ignoreInterceptor: ignoreInterceptor, withHeaders: withHeaders, withResponseBytes: withResponseBytes);
      } else if (method == HttpMethod.POST) {
        response = await this._post(endpoint, body: body, headers: headers, ignoreInterceptor: ignoreInterceptor);
      } else if (method == HttpMethod.PUT) {
        response = await this._put(endpoint, body: body, headers: headers, ignoreInterceptor: ignoreInterceptor);
      } else if (method == HttpMethod.PATCH) {
        response = await this._patch(endpoint, body: body, headers: headers, ignoreInterceptor: ignoreInterceptor);
      } else if (method == HttpMethod.DELETE) {
        response = await this._delete(endpoint, body: body, headers: headers, ignoreInterceptor: ignoreInterceptor);
      } else {
        print('HttpMethod unknown!');
      }
    } catch (e) {
      if (e is DioError) {
        DioError dioError = e;
        print('Exception Dio => ${dioError.response}');

        if (dioError.response?.statusCode == 300) {
          // Multiple Choices
          return dioError.response?.data['data'];
        }
        dynamic dataResponse = dioError.response?.data ?? dioError.response;

        String? message = NetworkError.tratarErro(dioError, endpoint);

        print(endpoint);

        if (dataResponse != null) {
          print('message -> $message');
          throw new Exception(dataResponse);
        } else {
          throw new Exception('Erro desconhecido!');
        }
      } else {
        throw new Exception(ERROR_MESSAGE);
      }
    }

    return response;
  }

  Future<dynamic> _get(String endpoint, {Map<String, String>? headers, bool? ignoreInterceptor = false, bool withHeaders = false, bool withResponseBytes = false}) async {
    if (!await this.isConnected()) {
      throw new Exception(ERROR_CONNECTION_MESSAGE);
    }

    Response response = await (_dio!).get(
      endpoint,
      options: await this._getCustomConfig(headers, ignoreInterceptor!, responseBytes: withResponseBytes),
    );

    return this._generateResponse(response, withHeaders: withHeaders);
  }

  Future<dynamic> _post(String endpoint, {Map<String, String>? headers, body, bool? ignoreInterceptor = false}) async {
    if (!await this.isConnected()) {
      throw new Exception(ERROR_CONNECTION_MESSAGE);
    }

    Response response = await _dio!.post(
      endpoint,
      data: body,
      options: await this._getCustomConfig(headers, ignoreInterceptor!),
    );

    return this._generateResponse(response);
  }

  Future<dynamic> _put(String endpoint, {Map<String, String>? headers, body, bool? ignoreInterceptor = false}) async {
    if (!await this.isConnected()) {
      throw new Exception(ERROR_CONNECTION_MESSAGE);
    }

    Response response = await _dio!.put(
      endpoint,
      data: body,
      options: await this._getCustomConfig(headers, ignoreInterceptor),
    );
    return this._generateResponse(response);
  }

  Future<dynamic> _patch(String endpoint, {Map<String, String>? headers, body, bool? ignoreInterceptor = false}) async {
    if (!await this.isConnected()) {
      throw new Exception(ERROR_CONNECTION_MESSAGE);
    }

    Response response = await _dio!.patch(
      endpoint,
      data: body,
      options: await this._getCustomConfig(headers, ignoreInterceptor),
    );
    return this._generateResponse(response);
  }

  Future<dynamic> _delete(String endpoint, {Map<String, String>? headers, body, bool? ignoreInterceptor = false}) async {
    if (!await this.isConnected()) {
      throw new Exception(ERROR_CONNECTION_MESSAGE);
    }

    Response response = await _dio!.delete(
      endpoint,
      data: body,
      options: await this._getCustomConfig(headers, ignoreInterceptor),
    );
    return this._generateResponse(response);
  }

  Future<dynamic> customPost(String endpoint, {Map<String, dynamic>? headers, body, baseUrl}) async {
    if (!await this.isConnected()) {
      throw new Exception('Unknown error!');
    }

    Options options = Options();
    options.extra = {"ignoreInterceptor": true};
    options.headers = headers;
    //options.contentType = "multiple/form-data";


    Dio? customDio = _dio!;

    if (baseUrl.isNotEmpty) {
      customDio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 60000,
        receiveTimeout: 60000,
        sendTimeout: 60000,
      ));
    }

    customDio.interceptors.add(_dio!.interceptors.first);

    dynamic response;

    try {
      response = await customDio.post(
        endpoint,
        data: body,
        options: options,
      );
    } catch (e) {
      print("Exception Request => (POST) => $endpoint");
      print("Exception Request => (POST) => $e");
       if (e is DioError) {
        var dioError = e;
        print('Exception Dio => ${dioError.message}');
         String message = dioError.response != null ? dioError.response?.data['message'] : '';
        if (message.isNotEmpty) {
           throw new Exception(message);
         } else {
           throw new Exception('Unknown error!');
         }
       } else {
         throw new Exception(ERROR_MESSAGE);
       }
    }
    return response;
  }

  Future<dynamic> customGet(String endpoint, String baseUrl, bool ignoreInterceptor, {Map<String, String>? headers}) async {
    if (!await this.isConnected()) {
      throw new Exception(ERROR_CONNECTION_MESSAGE);
    }

    Dio? customDio = _dio!;

    if (baseUrl.isNotEmpty) {
      customDio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 60000,
        receiveTimeout: 60000,
        sendTimeout: 60000,
      ));
    }

    customDio.interceptors.add(_dio!.interceptors.first);

    dynamic response;
    try {
      response = await customDio.get(
        endpoint,
        options: await this._getCustomConfig(headers, ignoreInterceptor),
      );
    } catch (e) {
      print(e);
      print("Exception Request => (GET) => $endpoint");
      // print('Exception Headers => ${e.request.headers}');
      // print('Exception => ${e.response}');

      if (e is DioError) {
        var dioError = e;
        print('Exception Dio => ${dioError.message}');
        String message = dioError.response != null ? dioError.response!.data['message'] : '';
        if (message.isNotEmpty) {
          throw new Exception(message);
        } else {
           throw new Exception(ERROR_MESSAGE);
        }
      } else {
        throw new Exception(ERROR_MESSAGE);
      }
    }

    return response.data;
  }

  dynamic _generateResponse(Response? response, {bool withHeaders = false}) {
    if (response == null) {
      print('404 - Response null');
      throw new Exception(ERROR_MESSAGE);
    }

    final int statusCode = response.statusCode!;

    final decoded = response.data;

    if (statusCode < 200 || statusCode > 204) {
      if (decoded != null && decoded["data"] != null) {
        throw new Exception(decoded["data"]);
      }
      throw new Exception(ERROR_MESSAGE);
    }
    
    if (withHeaders) {
      return response;
    } else if (decoded is List) {
      return decoded;
    } else if (decoded is Map) {
      if (decoded["data"] != null) {
        return decoded["data"];
      } else if (decoded.isNotEmpty) {
        return decoded;
      } else {
        return null;
      }
    } else {
      return decoded;
    }
  }

  Future<Options?> _getCustomConfig(Map<String, String>? customHeader, bool? ignoreInterceptor, {bool responseBytes = false}) async {
    Options options = Options();
    options.extra = {'ignoreInterceptor': ignoreInterceptor};
    options.headers = await this._getDefaultHeader(customHeader);
    if(responseBytes){
      options.responseType = ResponseType.bytes;
    }
    return options;
  }

  Future<Map<String, String>> _getDefaultHeader(Map<String, String>? customHeader) async {
    Map<String, String> header = {"Content-Type": "application/json;charset=UTF-8"};

    if (customHeader != null) {
      header.addAll(customHeader);
    }

    return header;
  }

  /// ==========================================================
  /// Extras

  Future<bool> isConnected() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   return false;
    // } else {
    //   return true;
    // }
    return true;
  }

  Future<String> downloadStringFile(String url, String fileName) async {
    HttpClient httpClient = new HttpClient();

    String myUrl = '';
    String json = '';

    try {
      myUrl = url+fileName;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if(response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        json = utf8.decode(bytes);
      }
      else
        json = 'Error code: '+response.statusCode.toString();
    }
    catch(error){
      json = 'Can not fetch url';
    }
    return json;
  }
}
