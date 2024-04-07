import 'package:flutter/cupertino.dart';

mixin Dimen {



  static bool get isTablet {
    final MediaQueryData data = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.single);
    return data.size.shortestSide >= 600;
  }

  static ScreenType screenType = ScreenType.regular;
  static late MediaQueryData mediaQuery;

  static Size get screenSize => mediaQuery.size;

  static double get screenWidth => screenSize.width;

  static double get screenHeight => screenSize.height;

  static EdgeInsets get viewInsets => mediaQuery.viewInsets;

  static void detectScreen(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    double ratio = screenWidth / screenHeight;
    if (ratio >= 0.78) {
      screenType = ScreenType.tablet;
    } else if (ratio <= 0.45) {
      screenType = ScreenType.foldOut;
    } else {
      screenType = ScreenType.regular;
    }
  }

  static int count(int def, {int tab = 0, int fo = 0}) {
    if (screenType == ScreenType.regular) {
      return def;
    }
    if (screenType == ScreenType.tablet && tab != 0) {
      return tab;
    }
    if (screenType == ScreenType.foldOut && fo != 0) {
      return fo;
    }
    return def;
  }

  static double dimen(double def, {double? tab, double? fo}) {
    if (screenType == ScreenType.regular) return def;
    if (screenType == ScreenType.tablet) return tab ?? (def * 1.10);
    if (screenType == ScreenType.foldOut && fo != 0) return fo ?? (def * 0.90);
    return def;
  }

  static double ratio(double def, {double? tab, double? fo}) {
    if (screenType == ScreenType.regular) return def;
    if (screenType == ScreenType.tablet) return tab ?? def;
    if (screenType == ScreenType.foldOut && fo != 0) return fo ?? def;
    return def;
  }

  static double text(double def, {double? tab, double? fo}) {
    if (screenType == ScreenType.regular) return def;
    if (screenType == ScreenType.tablet) return tab ?? (def * 1.05);
    if (screenType == ScreenType.foldOut && fo != 0) return fo ?? (def * 0.95);
    return def;
  }

  static Radius radius(double def, {double? tab, double? fo}) {
    return Radius.circular(dimen(def, tab: tab, fo: fo));
  }

  static Widget box(double padding) {
    return SizedBox.square(dimension: padding);
  }

  static Widget expand() => const Expanded(child: SizedBox());

  static Widget marginX(double padding) {
    return Padding(padding: EdgeInsets.only(left: padding));
  }

  static Widget marginY(double padding) {
    return Padding(padding: EdgeInsets.only(top: padding));
  }

  static double get marginD4 => margin * 0.25;

  static double get marginD2 => margin * 0.5;

  static double get margin => dimen(8, tab: 10, fo: 6.5);

  static double get marginX1_5 => margin * 1.5;

  static double get marginX2 => margin * 2;

  static double get marginX2_5 => margin * 2.5;

  static double get marginX3 => margin * 3;

  static double get marginX4 => margin * 4;

  static double get marginX5 => margin * 5;

  static double get marginX6 => margin * 6;

  static double get marginX8 => margin * 8;

  static double get textSize28 => text(28);

  static double get textSize24 => text(24);

  static double get textSize22 => text(22);

  static double get textSize20 => text(20);

  static double get textSize18 => text(18);

  static double get textSize16 => text(16);

  static double get textSize14 => text(14);

  static double get textSize12 => text(12);

  static double get textSize10 => text(10);

  static double get textSize8 => text(8);

  static double get textSize7 => text(7);

  static Radius get itemRadius => radius(12);

  static Radius get dialogRadius => radius(24);

  static Radius get popupRadius => radius(16);

  static Radius get buttonRadius => radius(24);

  static Radius get processRadius => radius(4);

  static Radius get checkBoxRadius => radius(8);

  static double get buttonLargeSize => dimen(48);

  static double get buttonMediumSize => dimen(40);

  static double get buttonSmallSize => dimen(32);

  static double get buttonNoteRadius => dimen(50.0);

  static double get itemImageRadius => dimen(8);

  static Radius get itemImageRadiusX2 => radius(16);

  static double get buttonIconSize => dimen(20);

  static double get iconButtonSize => dimen(24);

  static double get iconSize => dimen(16);

  static Radius get chatBubbleRadius => radius(8);

  static double get textFieldHeight => dimen(40);

  static Radius get textFieldRadius => radius(16);

  static double get textFieldIcon => dimen(24);

  static double get imageSize => dimen(64);

  static get splashIcon => dimen(240);
  static const double margin6 = 6;
  static const double margin10 = 10;
  static const double margin12 = 12;
  static const double margin14 = 14;
  static const double margin20 = 20;
  static const double margin28 = 28;
  static const double margin40 = 40;
  static const double margin52 = 52;
  static const double margin55 = 55;
  static const double margin60 = 60;
  static const double margin70 = 70;
  static const double margin80 = 80;
  static const double margin84 = 84;

  static get notifyWidgetRadius => dimen(20);

  static const bioInputLength = 75;

  static const referralCodeInputLength = 8;

  static double get keywordItemHeight => Dimen.dimen(36);

  static double get portraitWidth =>
      Dimen.screenWidth * (Dimen.isTablet ? 0.47 : 1);

  static double get userCardRadius => Dimen.dimen(20);

  static double get userItemHeight => Dimen.dimen(68);

  static double get progressSize => dimen(24, fo: 18);

  static double get appBarButtonSize => dimen(46);

  static double get appBarIconSize => appBarButtonSize * 0.6;
}

enum ScreenType { regular, tablet, foldOut }
