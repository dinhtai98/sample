import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/utils/app_log.dart';
import 'image_slider_state.dart';

class ImageSliderCubit extends Cubit<ImageSliderState> {
  final String _tag = "ImageReviewBloc";
  PageController? pageController;
  List<String> imageList;
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;
  final double pageViewHeight = 248;
  BuildContext context;
  final Function(List<String>? imageList) onChangedImageList;

  ImageSliderCubit(
      {required this.context,
      required this.imageList,
      required this.onChangedImageList})
      : super(ImageSliderState()) {
    AppLog.d(_tag, "init");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var pageWidth = MediaQuery.of(context).size.width;

      /// Screen width - padding horizontal
      pageController =
          PageController(viewportFraction: pageViewHeight / pageWidth);
      // UserFullInfoDTO? user = locator<AppHive>().currentUser;
      // if (imageList.length < Res.maximumPersonality){
      //   imageList.addAll(List.filled(Res.maximumPersonality - imageList.length, ""));
      // }
      emit(state.copyWith(imageList: imageList));
    });
  }

  onTapPrev() {
    if (state.indexPage > 1) {
      pageController?.previousPage(duration: _kDuration, curve: _kCurve);
    }
  }

  onTapNext() {
    if (state.indexPage < imageList.length) {
      pageController?.nextPage(duration: _kDuration, curve: _kCurve);
    }
  }

  onPageChanged(int value) {
    AppLog.d(_tag, "onPageChanged $value");
    AppLog.d(_tag, "${MediaQuery.of(context).size}");
    emit(state.copyWith(indexPage: value));
  }

  double getScale(int index) {
    // double scale = (1 - (state.indexPage - index).abs().clamp(0.0, 1.0) * 0.17);
    double scale = index == state.indexPage ? 1 : 0.83;
    return scale;
  }

  onTapRemoveImage(int index) {
    List<String> imageList = state.imageList ?? [];
    imageList[index] = "";
    emit(state.copyWith(imageList: imageList));
    onChangedImageList(imageList);
  }
}
