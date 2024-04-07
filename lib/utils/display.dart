import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample/utils/color_utils.dart';

extension DisplayExtension on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;

  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isPortrait => orientation == Orientation.portrait;

  FlutterView get flutterView => View.of(this);

  double get screenWidthPx => flutterView.physicalSize.width;

  double get screenHeightPx => flutterView.physicalSize.height;

  double get statusBarHeight => MediaQuery.viewPaddingOf(this).top;

  double get bottomSafeArea => MediaQuery.viewPaddingOf(this).bottom;

  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;

  double get height => screenSize.height;

  double get width => screenSize.width;

  double pixelToDip(double pixel) {
    final media = MediaQuery.of(this);
    return pixel / media.devicePixelRatio;
  }

  double dipToPixel(double dip) {
    final media = MediaQuery.of(this);
    return dip * media.devicePixelRatio;
  }

  bool hideKeyBoard() {
    return false;
    // if (MediaQuery.of(this).viewInsets.bottom > 0.0) {
    //   SystemChannels.textInput.invokeMethod('TextInput.hide');
    // }
    // return false;
  }

  void hideSafeKeyboard() {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (_) {}
  }

  void setOnlyPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

Future setStatusBarColor(Color color) async {
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: color,
    systemNavigationBarColor: color,
    statusBarIconBrightness: Brightness.dark,
    // ios
    statusBarBrightness: Brightness.light,
  ));
}

darkStatusBar({Color? color, Color? navigationBarColor}) {
  SystemChrome.setEnabledSystemUIMode(
    //SystemUiMode.immersiveSticky,
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.bottom],
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: color ?? ColorUtils.primary10,
    systemNavigationBarColor: navigationBarColor ?? ColorUtils.primary10,

    // ios
    statusBarBrightness: Brightness.dark,
  ));
}

void lightStatusBar({Color? color, Color? navigationBarColor}) {
  SystemChrome.setEnabledSystemUIMode(
    //SystemUiMode.immersiveSticky,
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.bottom],
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: color ?? Colors.white,
    systemNavigationBarColor: navigationBarColor ?? ColorUtils.white,
    statusBarIconBrightness: Brightness.dark,
// ios
    statusBarBrightness: Brightness.light,
  ));
}

Container lightAppBar(List<Widget> children) {
  return Container(
    height: 56,
    color: Colors.white,
    child: Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
        verticalSeparator(size: 2),
      ],
    ),
  );
}

const verticalColor = Color(0xFFF2F4F7);

Widget verticalSeparator({double size = 1, Color? color, double? padding}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: padding ?? 0),
    child: Container(
      color: color ?? const Color(0xFFF2F4F7),
      height: size,
    ),
  );
}
