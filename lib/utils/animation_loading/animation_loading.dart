import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:sample/utils/dimen_mixin.dart';
import 'package:sample/utils/status_bar_util.dart';

class AnimationLoading {
  LoadingOverlayEntry? overlayEntry;
  OverlayState? overlayState;

  factory AnimationLoading() => _instance;
  static final AnimationLoading _instance = AnimationLoading._internal();
  AnimationLoading._internal();

  static AnimationLoading get instance => _instance;
  Widget? get animationWidget => _animationWidget;
  Widget? _animationWidget;

  static show() async {
    dismiss();
    _instance._show();
  }

  static dismiss() {
    _instance._dismiss();
  }

  void _dismiss() {
    _animationWidget = null;
    _instance.overlayEntry?.markNeedsBuild();
  }

  void _show() {
    if (_instance.overlayEntry == null || _instance.overlayState == null) {
      return;
    }
    _animationWidget = Positioned.fill(
      child: BlurDialogContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/json/animation_loading.json',
                  width: 60,
                  height: 60,
                ),
                Dimen.box(Dimen.margin),
              ],
            ),
          ],
        ),
      ),
    );
    _instance.overlayEntry?.markNeedsBuild();
  }

  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, AnimationLoadingWidget(child: child));
      } else {
        return AnimationLoadingWidget(child: child);
      }
    };
  }
}

class AnimationLoadingWidget extends StatefulWidget {
  final Widget? child;

  const AnimationLoadingWidget({super.key, this.child});

  @override
  State<AnimationLoadingWidget> createState() => _AnimationLoadingWidgetState();
}

class _AnimationLoadingWidgetState extends State<AnimationLoadingWidget> {
  late LoadingOverlayEntry _overlayEntry;

  @override
  void initState() {
    _overlayEntry = LoadingOverlayEntry(builder: (BuildContext context) {
      AnimationLoading.instance.overlayState = Overlay.of(context);
      return AnimationLoading.instance.animationWidget ?? Container();
    });
    AnimationLoading.instance.overlayEntry = _overlayEntry;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Overlay(
        initialEntries: [
          LoadingOverlayEntry(
            builder: (BuildContext context) {
              if (widget.child != null) {
                return widget.child!;
              } else {
                return Container();
              }
            },
          ),
          _overlayEntry,
        ],
      ),
    );
  }
}

T? _ambiguate<T>(T? value) => value;

class LoadingOverlayEntry extends OverlayEntry {
  @override
  // ignore: overridden_fields
  final WidgetBuilder builder;

  LoadingOverlayEntry({
    required this.builder,
  }) : super(builder: builder);

  @override
  void markNeedsBuild() {
    if (_ambiguate(SchedulerBinding.instance)!.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      _ambiguate(SchedulerBinding.instance)!.addPostFrameCallback((_) {
        super.markNeedsBuild();
      });
    } else {
      super.markNeedsBuild();
    }
  }
}

class BlurDialogContainer extends StatelessWidget {
  final Widget child;
  final double sigma;
  final Color? statusBarColor;
  final Brightness? statusBarIconBrightness;
  final Color? navBarColor;
  final Brightness? navBarIconBrightness;

  const BlurDialogContainer({
    super.key,
    this.sigma = 7.0,
    required this.child,
    this.statusBarColor = Colors.transparent,
    this.statusBarIconBrightness = Brightness.dark,
    this.navBarColor,
    this.navBarIconBrightness,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SystemUIContainer(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarIconBrightness,
        navBarColor: navBarColor,
        navBarIconBrightness: navBarIconBrightness,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: sigma,
                  sigmaY: sigma,
                ),
                child: Container(color: Colors.transparent),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
