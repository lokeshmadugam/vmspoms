import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/utils/routes/routes_name.dart';

import '../../view/LoginScreen.dart';
import '../../view/SplashScreen.dart';

import '../../view/bottomnvgbar/BottomNavigationBarScreen.dart';

class Routes {
  //settings accept string parameter
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => BottomNavigationBarScreen());
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen());
      // case RoutesName.register:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) =>  const SignUpView());
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => Scaffold(
                  body: Center(
                    child: Text("No route defined"),
                  ),
                ));
    }
  }
}
