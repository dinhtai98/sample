import 'package:flutter/material.dart';

class NavigatorUtils {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static String currentPage = '';
  static BuildContext context = navigatorKey.currentContext!;

  static bool canPop() {
    return navigatorKey.currentState!.canPop();
  }

  static void pop<T extends Object?>([T? result]) {
    if (navigatorKey.currentState!.canPop()) {
      return navigatorKey.currentState!.pop<T>(result);
    }
  }

  static Future<bool> mayBePop<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.maybePop<T>(result);
  }

  static Future<T?> pushNamed<T extends Object?>(
      String routeName, {
        Object? arguments,
      }) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> push<T extends Object?>(Widget widget) {
    return navigatorKey.currentState!.push<T>(MaterialPageRoute<T>(builder: (BuildContext context) => widget));
  }

  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      String routeName, {
        TO? result,
        Object? arguments,
      }) {
    return navigatorKey.currentState!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  static Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
      String routeName, {
        TO? result,
        Object? arguments,
      }) {
    return navigatorKey.currentState!.popAndPushNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
      String newRouteName,
      RoutePredicate predicate, {
        Object? arguments,
      }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  static void popUntil<T extends Object?>(RoutePredicate predicate) {
    return navigatorKey.currentState!.popUntil(predicate);
  }
}
