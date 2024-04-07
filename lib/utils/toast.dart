import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample/utils/color_utils.dart';
import 'package:sample/utils/dimen_mixin.dart';
import 'package:sample/utils/localization_utils.dart';
import 'package:sample/utils/text_style_utils.dart';

class ToastUtil {
  static const short = 1;
  static const long = 3;
  static OverlayState? overlayState;
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;
  static VoidCallback? _onFinish;
  static Timer? _timer;

  static void show(
    BuildContext context, {
    int? duration,
    int gravity = 0,
    Color background = const Color(0xAA000000),
    double backgroundRadius = 20,
    Border? border,
    bool? rootNavigator,
    Widget? child,
    VoidCallback? onFinish,
    bool ignoring = true,
    double? height = 50,
  }) async {
    dismiss();
    overlayState = Overlay.of(context, rootOverlay: rootNavigator ?? false);
    _onFinish = onFinish;
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => ToastWidget(
          ignoring: ignoring,
          widget: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(backgroundRadius),
                border: border,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: child,
            ),
          ),
          gravity: gravity),
    );
    _isVisible = true;
    overlayState!.insert(_overlayEntry!);
    _timer?.cancel();
    _timer = Timer(Duration(seconds: duration ?? short), () {
      if (_isVisible) {
        onFinish?.call();
        _onFinish = null;
      }
      dismiss();
    });
  }

  static dismiss() {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }

  static _executeOnFinish() {
    _onFinish?.call();
    _onFinish = null;
  }

  static dismissWithFinish() {
    _executeOnFinish();
    dismiss();
  }

  static void showTextToast(
    BuildContext context, {
    required String text,
    int duration = 2,
    bool isShowCancelCTA = false,
    VoidCallback? onFinish,
    VoidCallback? onCancel,
    double? height,
  }) {
    Widget renderOnTap({required Widget child}) {
      if (isShowCancelCTA) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            debugPrint('Prevent UI bottom pressed');
          },
          child: child,
        );
      }
      return child;
    }

    return ToastUtil.show(
      context,
      duration: duration,
      onFinish: onFinish,
      height: height,
      backgroundRadius: Dimen.margin,
      ignoring: !isShowCancelCTA,
      child: Container(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: renderOnTap(
                child: Text(
                  text,
                  style: TextStyleUtils.body2_1()
                      .copyWith(color: ColorUtils.white),
                ),
              ),
            ),
            if (isShowCancelCTA)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _onFinish = null;
                  dismiss();
                  onCancel?.call();
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    LocalizationUtils.text?.cancel ?? '',
                    style: TextStyleUtils.body2_1().copyWith(
                      color: ColorUtils.gray400,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class ToastWidget extends StatelessWidget {
  const ToastWidget({
    Key? key,
    required this.widget,
    required this.gravity,
    this.ignoring = true,
  }) : super(key: key);

  final Widget widget;
  final int? gravity;
  final bool ignoring;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: gravity == 2 ? MediaQuery.of(context).viewInsets.top + 50 : null,
      bottom: gravity == 0 ? MediaQuery.of(context).viewInsets.bottom + 50 : null,
      child: IgnorePointer(
        ignoring: ignoring,
        child: Material(
          color: Colors.transparent,
          child: widget,
        ),
      ),
    );
  }
}
