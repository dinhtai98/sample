import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:sample/ui/00_splash/splash_screen.dart';
import 'package:sample/utils/app_log.dart';
import 'package:sample/utils/string.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notification_setting.dart';

typedef AndroidPlugin = AndroidFlutterLocalNotificationsPlugin;
typedef Channel = AndroidNotificationChannel;
typedef IosPlugin = IOSFlutterLocalNotificationsPlugin;

final FlutterLocalNotificationsPlugin plugin =
    FlutterLocalNotificationsPlugin();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
// ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
// ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class NotificationHelper {
  static int id = 0;

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialized in the `main` function
  static final StreamController<ReceivedNotification>
      onLocalNotificationReceived =
      StreamController<ReceivedNotification>.broadcast();

  static final StreamController<String?> onNotificationSelected =
      StreamController<String?>.broadcast();

  static String? selectedNotificationPayload;

  static const String urlLaunchActionId = 'id_1';

  static bool notificationsEnabled = false;

  static bool hadInitialized = false;
  static String TAG = 'NotificationHelper';

  static Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static Future onAppInit() async {
    configureLocalTimeZone();

    await plugin.initialize(
      notificationSettings(
          (int id, String? title, String? body, String? payload) async {
        final notification = ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        );
        onLocalNotificationReceived.add(notification);
      }),
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            onNotificationSelected.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              onNotificationSelected.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<bool> get isAndroidPermissionGranted async {
    if (Platform.isAndroid) {
      final bool granted = await plugin
              .resolvePlatformSpecificImplementation<AndroidPlugin>()
              ?.areNotificationsEnabled() ??
          false;
      notificationsEnabled = granted;
      return granted;
    }
    return true;
  }

  static Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await plugin
          .resolvePlatformSpecificImplementation<IosPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidPlugin? androidImplementation =
          plugin.resolvePlatformSpecificImplementation<AndroidPlugin>();

      final bool? granted =
          await androidImplementation?.requestNotificationsPermission();
      notificationsEnabled = granted ?? false;
    }
  }

  static void configureDidReceiveLocalNotificationSubject(BuildContext ctx) {
    onLocalNotificationReceived.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: ctx,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SplashScreen(),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  static void configureSelectNotificationSubject(BuildContext context) {
    onNotificationSelected.stream.listen((String? payload) async {
      AppLog.e(TAG, 'payload1: $payload');
      if ((payload ?? '').notNullOrEmpty) {
        // handle tap to notification in foreground
      }
    });
  }

  static Future<bool> checkPermission() async {
    bool isGranted = await isAndroidPermissionGranted;
    if (!isGranted) {
      await requestPermissions();
    }
    return await isAndroidPermissionGranted;
  }

  static void initState(BuildContext context) async {
    if (hadInitialized) {
      //return;
    }
    configureDidReceiveLocalNotificationSubject(context);
    configureSelectNotificationSubject(context);

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await plugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
      // handle tap to notification in background
    }
    hadInitialized = true;
  }

  static void dispose() {
    onLocalNotificationReceived.close();
    onNotificationSelected.close();
  }
}
