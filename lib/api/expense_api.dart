
import 'package:teste_onfly/api/base_api.dart';
import 'package:teste_onfly/model/expense_model.dart';
import 'package:teste_onfly/service/network_service.dart';

class ExpenseApi extends ApiBase {

  Future<dynamic> getExpense({
    required String login}) {

    String endpoint = "/collections/expense_$login/records";

    return this.request(HttpMethod.GET, endpoint).then((response) {
      print("response getExpense $response");
      return response;
    }).catchError((error) {
      throw (error);
    });
  }

  Future<dynamic> postExpense({
    required String login,
    required ExpenseModel expense}) {

    String endpoint = "/collections/expense_$login/records";

    return this.request(HttpMethod.POST, body: expense.toJson(), endpoint).then((response) {
      print("response postExpense $response");
      return response;
    }).catchError((error) {
      throw (error);
    });
  }

  Future<dynamic> patchExpense({
    required String login,
    required ExpenseModel expense}) {

    String endpoint = "/collections/expense_$login/records/${expense.id}";

    return this.request(HttpMethod.PATCH, body: expense.toJson(), endpoint).then((response) {
      print("response patchExpense $response");
      return response;
    }).catchError((error) {
      throw (error);
    });
  }

  Future<dynamic> deleteExpense({
    required String login,
    required ExpenseModel expense}) {

    String endpoint = "/collections/expense_$login/records/${expense.id}";

    return this.request(HttpMethod.DELETE, endpoint).then((response) {
      print("response deleteExpense $response");
      return response;
    }).catchError((error) {
      throw (error);
    });
  }
}
