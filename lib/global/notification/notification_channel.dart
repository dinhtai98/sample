import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sample/utils/color_utils.dart';
import 'package:sample/utils/string.dart';
import 'notification_helper.dart';

class NotificationChannel {
  static Future<Channel?> getChannel(String id) async {
    final channels = await plugin
        .resolvePlatformSpecificImplementation<AndroidPlugin>()!
        .getNotificationChannels();
    if (channels == null || channels.isEmpty) return null;
    try {
      final channel = channels.firstWhere((element) => element.id == id);
      return channel;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<NotificationDetails?> getChannelDetail(String id,
      {String? imageUrl}) async {
    String largeIconPath = await _downloadAndSaveFile(imageUrl, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(
      imageUrl,
      'bigPicture',
    );

    if (Platform.isIOS) {
      return NotificationDetails(
          iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: true,
        attachments: largeIconPath.notNullOrEmpty
            ? [DarwinNotificationAttachment(largeIconPath)]
            : null,
      ));
    }
    Channel? channel = await getChannel("message");
    if (channel == null) return null;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        id, //channelID
        channel.name, // channelName
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        icon: "ic_notification",
        color: ColorUtils.primary5,
        largeIcon: largeIconPath.notNullOrEmpty
            ? FilePathAndroidBitmap(largeIconPath)
            : null,
        styleInformation: bigPicturePath.notNullOrEmpty
            ? BigPictureStyleInformation(
                FilePathAndroidBitmap(bigPicturePath),
                hideExpandedLargeIcon: false,
                htmlFormatContentTitle: true,
                htmlFormatSummaryText: true,
              )
            : null,
      ),
    );
  }

  static Future<void> enableChannel(String id) async {
    switch (id) {
      case "message":
        await createChannel(id, "message", "message description");
        break;
      default:
        break;
    }
  }

  static Future<void> disableChannel(String id) async {
    await deleteChannel(id);
  }

  static Future<void> createChannel(
      String id, String name, String description) async {
    await plugin
        .resolvePlatformSpecificImplementation<AndroidPlugin>()!
        .createNotificationChannel(AndroidNotificationChannel(
          id,
          name,
          description: description,
        ));
  }

  static Future<void> deleteChannel(String id) async {
    await plugin
        .resolvePlatformSpecificImplementation<AndroidPlugin>()
        ?.deleteNotificationChannel(id);
  }

  static Future<String> _downloadAndSaveFile(
      String? url, String? fileName) async {
    if (url.isNullOrEmpty || fileName.isNullOrEmpty) return '';
    late Directory? directory;
    if (Platform.isIOS) {
      directory = await getTemporaryDirectory();
    } else {
      directory = (await getExternalStorageDirectory());
    }
    if (directory == null) return '';

    String filePathName = "${directory.path}/$fileName.png";
    // File savedFile = File(filePathName);
    // bool fileExists = await savedFile.exists();
    // if (fileExists) {
    //   return filePathName;
    // }
    final http.Response response = await http.get(Uri.parse(url!));
    final File file = File(filePathName);
    await file.writeAsBytes(response.bodyBytes);
    return filePathName;
  }
}
