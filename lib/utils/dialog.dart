import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:sample/core/base/api_utils.dart';
import 'package:sample/utils/color_utils.dart';
import 'package:sample/utils/dimen_mixin.dart';
import 'package:sample/utils/localization_utils.dart';
import 'package:sample/utils/status_bar_util.dart';
import 'package:sample/utils/string.dart';
import 'package:sample/utils/text_style_utils.dart';
import 'package:sample/utils/widgets/button_view.dart';

class DialogUtil {
  static Future<bool> showAlertDialog({
    required BuildContext context,
    String? title,
    String? subTitle,
    String? message,
    String? acceptText,
    String? cancelText,
    bool barrierDismissible = true,
    bool isButtonOnRow = true,
    bool isCancelTextUnderline = false,
    Widget? child,
  }) async {
    acceptText ??= LocalizationUtils.text?.text_close;
    dynamic result = await showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext dialogContext) {
        return SystemUIContainer(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                InkWell(
                  onTap: () => barrierDismissible
                      ? Navigator.of(dialogContext).pop()
                      : null,
                  child: Container(color: Colors.transparent),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(Dimen.marginX4),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.white,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Dimen.dialogRadius),
                        ),
                        child: _buildDialogChild(
                          dialogContext,
                          title,
                          subTitle,
                          message,
                          acceptText,
                          cancelText,
                          barrierDismissible,
                          isButtonOnRow,
                          isCancelTextUnderline,
                          child,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return result == true;
  }

  static Widget _buildDialogChild(
    BuildContext dialogContext,
    String? title,
    String? subTitle,
    String? message,
    String? acceptText,
    String? cancelText,
    bool barrierDismissible,
    bool isButtonOnRow,
    bool isCancelTextUnderline,
    Widget? child,
  ) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimen.marginX3,
              vertical: Dimen.marginX3,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(padding: EdgeInsets.only(top: Dimen.margin)),
                if (title != null)
                  Column(
                    children: [
                      _dialogTitle(title),
                      Dimen.marginY(Dimen.margin12),
                    ],
                  ),
                _buildChildOrSubtitleAndMessageGroup(child, subTitle, message),
                _buildGroupButton(dialogContext, isButtonOnRow, cancelText,
                    acceptText, isCancelTextUnderline),
              ],
            ),
          )
        ],
      ),
    );
  }

  static _buildGroupButton(BuildContext dialogContext, bool isButtonOnRow,
      String? cancelText, String? acceptText, bool isCancelTextUnderline) {
    Widget acceptButton = acceptText == null
        ? const SizedBox()
        : CustomButton(
            buttonSizeEnum: ButtonSizeEnum.medium,
            text: acceptText,
            onTap: () async {
              Navigator.of(dialogContext).pop(true);
            },
          );
    Widget cancelButton = cancelText == null
        ? const SizedBox()
        : CustomButton(
            buttonSizeEnum: ButtonSizeEnum.medium,
            text: cancelText,
            onTap: () {
              Navigator.of(dialogContext).pop(false);
            },
            backgroundColor: isCancelTextUnderline
                ? ColorUtils.transparent
                : ColorUtils.gray100,
            textColor:
                isCancelTextUnderline ? ColorUtils.gray400 : ColorUtils.gray500,
            isTextUnderline: isCancelTextUnderline,
          );
    Widget padding = const SizedBox.shrink();
    if (cancelText != null && acceptText != null) {
      padding = isButtonOnRow
          ? Dimen.marginX(Dimen.margin)
          : Dimen.marginY(Dimen.marginX2);
    }

    if (isButtonOnRow) {
      return Row(
        children: [
          if (cancelText.notNullOrEmpty) Expanded(child: cancelButton),
          padding,
          Expanded(child: acceptButton),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        acceptButton,
        padding,
        cancelButton,
      ],
    );
  }

  static _buildChildOrSubtitleAndMessageGroup(
      Widget? child, String? subTitle, String? message) {
    if (child != null) return child;
    return Column(
      children: [
        if (subTitle.isNullOrEmpty)
          Column(
            children: [
              _dialogSubTitle(subTitle),
              Dimen.marginY(Dimen.marginX3),
            ],
          ),
        if (message.isNullOrEmpty)
          Column(
            children: [
              _dialogMessage(message),
              Dimen.marginY(Dimen.marginX3),
            ],
          )
      ],
    );
  }

  static Widget _dialogSubTitle(String? s) {
    return Text(
      s ?? "",
      textAlign: TextAlign.center,
      style: TextStyleUtils.body2(),
    );
  }

  static Widget _dialogTitle(String? s) {
    return Text(
      s ?? "",
      textAlign: TextAlign.center,
      style: TextStyleUtils.title1(),
    );
  }

  static Widget _dialogMessage(String? s) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        // horizontal: Dimen.marginX2,
      ),
      child: Text(
        s ?? "",
        textAlign: TextAlign.center,
        style: TextStyleUtils.title2_1(),
      ),
    );
  }

  static Future alertMediaPermission(BuildContext context) async {
    dynamic isAccept = await showAlertDialog(
      context: context,
      title: LocalizationUtils.text?.filesAndPhotos,
      message: LocalizationUtils
          .text?.youCanSharePhotosAndFilesInYourProfileSettingsAndChat,
      cancelText: LocalizationUtils.text?.cancel,
    );
    if (isAccept) {
      await AppSettings.openAppSettings(type: AppSettingsType.settings);
    }
  }

  static Future alertLocationPermission(BuildContext context) async {
    dynamic isAccept = await showAlertDialog(
        context: context,
        title: LocalizationUtils.text?.location,
        message: LocalizationUtils.text?.shareYourLocationToFindFriend,
        cancelText: LocalizationUtils.text?.cancel,
        acceptText: LocalizationUtils.text?.setting);
    if (isAccept) {
      return true;
    }
    return false;
  }

  static Future? showErrorMessage(
    BuildContext context,
    Object? error, {
    bool useErrorField = false,
  }) {
    String subTitleContent = 'Error';
    if (useErrorField) {
      if (error is String) {
        subTitleContent = error;
      } else {
        subTitleContent =
            (error as AppErrorException?)?.message ?? error.toString();
      }
    }

    return showAlertDialog(
      context: context,
      title: 'Error',
      subTitle: subTitleContent,
      acceptText: LocalizationUtils.text?.text_close,
    );
  }
}
