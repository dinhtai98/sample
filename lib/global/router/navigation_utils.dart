import 'package:flutter/material.dart';

class NavigationUtils {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  // static final GlobalKey<NavigatorState> navigatorHomeKey =
  //     GlobalKey<NavigatorState>();
  static String currentPage = '';
  static BuildContext context = navigatorKey.currentContext!;

  static void pop() {
    if (navigatorKey.currentContext == null) return;
    Navigator.of(navigatorKey.currentContext!).pop();
  }

  static void pushNamed(String routeName, {Object? arguments}) {
    if (navigatorKey.currentContext == null) return;
    Navigator.of(navigatorKey.currentContext!).pushNamed(routeName, arguments: arguments);
  }
}
