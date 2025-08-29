import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> pushNamed(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> pushReplacementNamed(String routeName, {Map<String, dynamic>? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

    static void goBack({dynamic result}) {
    navigatorKey.currentState!.pop(result);
  }

  static void showSnackBar(String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(navigatorKey.currentContext!);
    scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
  }
}
