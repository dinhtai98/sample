import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Future<String?> uploadImageCloudflare(
    {required String url, required File file, required String name}) async {
  Uint8List uint8List = file.readAsBytesSync();
  return uploadImageCloudflareUint8List(url: url, list: uint8List, name: name);
}

Future<String?> uploadImageCloudflareUint8List({
  required String url,
  required Uint8List list,
  required String name,
  String contentType = 'image/jpg',
  Function(int, int)? onUploadProgress,
}) async {
  try {
    final result = await Dio().put(
      url,
      data: Stream.fromIterable(list.map((e) => [e])),
      options: Options(
        headers: {
          'Accept': "*/*",
          'Content-Length': list.length,
          'Connection': 'keep-alive',
          'User-Agent': 'ClinicPlush',
          'Content-Type': contentType,
        },
      ),
      onSendProgress: (int sent, int total) {
        onUploadProgress?.call(sent, total);
      },
    );
    if (result.statusCode != 200) {
      return null;
    }

    return '/$name';
  } catch (e) {
    return null;
  }
}
