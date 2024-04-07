import 'package:intl/intl.dart';
import 'package:sample/utils/localization_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

extension DateTimeUtil on DateTime? {
  String timeAgo() {
    try {
      DateTime currentDate = DateTime.now().toLocal();

      var different = currentDate.difference(this!);
      if (different.inDays > 30) {
        return "${this!.year}${LocalizationUtils.text?.text_year} ${this!.month}${LocalizationUtils.text?.text_month} ${this!.day}${LocalizationUtils.text?.text_day} ${getWeekday()}";
      }
      if (different.inDays > 7) {
        return "${(different.inDays / 7).floor()}${(different.inDays / 7).floor() == 1 ? "${LocalizationUtils.text?.text_week}" : "${LocalizationUtils.text?.text_weeks}"} ${LocalizationUtils.text?.text_ago}";
      }
      if (different.inDays > 0) {
        return timeAgoV2();
      }
      if (different.inHours > 0) {
        return timeAgoV2();
      }
      if (different.inMinutes > 0) {
        return timeAgoV2();
      }
      if (different.inMinutes == 0) {
        return '${LocalizationUtils.text?.text_just_before}';
      }

      return toString();
    } catch (e) {
      return '';
    }
  }

  String getWeekday() {
    return '';
    // var weekday = this!.weekday;
    // switch (weekday) {
    //   case 1:
    //     return LocalizationUtils.text?.mon ?? '';
    //   case 2:
    //     return LocalizationUtils.text?.tue ?? '';
    //   case 3:
    //     return LocalizationUtils.text?.wed ?? '';
    //   case 4:
    //     return LocalizationUtils.text?.thu ?? '';
    //   case 5:
    //     return LocalizationUtils.text?.fri ?? '';
    //   case 6:
    //     return LocalizationUtils.text?.sat ?? '';
    //   default:
    //     return LocalizationUtils.text?.mon ?? '';
    // }
  }

  String timeAgoV2() {
    if (this == null) return '';
    return timeago.format(this!,
        locale: LocalizationUtils.text?.localeName ?? 'ko');
  }

  String toDate(format) {
    try {
      return DateFormat(format).format(this!);
    } catch (e) {
      return '';
    }
  }

  bool isSameDate(DateTime? other) {
    return this?.year == other?.year &&
        this?.month == other?.month &&
        this?.day == other?.day;
  }

  DateTime getDateOnly() {
    final now = DateTime.now();
    return DateTime(
      this?.year ?? now.year,
      this?.month ?? now.month,
      this?.day ?? now.day,
    );
  }

  String yyyyMMdd() {
    try {
      return DateFormat('yyyy-MM-dd').format(this!);
    } catch (e) {
      return '';
    }
  }

  String yyyyMMddWithDot() {
    try {
      return DateFormat('yyyy.MM.dd').format(this!);
    } catch (e) {
      return '';
    }
  }

  String toHHmm() {
    try {
      return DateFormat('a hh:mm').format(this!);
    } catch (e) {
      return '';
    }
  }

  String toaHHmm() {
    try {
      return DateFormat('a HH:mm').format(this!);
    } catch (e) {
      return '';
    }
  }
}

extension DateTimeExtension on DateTime {
  bool isTheSameDate(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }
}

class DateTimeUtils {
  //[hourFormat] should be hh:mm
  static num? get24H(String? hourFormat) {
    try {
      final arr = hourFormat?.split(':');
      return num.tryParse(arr?.first ?? '');
    } catch (e) {
      return null;
    }
  }
}
