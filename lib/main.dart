import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:teste_onfly/controller/expense_controller.dart';
import 'package:teste_onfly/controller/login_controller.dart';
import 'package:teste_onfly/controller/navigator_controller.dart';
import 'package:teste_onfly/screens/login_screen.dart';
import 'package:teste_onfly/screens/new_expense_screen.dart';
import 'package:teste_onfly/util/ColorsUtil.dart';
import 'package:teste_onfly/util/Strings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocators();
  runApp(MyApp());
}

void setUpLocators() {
  GetIt.I.registerSingleton(LoginController());
  GetIt.I.registerSingleton(NavigatorController());
  GetIt.I.registerSingleton(ExpenseController());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  void initState() {
    GetIt.I<NavigatorController>().setNavigatorKey(_navigatorKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterAppPlus(
      debugShowCheckedModeBanner: false,
      title: Strings.APP_NAME,
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: ColorsUtil.PRIMARY_COLOR,
        backgroundColor: Colors.white,
      ),
      //home: LoginScreen(),
      home: LoginScreen(),
    );
  }
}
