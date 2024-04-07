import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/services.dart';

class Configs {
  static String get baseUrl => '';
  static setOnlyPortraitScreen() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

  static bool get isIos => defaultTargetPlatform == TargetPlatform.iOS;

  static Future<FirebaseOptions> get currentPlatform async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return await androidOptions;
      case TargetPlatform.iOS:
        return iosOptions;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static Future<FirebaseOptions> get androidOptions async {
    return const FirebaseOptions(
      apiKey: '',
      appId: '',
      messagingSenderId: '',
      projectId: '',
      storageBucket: "",
    );
  }

  static const String iosClientId = "";

  static const FirebaseOptions iosOptions = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    storageBucket: '',
    androidClientId: '',
    iosClientId: iosClientId,
    iosBundleId: '',
  );
}
