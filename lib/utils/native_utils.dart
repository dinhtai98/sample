import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class NativeUtils {
  static const channel = MethodChannel('native_utils');

  static Future<bool> isAndroidSDK32OrLower() async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt <= 32;
  }
}
