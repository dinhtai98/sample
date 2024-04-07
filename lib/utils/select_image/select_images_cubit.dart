import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:sample/global/router/navigation_utils.dart';
import 'package:sample/utils/collection.dart';
import 'package:sample/utils/dialog.dart';
import 'package:sample/utils/localization_utils.dart';
import 'package:sample/utils/native_utils.dart';
import 'package:sample/utils/res.dart';

part 'select_images_state.dart';

class SelectImagesCubit extends Cubit<SelectImagesState> {
  SelectImagesCubit() : super(SelectImagesState());
  int _maximumImages = Res.maximumAvatar;

  Future getImageAndAlbum() async {
    var imageAlbums = await PhotoGallery.listAlbums();
    if (imageAlbums.isNullOrEmpty) return;
    var currentAlbum = imageAlbums.first;
    var media = _filterAlbumList((await currentAlbum.listMedia(take: 50)).items);
    emit(
      state.copyWith(
        media: media,
        currentAlbum: currentAlbum,
        albumList: imageAlbums,
        loading: false,
      ),
    );
  }

  Future loadMoreMedia() async {
    emit(state.copyWith(loadingMore: true));
    var medias = List<Medium>.from(state.media);
    var newMedia = _filterAlbumList((await state.currentAlbum!.listMedia(take: 50, skip: state.media.length)).items);
    medias.addAll(newMedia);
    emit(state.copyWith(media: medias, loadingMore: false));
  }

  Future changeAlbum(Album selectedAlbum) async {
    var currentAlbum = state.albumList.firstWhere((x) => x.id == selectedAlbum.id);
    var media = _filterAlbumList((await currentAlbum.listMedia()).items);
    emit(
      SelectImagesState(
          media: media,
          currentAlbum: currentAlbum,
          albumList: state.albumList,
          selectedImages: state.selectedImages),
    );
  }

  void initSelectImages(List<Medium> images,
      {int maximumImage = Res.maximumAvatar}) {
    emit(state.copyWith(selectedImages: images));
    _maximumImages = maximumImage;
  }

  void selectedImage(Medium selectedImage) async {
    var imagesSelected = List<Medium>.from(state.selectedImages);
    var isExist = imagesSelected.contains(selectedImage);
    if (isExist) {
      imagesSelected.remove(selectedImage);
    } else {
      if (state.selectedImages.length == _maximumImages) {
        await DialogUtil.showAlertDialog(
            context: NavigatorUtils.navigatorKey.currentContext!,
            title: LocalizationUtils.text?.maximumImage(_maximumImages));
        return;
      }
      imagesSelected.add(selectedImage);
    }
    emit(
      state.copyWith(
        selectedImages: imagesSelected,
      ),
    );
  }

  void onResetData() {
    emit(SelectImagesState(
      media: state.media,
      currentAlbum: state.currentAlbum,
      albumList: state.albumList,
    ));
    _maximumImages = Res.maximumAvatar;
  }

  List<Medium> _filterAlbumList(List<Medium> medias) {
    return medias.where((element) => element.mimeType != "image/heic").toList();
  }

  Future<PermissionStatus> _statusOfPhotoOrStoragePermission() async {
    if (Platform.isAndroid && (await NativeUtils.isAndroidSDK32OrLower())) {
      return await Permission.storage.status;
    }
    return await Permission.photos.status;
  }

  Future<PermissionStatus> _requestPhotoOrStoragePermission() async {
    if (Platform.isAndroid && (await NativeUtils.isAndroidSDK32OrLower())) {
      return await Permission.storage.request();
    }
    return await Permission.photos.request();
  }

  Future<bool> promptPermissionSetting() async {
    late PermissionStatus photoOrStorage;
    photoOrStorage = await _statusOfPhotoOrStoragePermission();
    if (!photoOrStorage.isGranted) {
      await _requestPhotoOrStoragePermission();
    }
    photoOrStorage = await _statusOfPhotoOrStoragePermission();
    if (Platform.isIOS) {
      if (photoOrStorage.isPermanentlyDenied || photoOrStorage.isDenied) {
        await DialogUtil.alertMediaPermission(NavigatorUtils.context);
      }
      return photoOrStorage.isGranted || photoOrStorage.isLimited;
    } else {
      if (photoOrStorage.isPermanentlyDenied || photoOrStorage.isDenied) {
        await DialogUtil.alertMediaPermission(NavigatorUtils.context);
      }
      return (photoOrStorage.isGranted || photoOrStorage.isLimited);
    }
  }
}
