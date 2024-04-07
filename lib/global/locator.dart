import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sample/core/api/logging_interceptor.dart';
import 'package:sample/core/api/rest_api/rest_api.dart';
import 'package:sample/core/database/app_hive.dart';
import 'package:sample/global/configs.dart';
import 'package:sample/global/event_bus/event_bus.dart';
import 'package:sample/global/global.dart';
import 'package:sample/global/locator_repositories.dart';
import 'package:sample/global/notification/notification_channel.dart';
import 'package:sample/global/notification/notification_helper.dart';
import 'package:sample/utils/app_bloc_observer.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initFirebaseApp();
  locator.registerLazySingleton(() => GlobalData());
  locator.registerLazySingleton(() => EventBus());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Bloc.observer = AppBlocObserver();
  await Future.wait([
    // locator<MyDatabase>().init(),
    NotificationHelper.onAppInit(),
    AppConfig.injectDependencies(),
  ]);
  registerRepositorySingletons(locator);
  AppConfig.handleError();
}

class AppConfig {
  static Future<void> injectDependencies() async {
    locator.registerSingleton(AppHive());
    await locator.get<AppHive>().init();
    // setup restAPI
    _setupResClient();

    //request permission
    // requestNotification();
  }

  static void _setupResClient() {
    if (locator.isRegistered<RestClient>(instanceName: "RestClient")) {
      locator.unregister<RestClient>(instanceName: "RestClient");
    }
    var dio = Dio();
    dio.options = BaseOptions(
      connectTimeout: const Duration(milliseconds: 50000),
      receiveTimeout: const Duration(milliseconds: 50000),
    );
    dio.interceptors.add(LoggingInterceptor());
    // dio.interceptors.add(
    //   PrettyDioLogger(
    //     requestHeader: true,
    //     requestBody: true,
    //     logPrint: (log) => debugPrint(log.toString()),
    //   ),
    // );
    try {
      locator.registerLazySingleton(
        () => RestClient(
          dio,
          baseUrl: Configs.baseUrl,
        ),
        instanceName: "RestClient",
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future requestNotification() async {
    if (Platform.isAndroid) {
      NotificationChannel.enableChannel('message');
    }
    await NotificationHelper.checkPermission();

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.setForegroundNotificationPresentationOptions(
        alert: false, badge: false, sound: false);
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // await FlutterAppBadger.isAppBadgeSupported();
    debugPrint(settings.toString());
  }

  static handleError() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        // In development mode, simply print to console.
        FlutterError.dumpErrorToConsole(details);
      } else {
        // In production mode, report to the application zone to report to sentry.
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      }
    };
  }
}
