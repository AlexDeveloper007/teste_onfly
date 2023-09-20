import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_onfly/controller/login_controller.dart';
import 'package:teste_onfly/screens/home_screen.dart';
import 'package:teste_onfly/util/ColorsUtil.dart';
import 'package:teste_onfly/util/dialog_util.dart';
import 'package:teste_onfly/util/global.dart';
import 'package:teste_onfly/util/metodos.dart';
import 'package:teste_onfly/util/snackbar_util.dart';
import 'package:teste_onfly/widgets/global_text_field_widget.dart';

import '../widgets/global_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _textEditingControllerLogin = TextEditingController();
  final _textEditingControllerSenha = TextEditingController();
  bool _viewPass = false;

  final _loginController = GetIt.I<LoginController>();

  String _errorLogin = "";
  String _errorPass = "";

  _init() async{
    _textEditingControllerLogin.text = "wx3bzw";
    _textEditingControllerSenha.text = "iYiMQdzt3N26kY9";
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: _buildBody()
    );
  }

  _buildBody() {
    return Observer(
        builder: (_) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: ContainerPlus(
                        padding: EdgeInsets.symmetric(horizontal: 64),
                        child: Image.asset(
                            'assets/images/onfly.png',
                            fit: BoxFit.contain
                        )
                    )
                ),
                ContainerPlus(
                  radius: RadiusPlus.all(12),
                  //color: Colors.black.withOpacity(0.1),
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlobalTextFieldWidget(
                        labelColor: ColorsUtil.PRIMARY_COLOR,
                        label: "Login",
                        radius: 10,
                        errorMessage: _errorLogin,
                        placeholder: "",
                        controller: _textEditingControllerLogin,
                        maxLength: 100,
                      ),
                      SizedBox(height: 24,),
                      GlobalTextFieldWidget(
                        labelColor: ColorsUtil.PRIMARY_COLOR,
                        label: "Senha",
                        obscureText: !_viewPass,
                        errorMessage: _errorPass,
                        radius: 10,
                        placeholder: "",
                        controller: _textEditingControllerSenha,
                        maxLength: 100,
                        suffixWidget: ContainerPlus(
                          margin: EdgeInsets.only(right: 4),
                          onTap: (){
                            if (_viewPass == false){setState((){_viewPass = true;});}
                            else{setState((){_viewPass = false;});}
                          },
                          child: Icon(
                            _viewPass ? Icons.visibility : Icons.visibility_off,
                            color: _viewPass ? ColorsUtil.PRIMARY_COLOR : ColorsUtil.GREY_COLOR,
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      GlobalButtonWidget(
                        textColor: Colors.white,
                        backgroundColor: ColorsUtil.PRIMARY_COLOR,
                        loading: _loginController.loading,
                        text: 'Entrar',
                        onPressed: () async{
                         if(await _validarDados()){
                           _loginController.loading = true;
                           await _loginController.login(identity: _textEditingControllerLogin.text, password: _textEditingControllerSenha.text);
                           if(frwkLogin.currentUser != null){
                             frwkNavigator.navigate(HomeScreen(), replace: true);
                           }
                         }
                        },
                        radius: 16,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 64),
              ],
            ),
          );
        }
    );
  }


  Future<bool> _validarDados() async{

    if(!await Metodos.hasNetwork()){
      DialogUtil.showError("Verifique sua conexão com a internet", titulo: "Sem conexão", svg: 'assets/svg/no_connection.svg', boxFit: BoxFit.fill, height: 104);
      return false;
    }

    _errorLogin = "";
    _errorPass = "";
    if(_textEditingControllerLogin.text.trim().isEmpty){
      _errorLogin = "Digite o login!";
    }

    if(_textEditingControllerSenha.text.trim().isEmpty){
      _errorPass = "Digite a senha!";
    }

    setState(() {});
    if(_errorLogin.trim().isNotEmpty || _errorPass.trim().isNotEmpty){
      SnackbarUtil.snackError("Preencha os dados de acesso!");
      return false;
    }else{
      return true;
    }
  }

}
