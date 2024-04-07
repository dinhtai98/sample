import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample/generated_images.dart';
import 'package:sample/utils/color_utils.dart';
import 'package:sample/utils/dimen_mixin.dart';
import 'package:sample/utils/image_asset.dart';
import 'package:sample/utils/text_style_utils.dart';

// ignore: constant_identifier_names
const double APPBAR_HEIGHT = 56;

class PrimaryAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? centerWidget;
  final Alignment alignmentTitle;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool showBack;
  final TextStyle? titleStyle;
  final VoidCallback? onPop;
  final Color bgColor;
  final EdgeInsetsGeometry? paddingTitle;
  final bool topSafeArea;
  final EdgeInsets? padding;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const PrimaryAppBar({
    super.key,
    this.title,
    this.suffixIcon,
    this.prefixIcon,
    this.showBack = true,
    this.onPop,
    this.titleStyle,
    this.alignmentTitle = Alignment.center,
    this.bgColor = ColorUtils.white2,
    this.paddingTitle,
    this.centerWidget,
    this.topSafeArea = true,
    this.padding,
    this.systemOverlayStyle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(APPBAR_HEIGHT);

  @override
  State<StatefulWidget> createState() {
    return _PrimaryAppBarState();
  }
}

class _PrimaryAppBarState extends State<PrimaryAppBar> {
  Widget _renderSystemOverlayStyle({required Widget child}) {
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final ThemeData theme = Theme.of(context);
    final Set<MaterialState> states = <MaterialState>{};
    final backgroundColor = _resolveColor(
      states,
      widget.bgColor,
      appBarTheme.backgroundColor,
    );
    final overlayStyle = widget.systemOverlayStyle ??
        appBarTheme.systemOverlayStyle ??
        _systemOverlayStyleForBrightness(
          ThemeData.estimateBrightnessForColor(
              backgroundColor ?? widget.bgColor),
          // Make the status bar transparent for M3 so the elevation overlay
          // color is picked up by the statusbar.
          theme.useMaterial3 ? const Color(0x00000000) : null,
        );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: child,
    );
  }

  Color? _resolveColor(
      Set<MaterialState> states, Color? widgetColor, Color? themeColor) {
    return MaterialStateProperty.resolveAs<Color?>(widgetColor, states) ??
        MaterialStateProperty.resolveAs<Color?>(themeColor, states);
  }

  SystemUiOverlayStyle _systemOverlayStyleForBrightness(Brightness brightness,
      [Color? backgroundColor]) {
    final SystemUiOverlayStyle style = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    // For backward compatibility, create an overlay style without system navigation bar settings.
    return SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      statusBarBrightness: style.statusBarBrightness,
      statusBarIconBrightness: style.statusBarIconBrightness,
      systemStatusBarContrastEnforced: style.systemStatusBarContrastEnforced,
    );
  }

  Widget _renderSafeArea({required Widget child}) {
    return SafeArea(
      top: widget.topSafeArea,
      bottom: false,
      left: false,
      right: false,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _renderSystemOverlayStyle(
      child: Container(
        padding: widget.padding ??
            EdgeInsets.only(left: Dimen.marginX2, right: Dimen.marginX2),
        color: widget.bgColor,
        child: _renderSafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Row(
                      children: [
                        widget.showBack
                            ? InkWell(
                                onTap: widget.onPop ??
                                    () => Navigator.of(context).pop(),
                                child: const Padding(
                                  padding: EdgeInsets.all(5),
                                  child: AppImageAsset(IcSvg.icBack),
                                ),
                              )
                            : const SizedBox(),
                        widget.prefixIcon ?? const SizedBox()
                      ],
                    ),
                    Align(
                      alignment: widget.alignmentTitle,
                      child: Padding(
                        padding: widget.paddingTitle ??
                            EdgeInsets.symmetric(horizontal: Dimen.marginX4),
                        child: widget.centerWidget ??
                            Text(
                              widget.title ?? "",
                              style: widget.titleStyle ??
                                  TextStyleUtils.headline4(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widget.suffixIcon ?? const SizedBox(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverPrimaryAppBar extends StatelessWidget {
  final Widget child;
  const SliverPrimaryAppBar({super.key, required this.child});

  NestedScrollViewHeaderSliversBuilder builder() {
    return (BuildContext context, bool innerBoxIsScrolled) {
      return [this];
    };
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorUtils.white2,
      pinned: false,
      floating: true,
      automaticallyImplyLeading: false,
      centerTitle: false,
      elevation: 0,
      titleSpacing: 0,
      title: child,
      systemOverlayStyle: const SystemUiStyle.light(),
    );
  }
}

class SuffixIconMoreVert extends StatelessWidget {
  final Function() onTap;

  const SuffixIconMoreVert({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const SizedBox(
        width: 24,
        height: 24,
        child: Icon(
          Icons.more_vert,
          size: 24,
          color: ColorUtils.gray500,
        ),
      ),
    );
  }
}

class SystemUiStyle extends SystemUiOverlayStyle {
  const SystemUiStyle({
    super.statusBarIconBrightness,
    super.statusBarColor,
    Brightness? navBarIconBrightness,
    Color? navBarColor,
  }) : super(
          systemNavigationBarIconBrightness: navBarIconBrightness,
          systemNavigationBarColor: navBarColor,
        );

  const SystemUiStyle.light({
    Color? statusBarColor,
    Brightness? statusBarIconBrightness,
    Color? navBarColor,
    Brightness? navBarIconBrightness,
  }) : super(
          statusBarColor: statusBarColor ?? ColorUtils.white2,
          statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
          systemNavigationBarColor: navBarColor ?? ColorUtils.white2,
          systemNavigationBarIconBrightness:
              navBarIconBrightness ?? Brightness.dark,
        );

  const SystemUiStyle.transparent({
    Color? statusBarColor,
    Brightness? statusBarIconBrightness,
    Color? navBarColor,
    Brightness? navBarIconBrightness,
  }) : super(
          statusBarColor: statusBarColor ?? Colors.transparent,
          statusBarIconBrightness: statusBarIconBrightness ?? Brightness.light,
          systemNavigationBarColor: navBarColor ?? Colors.transparent,
          systemNavigationBarIconBrightness:
              navBarIconBrightness ?? Brightness.light,
        );

  const SystemUiStyle.gray({
    Color? statusBarColor,
    Brightness? statusBarIconBrightness,
    Color? navBarColor,
    Brightness? navBarIconBrightness,
  }) : super(
          statusBarColor: statusBarColor ?? ColorUtils.gray50,
          statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
          systemNavigationBarColor: navBarColor ?? ColorUtils.gray50,
          systemNavigationBarIconBrightness:
              navBarIconBrightness ?? Brightness.dark,
        );

  void set() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SystemChrome.setSystemUIOverlayStyle(this);
    });
  }
}
