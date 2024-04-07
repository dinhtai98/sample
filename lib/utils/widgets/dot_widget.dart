import 'package:flutter/cupertino.dart';
import 'package:sample/utils/color_utils.dart';

class DotWidget extends StatelessWidget {
  final Color color;
  final Gradient? gradient;
  final double size;

  const DotWidget({
    super.key,
    this.color = ColorUtils.primary3,
    this.gradient,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        borderRadius: BorderRadius.circular(size / 2),
        gradient: gradient,
      ),
    );
  }
}
