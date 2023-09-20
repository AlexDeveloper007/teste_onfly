
import 'package:dio/dio.dart';

class NetworkError{

  static String? tratarErro(DioError dioError, String endpoint){

    String message = "GLOBAL.ERROR.UNKNOWN";
    String titulo = "GLOBAL.LABEL.ERROR";
    String linkSvg = 'assets/svg/img_erro.svg';
    int? statusCode = dioError.response?.statusCode;
    String? codigo;
    if (!(dioError.response?.data is String)) {
      codigo = dioError.response?.data["codigo"].toString() ?? "";
      message = dioError.response?.data["mensagem"].toString() ?? "";
      print(message);
    }
    return message;
  }
}