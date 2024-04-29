import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sample/global/router/navigation_utils.dart';

class LocalizationUtils {
  static AppLocalizations? of(BuildContext context) {
    return AppLocalizations.of(context);
  }

  /// LocalizationUtils.text?.text_month
  static AppLocalizations? get text {
    return NavigatorUtils.navigatorKey.currentContext == null
        ? null
        : AppLocalizations.of(NavigatorUtils.context);
  }
}
