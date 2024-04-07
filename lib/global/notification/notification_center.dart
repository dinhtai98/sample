import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notification_channel.dart';
import 'notification_helper.dart';

class NotificationCenter {
  static int get _notificationId => NotificationHelper.id++;

  static Future<void> notify({
    String? title,
    String? body,
    String? payload,
    String? imageUrl,
  }) async {
    NotificationDetails? details = await NotificationChannel.getChannelDetail(
        "message",
        imageUrl: imageUrl);
    if (details == null) return;
    await plugin.show(_notificationId, title, body, details, payload: payload);
  }

  static Future<void> scheduleNotify({
    required int id,
    String? title,
    String? body,
    DateTime? time,
  }) async {
    NotificationDetails? details =
        await NotificationChannel.getChannelDetail("message");
    if (details == null) return;
    await plugin.zonedSchedule(
      id.hashCode,
      title,
      body,
      tzDateTime(
          time ?? DateTime.now().add(const Duration(seconds: 1))), // delay
      details,
      payload: 'message',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<int> notificationCount() async {
    final notifications = await plugin
        .resolvePlatformSpecificImplementation<AndroidPlugin>()!
        .getActiveNotifications();
    return notifications.length;
  }

  static tz.TZDateTime tzDateTime(DateTime d) {
    return tz.TZDateTime(
        tz.local, d.year, d.month, d.day, d.hour, d.minute, d.second);
  }

  static tz.TZDateTime nextInstanceOf10AM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

class PayloadMessageModel {
  final String type;
  final String payload;

  PayloadMessageModel({required this.type, required this.payload});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'type': type});
    result.addAll({'payload': payload});

    return result;
  }

  factory PayloadMessageModel.fromMap(Map<String, dynamic> map) {
    return PayloadMessageModel(
      type: map['type'] ?? '',
      payload: map['payload'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PayloadMessageModel.fromJson(String source) =>
      PayloadMessageModel.fromMap(json.decode(source));
}
