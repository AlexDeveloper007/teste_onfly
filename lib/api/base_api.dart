
import 'package:teste_onfly/service/network_service.dart';

class ApiBase {
  final _network = NetworkService.instance;

  Future<dynamic> request(
    HttpMethod method,
    String endpoint, {
    Map<String, String>? headers,
    body,
    bool cacheFirst = false,
    bool ignoreInterceptor = false,
    bool withHeaders = false,
    bool withResponseBytes = false
  }) {
    return _network.request(method, endpoint, headers: headers, body: body, ignoreInterceptor: ignoreInterceptor, withHeaders: withHeaders, withResponseBytes: withResponseBytes).then((response) {
      return response;
    }).catchError((error) {
      throw (error);
    });
  }

  Future<dynamic> customGet(
    String url,
    String baseUrl,
    bool ignoreInterceptor,
    {Map<String, String>? headers}
    ) async {
    return _network.customGet(url, baseUrl, ignoreInterceptor);
  }

  Future<dynamic> downloadStringFile(
      String url,
      String baseUrl,
      ) async {
    return _network.downloadStringFile(baseUrl, url);
  }

  Future<dynamic> customPost(
    String endpoint, {
    String? baseUrl,
    Map<String, dynamic>? headers,
    body,
  }) {
    return _network
        .customPost(
      endpoint,
      headers: headers,
      baseUrl: baseUrl,
      body: body,
    )
        .then((response) async {
      return response;
    }).catchError((error) {
      throw (error);
    });
  }
}
