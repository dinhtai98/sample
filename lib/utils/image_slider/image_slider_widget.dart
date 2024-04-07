import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/utils/color_utils.dart';
import 'package:sample/utils/widgets/dot_widget.dart';

import 'image_slider_cubit.dart';
import 'image_slider_state.dart';

class ImageSliderWidget extends StatelessWidget {
  final List<String>? imageList;
  final double aspectRatio;
  final int maximumImage = 10;
  final Function(List<String>? imageList) onChangedImageList;
  const ImageSliderWidget(
      {super.key,
      this.imageList,
      this.aspectRatio = 16 / 9,
      required this.onChangedImageList});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImageSliderCubit>(
      create: (context) => ImageSliderCubit(
          context: context,
          imageList: imageList ?? [],
          onChangedImageList: onChangedImageList),
      child: BlocBuilder<ImageSliderCubit, ImageSliderState>(
        builder: (context, state) {
          var bloc = context.read<ImageSliderCubit>();
          if (bloc.pageController != null) {
            return Column(
              children: [
                SizedBox(
                  height: bloc.pageViewHeight,
                  child: PageView.builder(
                    controller: bloc.pageController,
                    itemCount: 10,
                    onPageChanged: (value) => bloc.onPageChanged(value),
                    itemBuilder: (context, index) {
                      bool hasImage = (imageList?.length ?? 0) > index &&
                          imageList?[index].isNotEmpty == true;
                      return AnimatedScale(
                        scale: bloc.getScale(index),
                        duration: const Duration(milliseconds: 300),
                        child: hasImage
                            ? _HasImageWidget(
                                index: index,
                                url: state.imageList?[index] ?? "")
                            : _NoImageWidget(index: index),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: _indicatorWidgetList(state),
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  List<Widget> _indicatorWidgetList(ImageSliderState state) {
    List<Widget> indicators = [];
    for (int i = 0; i < 10; i++) {
      indicators.add(_IndicatorWidget(isSelected: i == state.indexPage));
    }
    return indicators;
  }
}

class _NoImageWidget extends StatelessWidget {
  final int index;

  const _NoImageWidget({required this.index});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => {},
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ColorUtils.gray200)),
          child: const Center(
              // child: AppImageAsset(IcSvg.icAdd),
              ),
        ),
      ),
    );
  }
}

class _HasImageWidget extends StatelessWidget {
  final int index;
  final String url;

  const _HasImageWidget({
    required this.index,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ImageSliderCubit>();
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              // errorWidget: (context, url, error) {
              //   return _NoImageWidget(index: index);
              // },
              height: 240, width: 240,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => cubit.onTapRemoveImage(index),
            child: Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _IndicatorWidget extends StatelessWidget {
  final bool isSelected;
  const _IndicatorWidget({this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return DotWidget(
        size: 8, color: isSelected ? ColorUtils.primary3 : ColorUtils.gray300);
  }
}
