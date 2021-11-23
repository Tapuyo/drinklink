

import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/home/paymentsample.dart';
import 'package:driklink/pages/splash/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch (settings.name) {
      case Routes.splash:
        return CupertinoPageRoute(builder: (_) => SplashPage());
      case Routes.home:
        return CupertinoPageRoute(builder: (_) => HomePage());
      case Routes.payment:
        return CupertinoPageRoute(builder: (_) => PaymentSample());





      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
