import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUIContainer extends StatelessWidget {
  final Widget? child;
  final Color? statusBarColor;
  final Brightness? statusBarIconBrightness;
  final Color? navBarColor;
  final Brightness? navBarIconBrightness;

  const SystemUIContainer({
    super.key,
    this.statusBarColor,
    this.statusBarIconBrightness,
    this.navBarColor,
    this.navBarIconBrightness,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: statusBarColor,
          statusBarIconBrightness: statusBarIconBrightness,
          systemNavigationBarColor: navBarColor,
          systemNavigationBarIconBrightness: navBarIconBrightness),
      child: child ?? const SizedBox(),
    );
  }
}
