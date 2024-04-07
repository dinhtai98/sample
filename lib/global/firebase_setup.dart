import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sample/global/configs.dart';

Future initFirebaseApp() async {
  await Firebase.initializeApp(options: await Configs.currentPlatform);

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
    debugPrint("fcmToken: $fcmToken");
  }).onError((err) {
    debugPrint("fcmToken error: $err");
  });
}
