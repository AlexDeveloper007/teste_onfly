import 'dart:convert';
import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:teste_onfly/api/login_api.dart';
import 'package:teste_onfly/model/user_model.dart';

part 'login_controller.g.dart';

class LoginController = _LoginController with _$LoginController;

abstract class _LoginController with Store {

  final _loginApi = LoginApi();

  UserModel? currentUser;

  Future<String> get token async {
    if(currentUser != null && currentUser!.token != null){
      return currentUser!.token!;
    }
    return "";
  }

  @observable
  bool loading = false;

  @action
  Future<bool?> login({required String identity, required String password}) async{
    loading = true;
    return await _loginApi.login(identity: identity, password: password).then((response) async {
      UserModel user = UserModel.map(response);
      user.login = identity;
      currentUser = user;
      print('user $user');
      loading = false;
      return true;
    }).catchError((e) {
      loading = false;
      return false;
    });
  }

}