import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample/generated_images.dart';
import 'package:sample/utils/color_utils.dart';
import 'package:sample/utils/image_asset.dart';
import 'package:sample/utils/string.dart';

typedef WrappedBuilder = Widget Function(
    BuildContext context, Widget child, String? url);

class DSImageView extends StatelessWidget {
  final double? height;
  final double? width;
  final String? imageUrl;
  final WrappedBuilder? wrappedBuilder;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final bool isAvatar;
  final WidgetBuilder? errorBuilder;
  final WidgetBuilder? loadingBuilder;
  final bool useMemCache;
  final Color? backgroundColor;
  const DSImageView({
    super.key,
    required this.height,
    required this.width,
    this.imageUrl,
    this.wrappedBuilder,
    this.fit,
    this.borderRadius,
    this.isAvatar = true,
    this.errorBuilder,
    this.loadingBuilder,
    this.useMemCache = true,
    this.backgroundColor,
  });

  double? get pixelRatio => ScreenUtil().pixelRatio;
  double? get size => width ?? height;
  double? get memCacheWidth {
    if (useMemCache) {
      if (width == double.infinity || width == null || pixelRatio == null) {
        return null;
      }
      return width! * pixelRatio!;
    }
    return null;
  }

  double? get memCacheHeight {
    if (useMemCache) {
      if (height == double.infinity || size == null || pixelRatio == null) {
        return null;
      }
      return height! * pixelRatio!;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorUtils.gray100,
        shape: BoxShape.rectangle,
        borderRadius: borderRadius,
      ),
      child: wrappedBuilder != null
          ? wrappedBuilder!(context, _renderContent(context), imageUrl)
          : _renderContent(context),
    );
  }

  Widget _renderContent(BuildContext context) {
    return imageUrl.notNullOrEmpty == true
        ? CachedNetworkImage(
            imageUrl: imageUrl ?? "",
            fit: fit ?? BoxFit.cover,
            memCacheHeight: memCacheHeight?.toInt(),
            memCacheWidth: memCacheWidth?.toInt(),
            errorWidget: (context, url, error) {
              return Container(
                color: ColorUtils.gray200,
                alignment: Alignment.center,
                child: const AppImageAsset(
                  IcPng.icPlaceDefaultImage,
                  width: 32,
                  height: 24,
                ),
              );
            },
            placeholder: (context, url) {
              return const CupertinoActivityIndicator();
            },
          )
        : loadingBuilder?.call(context) ?? const CupertinoActivityIndicator();
  }
}
