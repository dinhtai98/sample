// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:sample/utils/color_utils.dart';
import 'package:sample/utils/dimen_mixin.dart';
import 'package:sample/utils/text_style_utils.dart';
enum ButtonSizeEnum {
  large,
  medium,
  small,
}

class CustomButton extends StatelessWidget {
  final String? text;
  final bool enable;
  final Color? borderColor;
  final double? width;
  final double? height;
  final Color? pressColor;
  final Function()? onTap;
  final TextStyle? textStyle;
  final Color? textColor;
  final ButtonSizeEnum? buttonSizeEnum;
  final bool outline;
  final Color? backgroundColor;
  final bool? isTextUnderline;
  final Widget? leadingWidget;
  final Widget? child;
  final bool isExpand;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    this.buttonSizeEnum = ButtonSizeEnum.large,
    this.text,
    this.enable = true,
    this.borderColor,
    this.width,
    this.height,
    this.pressColor,
    this.onTap,
    this.textStyle,
    this.textColor,
    this.outline = false,
    this.backgroundColor,
    this.isTextUnderline,
    this.leadingWidget,
    this.isExpand = true,
    this.padding,
    this.child,
  });

  BoxDecoration get decoration => outline
      ? BoxDecoration(
          color: backgroundColor ?? ColorUtils.white,
          borderRadius: BorderRadius.all(Dimen.buttonRadius),
          border: Border.all(
              color: borderColor ??
                  (enable ? ColorUtils.primary3 : ColorUtils.gray200)))
      : BoxDecoration(
          color: backgroundColor ?? (enable ? null : ColorUtils.gray100),
          gradient: backgroundColor != null
              ? null
              : (enable
                  ? const LinearGradient(
                      colors: ColorUtils.gr1Gradient3,
                    )
                  : null),
          borderRadius: BorderRadius.all(Dimen.buttonRadius),
        );

  @override
  Widget build(BuildContext context) {
    var heightValue = height;
    var splashColor =
        pressColor ?? (outline ? ColorUtils.primary10 : backgroundColor);
    var textStyleValue = textStyle;
    switch (buttonSizeEnum) {
      case ButtonSizeEnum.large:
        heightValue = Dimen.buttonLargeSize;
        textStyleValue ??= TextStyleUtils.button1_1();
        break;
      case ButtonSizeEnum.medium:
        heightValue = Dimen.buttonMediumSize;
        textStyleValue ??= TextStyleUtils.button2_1();
        break;
      default:
        heightValue = Dimen.buttonSmallSize;
        textStyleValue ??= TextStyleUtils.button3_1();
        break;
    }
    var colorOfText = textColor ??
        (enable
            ? (outline ? ColorUtils.primary1 : ColorUtils.white)
            : ColorUtils.gray500);
    return Container(
      width: width,
      height: heightValue,
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Dimen.buttonRadius),
        child: RawMaterialButton(
          onPressed: enable
              ? () {
                  onTap?.call();
                }
              : null,
          padding: padding ?? EdgeInsets.zero,
          splashColor: splashColor,
          child: child ??
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: isExpand ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  leadingWidget ?? const SizedBox.shrink(),
                  isTextUnderline != null && isTextUnderline!
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: colorOfText),
                            ),
                          ),
                          child: Text(
                            text ?? "",
                            style: TextStyle(
                                color: colorOfText,
                                fontSize: Dimen.textSize14,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Text(
                        text ?? "",
                        style: textStyle ??
                            TextStyle(
                                color: colorOfText,
                                fontSize: Dimen.textSize14,
                                fontWeight: FontWeight.w500),
                      ),
                ],
              ),
        ),
      ),
    );
  }
}

Widget iconButton({
  required IconData icon,
  double? size,
  required VoidCallback onPressed,
  Color color = Colors.white,
  double padding = 8.0,
  Color backgroundColor = Colors.transparent,
  Color? shadowColor,
}) {
  var defSize = size ?? Dimen.buttonIconSize;
  final iconSize = defSize - (padding * 2);
  Widget iconImage = Icon(
    icon,
    color: color,
    size: iconSize,
  );

  return Container(
    height: defSize,
    width: defSize,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.all(
        Radius.circular(defSize / 2),
      ),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 1,
          spreadRadius: 1,
          color: shadowColor ?? Colors.transparent,
        ),
      ],
    ),
    child: Center(
      child: GestureDetector(
        child: iconImage,
        onTap: () {
          onPressed();
        },
      ),
    ),
  );
}

Widget imageButton({
  String? image,
  double? size,
  required VoidCallback onPressed,
  Color backgroundColor = ColorUtils.gray400,
}) {
  const padding = 8.0;
  var defSize = size ?? Dimen.buttonIconSize;
  final iconSize = defSize - (padding * 2);
  Widget iconImage = image != null
      ? Image.asset(
          image,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.fill,
        )
      : const SizedBox();
  return Container(
    height: defSize,
    width: defSize,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.all(
        Radius.circular(defSize / 2),
      ),
      boxShadow: const [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 1,
          spreadRadius: 1,
          color: Colors.black12,
        ),
      ],
    ),
    child: Center(
      child: GestureDetector(
        child: iconImage,
        onTap: () {
          onPressed();
        },
      ),
    ),
  );
}
