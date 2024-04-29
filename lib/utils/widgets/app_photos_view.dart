import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../generated_images.dart';
import '../color_utils.dart';
import '../image_asset.dart';
import '../text_style_utils.dart';
import 'ds_image_view.dart';

class AppPhotosView extends StatefulWidget {
  final List<String> images;
  final int selectedIndex;

  const AppPhotosView({
    super.key,
    required this.images,
    this.selectedIndex = 0,
  });

  Future show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return Container(
          color: const Color.fromRGBO(237, 237, 237, 0.60),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 16,
              sigmaY: 16,
            ),
            child: this,
          ),
        );
      },
    );
  }

  @override
  State<AppPhotosView> createState() => _AppPhotosViewState();
}

class _AppPhotosViewState extends State<AppPhotosView> {
  late int selectedIndex;
  late PageController _pageController;
  late CarouselController _thumbnailController;
  Timer? _onPointUpTimer;
  bool _isSwipePageViewManually = false;
  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    _pageController = PageController(initialPage: selectedIndex);
    _thumbnailController = CarouselController();
    Future.delayed(Duration.zero).then((value) {
      _thumbnailController.jumpToPage(selectedIndex);
    });
    super.initState();
  }

  @override
  void dispose() {
    _onPointUpTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _setFalseSwipePageViewManually() {
    _onPointUpTimer?.cancel();
    _onPointUpTimer = Timer(const Duration(milliseconds: 200), () {
      _isSwipePageViewManually = false;
    });
  }

  Widget _renderCloseIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: const AppImageAsset(
        IcSvg.icPhotoCloseIcon,
        width: 24,
        height: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: Listener(
              onPointerDown: (_) {
                _onPointUpTimer?.cancel();
                _onPointUpTimer = null;
                _isSwipePageViewManually = true;
              },
              onPointerUp: (_) {
                _setFalseSwipePageViewManually();
              },
              child: PhotoViewGallery.builder(
                pageController: _pageController,
                backgroundDecoration:
                    const BoxDecoration(color: Colors.transparent),
                builder: (context, index) {
                  final url = widget.images[index];
                  return PhotoViewGalleryPageOptions(
                      imageProvider: CachedNetworkImageProvider(url),
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 1.5,
                      filterQuality: FilterQuality.high,
                      heroAttributes: PhotoViewHeroAttributes(
                        tag: url,
                      ));
                },
                onPageChanged: (newIndex) {
                  //* We detect user swipe the page manually or not, because if we use animateToPage, the onPageChanged will call every index
                  if (_isSwipePageViewManually) {
                    onChangeSelectedIndex(
                      newIndex,
                      shouldUseThumbnailController: true,
                    );
                  }
                },
                itemCount: widget.images.length,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 36,
            child: _renderThumbnail(),
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: kToolbarHeight,
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 16,
                  child: _renderCloseIcon(context),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${selectedIndex + 1}/${widget.images.length}',
                    style: TextStyleUtils.headline4(color: ColorUtils.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onChangeSelectedIndex(
    int newIndex, {
    bool shouldUsePageImageController = false,
    bool shouldUseThumbnailController = false,
  }) {
    if (selectedIndex == newIndex) return;
    if (shouldUsePageImageController) {
      _pageController.animateToPage(newIndex,
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn);
    }
    if (shouldUseThumbnailController) {
      _thumbnailController.animateToPage(newIndex,
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn);
    }
    setState(() {
      selectedIndex = newIndex;
    });
  }

  Widget _renderThumbnail() {
    const size = 56.0;
    const spacing = 8.0;
    return CarouselSlider.builder(
      itemCount: widget.images.length,
      carouselController: _thumbnailController,
      itemBuilder: (context, index, realIndex) {
        final url = widget.images[index];
        final isSelected = selectedIndex == index;
        return Container(
          margin: const EdgeInsets.only(right: spacing),
          child: GestureDetector(
            onTap: () => onChangeSelectedIndex(
              index,
              shouldUsePageImageController: true,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? ColorUtils.primary3 : Colors.transparent,
                  width: 2,
                ),
              ),
              child: DSImageView(
                imageUrl: url,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: size,
        autoPlay: false,
        enableInfiniteScroll: false,
        viewportFraction: (size + spacing) / (ScreenUtil().screenWidth),
        onPageChanged: (index, reason) {
          // switch (reason) {
          //   case CarouselPageChangedReason.timed:
          //     break;
          //   case CarouselPageChangedReason.manual:
          //     onChangeSelectedIndex(
          //       index,
          //       shouldUsePageImageController: true,
          //     );
          //     break;
          //   default:
          //     break;
          // }
        },
      ),
    );
  }
}
