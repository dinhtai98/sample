import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img_lib;
import 'package:image_picker/image_picker.dart' as img_picker;

material.Image imageAsset(String name, {String ext = "png"}) {
  return material.Image.asset("assets/images/$name.$ext");
}

String svgIcon(String name, {String ext = "svg"}) {
  return "assets/icons/$name.$ext";
}

ImageErrorWidgetBuilder errorImageBuilder =
    (BuildContext context, Object error, StackTrace? stackTrace) {
  return _errorImage(message: 'This image error');
};

Widget _errorImage({String message = 'item error'}) {
  return Container(
    width: 100,
    height: 100,
    color: Colors.red,
    child: Center(
      widthFactor: double.infinity,
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 8, color: Colors.white),
      ),
    ),
  );
}

const maxSize = 1080;

typedef ImageObject = img_lib.Image;

ImageObject resizeImage(ImageObject originImage) {
  if (originImage.width >= originImage.height) {
    return img_lib.copyResize(
      originImage,
      width: maxSize,
      height: originImage.height * maxSize ~/ originImage.width,
    );
  }
  return img_lib.copyResize(
    originImage,
    width: originImage.width * maxSize ~/ originImage.height,
    height: maxSize,
  );
}

img_lib.JpegEncoder jpegEncoder = img_lib.JpegEncoder(quality: 100);

Uint8List encodeImage(ImageObject image) {
  return Uint8List.fromList(jpegEncoder.encode(image));
}

/// Get from Gallery File(path)
Future<String?> pickImageFromGallery() async {
  img_picker.ImagePicker picker = img_picker.ImagePicker();
  img_picker.XFile? pickedFile = await picker.pickImage(
    source: img_picker.ImageSource.gallery,
    maxWidth: 10000,
    maxHeight: 10000,
  );
  return pickedFile?.path;
}

Future<List<img_picker.XFile>?> pickMultiImageFromGallery() async {
  img_picker.ImagePicker picker = img_picker.ImagePicker();
  List<img_picker.XFile>? pickedFiles = await picker.pickMultiImage(
    maxWidth: 10000,
    maxHeight: 10000,
  );
  return pickedFiles;
}

/// Get from Camera File(path)
Future<img_picker.XFile?> pickImageFromCamera() async {
  img_picker.ImagePicker picker = img_picker.ImagePicker();
  img_picker.XFile? pickedFile = await picker.pickImage(
    source: img_picker.ImageSource.camera,
    maxWidth: 4096,
    maxHeight: 4096,
  );
  return pickedFile;
}

Future<Uint8List?> capturePng(
  GlobalKey globalKey, {
  double pixelRatio = 1.0,
  AppLifecycleState state = AppLifecycleState.resumed,
}) async {
  try {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    await Future.delayed(const Duration(milliseconds: 10));

    if (state != AppLifecycleState.resumed) return null;
    if (kDebugMode && boundary.debugNeedsPaint) {
      return await capturePng(globalKey, pixelRatio: pixelRatio);
    }
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  } catch (e) {
    log("capturePng $e");
    return await capturePng(globalKey, pixelRatio: pixelRatio);
  }
}

Future getImageBase64(
    Map<String, String?> result, Future<Uint8List?> imageData) async {
  try {
    final data = await imageData;
    img_lib.Image originImage = img_lib.decodeImage(data!)!;
    //img_lib.Image resizedImage = resizeImage(originImage);
    Uint8List uploadImage = encodeImage(originImage);
    final imageBase64 = base64Encode(uploadImage);
    result["base64Image"] = imageBase64;
  } on Exception catch (e) {
    result["error"] = e.toString();
  }
}

Future getImagePath(Map<String, String?> result, String? imagePath) async {
  try {
    result["path"] = imagePath;
  } on Exception catch (e) {
    result["error"] = e.toString();
  }
}

Future<File> resizeImageBelowSize(File imageFile) async {
  const int maxSize = 5242880; // 5MB in bytes

  if (imageFile.existsSync()) {
    int fileSize = imageFile.lengthSync();

    // Check if the image file size is greater than the maximum size
    while (fileSize > maxSize) {
      var imageBytes = await imageFile.readAsBytes();

      // Compress the image by reducing the quality and dimensions
      List<int> compressedBytes = await FlutterImageCompress.compressWithList(
        imageBytes,
        minHeight: 1080, // Full HD resolution
        minWidth: 1920,
        quality: 70, // Adjust quality as needed (0 to 100)
      );

      // Write the compressed image bytes to the file
      await imageFile.writeAsBytes(compressedBytes);

      fileSize = imageFile.lengthSync(); // Get the updated file size
    }
  }
  return imageFile;
}

Future<Uint8List> getBytesFromAsset(String assetPath, int width, int height) async {
  ByteData data = await rootBundle.load(assetPath);
  ui.Codec codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width,
    targetHeight: height,
  );
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}
