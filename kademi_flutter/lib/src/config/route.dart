import 'package:flutter/material.dart';
import 'package:kademi_app/src/pages/login_page.dart';
import '../pages/main_page.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      '/mainPage': (_) => MainPage(),
      '/login': (_) => LoginPage(),
    };
  }
}
