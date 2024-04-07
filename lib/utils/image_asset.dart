import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class AppImageAsset extends StatelessWidget {
  final String? assetName;

  /// If specified, the width to use for the SVG.  If unspecified, the SVG
  /// will take the width of its parent.
  final double? width;

  /// If specified, the height to use for the SVG.  If unspecified, the SVG
  /// will take the height of its parent.
  final double? height;

  /// How to inscribe the picture into the space allocated during layout.
  /// The default is [BoxFit.contain].
  final BoxFit fit;

  /// If non-null, this color is blended with each image pixel using [colorBlendMode].
  final Color? color;

  const AppImageAsset(
    this.assetName, {
    Key? key,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  const AppImageAsset.square(
    this.assetName, {
    super.key,
    this.color,
    this.fit = BoxFit.contain,
    required double size,
  })  : width = size,
        height = size;

  @override
  Widget build(BuildContext context) {
    if (assetName == null) {
      return const SizedBox();
    }
    if (assetName!.endsWith(".svg")) {
      return SvgPicture.asset(
        assetName!,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    } else {
      return Image.asset(
        assetName!,
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
    }
  }
}
