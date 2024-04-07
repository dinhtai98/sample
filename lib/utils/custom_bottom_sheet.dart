import 'package:flutter/material.dart';
import 'package:sample/utils/color_utils.dart';
import 'package:sample/utils/dimen_mixin.dart';
import 'package:sample/utils/localization_utils.dart';

import 'text_style_utils.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  final double height;
  final bool haveShadow;
  final VoidCallback onTapDone;
  final VoidCallback onTapCancel;
  const CustomBottomSheet({
    super.key,
    required this.child,
    required this.height,
    required this.onTapDone,
    required this.onTapCancel,
    this.haveShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.only(top: 16, right: 20, bottom: 39, left: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Dimen.dialogRadius,
            topRight: Dimen.dialogRadius,
          ),
          color: ColorUtils.white,
          boxShadow: haveShadow
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]
              : []),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => onTapCancel(),
                child: Text(
                  LocalizationUtils.text?.cancel ?? '',
                  style: TextStyleUtils.button1()
                      .copyWith(color: ColorUtils.gray400),
                ),
              ),
              Dimen.marginX(Dimen.marginX2),
              GestureDetector(
                onTap: () => onTapDone(),
                child: Text(
                  LocalizationUtils.text?.complete ?? '',
                  style: TextStyleUtils.button1(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child
        ],
      ),
    );
  }
}
