
import 'package:teste_onfly/api/base_api.dart';
import 'package:teste_onfly/service/network_service.dart';

class LoginApi extends ApiBase {

  Future<dynamic> login({required String identity, required String password}) {
    Map body = {
      "identity": identity,
      "password": password
    };
    var header = <String, String>{'content-type': 'application/json'};
    return this.request(HttpMethod.POST, '/collections/users/auth-with-password', headers: header, body: body, ignoreInterceptor: true).then((response) {
      print("response $response");
      return response;
    }).catchError((error) {
      print("error ==> $error");
      throw (error);
    });
  }
}
