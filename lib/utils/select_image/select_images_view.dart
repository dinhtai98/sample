// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:sample/global/router/navigation_utils.dart';
import 'package:sample/global/router/router.dart';
import 'package:sample/utils/collection.dart';
import 'package:sample/utils/color_utils.dart';
import 'package:sample/utils/dimen_mixin.dart';
import 'package:sample/utils/display.dart';
import 'package:sample/utils/localization_utils.dart';
import 'package:sample/utils/res.dart';
import 'package:sample/utils/select_image/select_images_cubit.dart';
import 'package:sample/utils/text_style_utils.dart';
import 'package:sample/utils/widgets/appbar.dart';

class ImagesListPage extends StatefulWidget {
  ///Handle cache image data from [SelectImagesCubit] before [ImagesListPage] close
  final Function(List<Medium>)? cacheData;
  const ImagesListPage({super.key, this.cacheData});

  @override
  State<ImagesListPage> createState() => _ImagesListPageState();
}

class _ImagesListPageState extends State<ImagesListPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  var expandView = ValueNotifier<bool>(false);
  late final AnimationController _animationShowPhotoAndCameraButtonController =
      AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
  late Animation<double> sizeAnimation =
      Tween<double>(begin: 320, end: 550).animate(CurvedAnimation(
    parent: _animationShowPhotoAndCameraButtonController,
    curve: Curves.easeIn,
  ));
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Future.sync(() async {
        var isGranted = await context.read<SelectImagesCubit>().promptPermissionSetting();
        if (isGranted) Future.sync(() => context.read<SelectImagesCubit>().getImageAndAlbum());
      });
    });
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<SelectImagesCubit>().loadMoreMedia();
    }
  }

  @override
  void dispose() {
    expandView.dispose();
    _scrollController.dispose();
    _animationShowPhotoAndCameraButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationShowPhotoAndCameraButtonController,
        builder: (context, _) {
          return Container(
            height: sizeAnimation.value,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorUtils.white,
              borderRadius: BorderRadius.only(
                  topLeft: Dimen.buttonRadius, topRight: Dimen.buttonRadius),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 7,
                    offset: const Offset(0, -3)),
                const BoxShadow(color: Colors.white, offset: Offset(0, 3)),
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 7,
                    offset: const Offset(-3, -3)),
                const BoxShadow(color: Colors.white, offset: Offset(-3, 3)),
              ],
            ),
            child: Column(
              children: [
                BlocBuilder<SelectImagesCubit, SelectImagesState>(
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimen.marginX2),
                      child: GestureDetector(
                        onVerticalDragUpdate: (details) {
                          int sensitivity = 5;
                          if (details.delta.dy < -sensitivity) {
                            _animationShowPhotoAndCameraButtonController
                                .forward();
                          }
                          if (details.delta.dy > sensitivity) {
                            _animationShowPhotoAndCameraButtonController
                                .reverse();
                          }
                        },
                        dragStartBehavior: DragStartBehavior.down,
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton<Album>(
                                value: state.currentAlbum,
                                underline: Container(
                                  height: 0,
                                  color: ColorUtils.white,
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: state.albumList.map((Album album) {
                                  return DropdownMenuItem<Album>(
                                    value: album,
                                    child: Text(
                                      album.name ?? '',
                                      style: TextStyleUtils.button1(),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (album) {
                                  if (album != null) {
                                    context.read<SelectImagesCubit>().changeAlbum(album);
                                  }
                                },
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context.read<SelectImagesCubit>().onResetData();
                                      NavigationUtils.pop();
                                    },
                                    child: Text(
                                        LocalizationUtils.text?.cancel ?? '',
                                        style: TextStyleUtils.button1().copyWith(color: ColorUtils.gray400)),
                                  ),
                                  Dimen.marginX(Dimen.margin),
                                  InkWell(
                                      onTap: () {
                                        widget.cacheData?.call(context.read<SelectImagesCubit>().state.selectedImages);
                                        NavigationUtils.pop();
                                        NavigationUtils.pop();
                                      },
                                      child: Text(
                                          LocalizationUtils.text?.complete ?? '',
                                          style: state.selectedImages.isNullOrEmpty
                                              ? TextStyleUtils.button1().copyWith(color: ColorUtils.gray400)
                                              : TextStyleUtils.button1()
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: BlocBuilder<SelectImagesCubit, SelectImagesState>(
                    builder: (context, state) {
                      if (state.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state.media.isNullOrEmpty) {
                        return const SizedBox.shrink();
                      }

                      return GridView.builder(
                        controller: _scrollController,
                        itemCount: state.media.length + 1,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 1.0,
                          crossAxisSpacing: 1.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == state.media.length) {
                            return state.loadingMore
                                ? const Center(child: CircularProgressIndicator())
                                : const SizedBox.shrink();
                          } else {
                            var medium = state.media[index];
                            return GestureDetector(
                              onTap: () {
                                context.read<SelectImagesCubit>().selectedImage(medium);
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  FadeInImage(
                                    fit: BoxFit.cover,
                                    placeholder: MemoryImage(Res.kTransparentImage),
                                    image: ThumbnailProvider(
                                      mediumId: medium.id,
                                      mediumType: medium.mediumType,
                                      highQuality: true,
                                    ),
                                  ),
                                  Positioned(
                                      right: 10,
                                      top: 10,
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(width: 1.5, color: ColorUtils.white),
                                            color: state.selectedImages.contains(medium)
                                                ? ColorUtils.primary3
                                                : Colors.transparent),
                                      ))
                                ],
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
    );
  }
}

class PreviewSelectImage extends StatelessWidget {
  const PreviewSelectImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(showBack: true),
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<SelectImagesCubit, SelectImagesState>(
              builder: (context, state) {
                if (state.selectedImages.isNullOrEmpty) {
                  return SizedBox(
                    height: context.height / 2,
                    width: context.width,
                  );
                }
                return SizedBox(
                  width: context.width,
                  height: context.height,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: context.height - 320,
                        width: context.width,
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: MemoryImage(Res.kTransparentImage),
                          image: ThumbnailProvider(
                            mediumId: state.selectedImages.last.id,
                            mediumType:
                            state.selectedImages.last.mediumType,
                            highQuality: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(width: context.width, child: const ImagesListPage()),
            )
          ],
        ),
      ),
    );
  }
}
