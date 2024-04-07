import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:sample/utils/color_utils.dart';
import 'package:sample/utils/dimen_mixin.dart';

class DropdownWidget extends StatefulWidget {
  final Widget child;
  final List<Widget> childrenOfDropdown;
  final CustomPopupMenuController controller;
  final PressType pressType;
  final EdgeInsetsGeometry? contentPadding;
  final PreferredPosition? popupPosition;

  const DropdownWidget({
    super.key,
    required this.child,
    required this.childrenOfDropdown,
    required this.controller,
    this.pressType = PressType.singleClick,
    this.contentPadding,
    this.popupPosition,
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      menuBuilder: () {
        return Container(
          width: 160,
          decoration: BoxDecoration(
              border: Border.all(color: ColorUtils.white), borderRadius: BorderRadius.all(Dimen.checkBoxRadius), color: ColorUtils.white),
          child: Padding(
            padding: widget.contentPadding ?? EdgeInsets.symmetric(vertical: 14, horizontal: Dimen.marginX2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.childrenOfDropdown,
            ),
          ),
        );
      },
      pressType: widget.pressType,
      verticalMargin: Dimen.margin,
      controller: widget.controller,
      position: widget.popupPosition,
      arrowColor: ColorUtils.transparent,
      child: widget.child,
    );
  }
}

class _OnHover extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  const _OnHover({required this.builder});

  @override
  State<_OnHover> createState() => __OnHoverState();
}

class __OnHoverState extends State<_OnHover> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final hovered = Matrix4.identity()..translate(10, 0, 0);
    final transform = isHovered ? hovered : Matrix4.identity();
    return MouseRegion(
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: transform,
        child: widget.builder(isHovered),
      ),
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
