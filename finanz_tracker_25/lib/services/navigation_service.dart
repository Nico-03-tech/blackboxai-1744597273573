import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  static void goBack() {
    return navigatorKey.currentState!.pop();
  }

  static void navigateToReplacement(String routeName, {Object? arguments}) {
    navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }
}

class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String einnahmen = '/einnahmen';
  static const String ausgaben = '/ausgaben';
  static const String schulden = '/schulden';
  static const String dokumente = '/dokumente';
}
