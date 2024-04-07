import 'package:flutter/services.dart';

class StringUtils {
  static final RegExp extractLocalizationRegex = RegExp(r'\{(\w+)\}');
  static final RegExp excludeSpecialCharacter =
      RegExp(r'[+×÷=/_€£¥₩!@#$%^&*():;,?."`~<>{}°•○●□■♤♡◇♧☆▪︎¤《》¡¿\[\]|\\]');
}

void copyToClipboard(String? s) {
  Clipboard.setData(ClipboardData(text: s ?? ""));
}

extension StringOptionalExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get notNullOrEmpty => this != null && this!.isNotEmpty;

  String get fileType {
    String fileName = this?.split('/').lastOrNull ?? '';
    return fileName.split('.').lastOrNull ?? '';
  }

  String? max([int max = 0, String end = '...']) {
    if (this == null || max == 0) {
      return this;
    }
    if (this!.length < max) {
      return this;
    }
    return '${this!.substring(0, max)}$end';
  }
}

extension StringExtension on String {
  bool hasSpecialCharacter() {
    return codeUnits.any((unit) => unit >= 50000);
  }
}
