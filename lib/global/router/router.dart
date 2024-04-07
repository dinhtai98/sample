import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample/global/router/navigation_utils.dart';
import 'package:sample/ui/00_splash/splash_screen.dart';
import 'package:sample/ui/01_home/home.dart';
import 'package:sample/utils/select_image/select_images_view.dart';

class MyRouter {
  static const String splash = '/splash';
  static const String previewSelectImage = '/previewSelectImage';
  static const String home = '/home';

  static CupertinoPageRoute _buildCupertinoRouteNavigation(RouteSettings settings, Widget widget) {
    return CupertinoPageRoute(settings: settings, builder: (BuildContext context) => widget);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildCupertinoRouteNavigation(
          settings,
          const SplashScreen(),
        );
      case previewSelectImage:
        return _buildCupertinoRouteNavigation(
          settings,
          const PreviewSelectImage(),
        );
      case home:
        return _buildCupertinoRouteNavigation(
          settings,
          const HomeScreen(),
        );
      default:
        return _buildCupertinoRouteNavigation(
          settings,
          Scaffold(
            body: Center(
              child: Text('No route found: ${settings.name}.'),
            ),
          ),
        );
    }
  }

  static void onRouteChanged(String screenName) {
    NavigationUtils.currentPage = screenName;
    debugPrint(NavigationUtils.currentPage);
  }
}
