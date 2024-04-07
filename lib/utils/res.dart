import 'dart:typed_data';

class Res {
  static const int maximumAvatar = 5;
  static int maximumPersonality = 4;
  static const int pageLimit = 10;
  static List<int> years = [];
  static List<int> getHourChild() {
    return List.generate(24, (index) => index++);
  }

  static List<int> getAMHourChild() {
    return List.generate(12, (index) => index++);
  }

  static List<int> getPMHourChild() {
    return List.generate(11, (index) => 1 + index);
  }

  static List<int> getMinuteChild() {
    return List.generate(60, (index) => index++);
  }

  static List<int> getYearChild() {
    if (years.isEmpty) {
      for (var i = 1900; i <= DateTime.now().year; i++) {
        years.add(i);
      }
    }
    return years;
  }

  static List<int> getListItemEndWith(int end) {
    return List.generate(end, (index) => ++index);
  }

  static const List<int> months = [];

  static List<int> getHeight() {
    return List.generate(241 - 90 + 1, (index) => 90 + index);
  }

  static const defaultLanguage = 'ko';

  static const languages = {
    'vi': 'Tiếng Việt / VN',
    'en': 'English / EN',
    'ko': '한국어 / KO',
  };

  static final Uint8List kTransparentImage = Uint8List.fromList(<int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
  ]);
}
