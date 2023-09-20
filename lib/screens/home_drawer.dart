
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_onfly/controller/login_controller.dart';
import 'package:teste_onfly/model/user_model.dart';
import 'package:teste_onfly/screens/dev_info_screen.dart';
import 'package:teste_onfly/util/Strings.dart';
import 'package:teste_onfly/util/global.dart';

class HomeDrawer extends StatefulWidget {

  HomeDrawer();
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  final _loginController = GetIt.I<LoginController>();

  Widget _header() {
    return Observer(
      builder: (_){
        UserModel user = _loginController.currentUser!;
        return GestureDetector(
          onTap: (){},
          child: UserAccountsDrawerHeader(
            accountName: Text("${user.userName}"),
            accountEmail: Text("${Strings.DEV_EMAIL}"),
            currentAccountPicture:
            CircleAvatar(
              radius: 40,
              child: Image.asset("assets/images/avatar.png", ),
              backgroundColor: Colors.transparent,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    UserModel user = frwkLogin.currentUser!;
    double larguraTela = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Observer(
        builder: (_){
          return Container(
            width: larguraTela / 100 * 72,
            child: Drawer(
              child: ListView(
                children: [
                  _header(),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                    //trailing: Icon(Icons.arrow_forward),
                    onTap: (){
                      frwkNavigator.popNavigate();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text("Dev Info"),
                    //trailing: Icon(Icons.arrow_forward),
                    onTap: (){
                      frwkNavigator.popNavigate();
                      frwkNavigator.navigate(DevInfoScreen());
                    },
                  ),
                  SizedBox(height: 16,),
                  //banner logo
                  _bannerLogo(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _bannerLogo(){
    return  GestureDetector(
      onTap: (){},
      child: Container(
        margin: EdgeInsets.all(32),
        width: MediaQuery.of(context).size.width,
        //height: 84,
        child: Image.asset(
          "assets/images/onfly.png",
          //height: 64,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

}
