import 'package:flutter/material.dart';
import 'package:sample/utils/color_utils.dart';
import 'package:sample/utils/dimen_mixin.dart';
import 'package:sample/utils/text_style_utils.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isSelected;
  final bool isOutline;
  final Function()? onTap;
  final double width;
  const CustomCheckBox({
    super.key,
    this.isSelected = false,
    this.onTap,
    this.isOutline = false,
    this.width = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          border: isSelected
              ? null
              : Border.all(width: width, color: ColorUtils.gray300),
          borderRadius: BorderRadius.all(Dimen.checkBoxRadius),
          color: isSelected
              ? ColorUtils.primary3
              : (isOutline ? ColorUtils.white : ColorUtils.gray300),
        ),
        child: const Icon(
          Icons.check,
          size: 16,
          color: ColorUtils.white,
        ),
      ),
    );
  }
}

class CustomCheckBoxTitle extends StatefulWidget {
  final bool isSelected;
  final bool isOutline;
  final Function(bool isSelected)? onTap;
  final String? title;
  const CustomCheckBoxTitle(
      {super.key,
      this.isSelected = false,
      this.onTap,
      this.isOutline = false,
      this.title});

  @override
  State<StatefulWidget> createState() {
    return _CustomCheckBoxTitleState();
  }
}

class _CustomCheckBoxTitleState extends State<CustomCheckBoxTitle> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onTap != null ? widget.onTap!(_isSelected) : null;
      },
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              border: _isSelected
                  ? null
                  : Border.all(width: 2, color: ColorUtils.gray300),
              borderRadius: BorderRadius.all(Dimen.checkBoxRadius),
              color: _isSelected
                  ? ColorUtils.primary3
                  : (widget.isOutline ? ColorUtils.white : ColorUtils.gray300),
            ),
            child: const Icon(
              Icons.check,
              size: 16,
              color: ColorUtils.white,
            ),
          ),
          if (widget.title != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  widget.title!,
                  style: TextStyleUtils.body2().copyWith(color: Colors.black),
                ),
              ),
            )
        ],
      ),
    );
  }
}
