import 'package:flutter/material.dart';

class NavigatorController {
  factory NavigatorController() => _instance;
  static final _instance = NavigatorController.internal();

  NavigatorController.internal();

  static NavigatorController get instance => NavigatorController._instance;

  late GlobalKey<NavigatorState> _navigatorKey;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  BuildContext get currentContext => _navigatorKey.currentState!.overlay!.context;

  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  void navigate(dynamic destination, {bool? modal, bool? replace, bool? maintainState, String? name}) {
    if (replace != null && replace == true) {
      _navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (context) => destination, fullscreenDialog: modal ?? false, maintainState: maintainState ?? true),
      );
    } else {
      _navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => destination,
          fullscreenDialog: modal ?? false,
          maintainState: maintainState ?? true,
          settings: RouteSettings(
            name: name,
          ),
        ),
      );
    }
  }

  Future<dynamic> navigateFuture(dynamic destination, {bool? modal, bool? replace, bool? maintainState}) async {
    if (replace != null && replace == true) {
      return await _navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (context) => destination, fullscreenDialog: modal ?? false, maintainState: maintainState ?? true),
      );
    } else {
      return await _navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (context) => destination, fullscreenDialog: modal ?? false, maintainState: maintainState ?? true),
      );
    }
  }

  void popNavigate() {
    if (_navigatorKey.currentState!.canPop()) {
      _navigatorKey.currentState!.pop();
    }
  }

  void popToRoot() {
    if (_navigatorKey.currentState!.canPop()) {
      _navigatorKey.currentState!.popUntil((Route<dynamic> route) => route.isFirst);
    }
  }

  void pushReplacement(BuildContext context, Widget tela) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => tela));
  }

  void popUntil(String routeName) {
    if (_navigatorKey.currentState!.canPop()) {
      _navigatorKey.currentState!.popUntil((route) {
        //print("log: ${route.settings.name}"); 
        return route.settings.name == routeName;
      });
    }
  }

  // ignore: always_declare_return_types
  showBottomSheet(
    dynamic child, {
    Function? closed,
    Color? backgroundColor,
    bool isDismissible = true,
  }) {
    var modal = showModalBottomSheet(
      context: currentContext,
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return child;
      },
    );
    modal.then((value) {
      // print('bottomSheetController: $value');
      if (closed != null) {
        closed();
      }
    });
  }
}
