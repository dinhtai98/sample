import 'dart:ui';

import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future? askContactPermission({
    VoidCallback? onGranted,
    VoidCallback? onDenied,
  }) async {
    PermissionStatus status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }
    if (!status.isGranted) {
      onDenied?.call();
      return;
    }
    onGranted?.call();
  }
}
