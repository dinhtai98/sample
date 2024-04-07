import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

/// [https://pub.dev/packages/hive]
/// Key-value database, encrypted using AES-256
///
ValueNotifier<int> messageCount = ValueNotifier<int>(0);
ValueNotifier<int> messageAllTypeCount = ValueNotifier<int>(0);

class AppHive {
  late Box<dynamic> shared;
  late Box<dynamic> notification;

  // String tokenKey = "access_token";

  final String currentUserKey = "currentUserKey";
  final String _notificationCount = "notificationCount";

  Future<bool> init() async {
    await Hive.initFlutter();
    shared = await Hive.openBox<String>('shared');
    notification = await Hive.openBox<String>('notification');
    return true;
  }

  Future getNotificationCount() async {
    var data = await notification.get(_notificationCount);
    debugPrint('getNotificationCount $data');
    if ([null, ''].contains(data)) {
      messageAllTypeCount.value = 0;
      return;
    }
    messageAllTypeCount.value = int.parse(data.toString());
  }
}
