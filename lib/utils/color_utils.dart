import 'package:flutter/material.dart';

class ColorUtils {
  static Color fromString(String colorString) {
    // ignore: unnecessary_null_comparison
    if (colorString == null) {
      return const Color(0xffF2F2F2);
    }

    try {
      // rgba(247, 247, 247, 0.73)
      if (colorString.substring(0, 4) == 'rgba') {
        String tempString = colorString;
        tempString = tempString.substring(4);
        tempString = tempString.replaceAll('(', '');
        tempString = tempString.replaceAll(')', '');
        List<String> rgbaValueList = tempString.split(',');
        rgbaValueList = rgbaValueList.map((e) => e.trim()).toList();

        if (rgbaValueList.length != 4) {
          throw Exception('Invalid string color');
        }

        try {
          int red = int.parse(rgbaValueList[0]);
          int green = int.parse(rgbaValueList[1]);
          int blue = int.parse(rgbaValueList[2]);
          double alpha = double.parse(rgbaValueList[3]);
          return Color.fromRGBO(red, green, blue, alpha);
        } catch (e) {
          rethrow;
        }
      }

      // #f3e2d0
      final buffer = StringBuffer();
      if (colorString.length == 6 || colorString.length == 7) {
        buffer.write('ff');
      }
      buffer.write(colorString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return const Color(0xffF2F2F2);
    }
  }

  static const Color transparent = Colors.transparent;
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color white2 = Color(0xFFF9FAFB);
  static const Color black = Color(0xFF000000);
  static const Color black1 = Color(0xFF667085);
  static const Color subBlue1 = Color(0xFF4DA2EF);
  static const Color subGreen1 = Color(0xFF39C16F);
  static const Color subYellow1 = Color(0xFFF6A75E);
  static const Color brown = Color(0xFFBA6926);

  static const Color primary10 = Color(0xFFF2EBFF);
  static const Color primary9 = Color(0xFFECE0FF);
  static const Color primary8 = Color(0xFFDFCCFF);
  static const Color primary7 = Color(0xFFCFB2FF);
  static const Color primary6 = Color(0xFFC099FF);
  static const Color primary5 = Color(0xFFB080FF);
  static const Color primary4 = Color(0xFFA066FF);
  static const Color primary3 = Color(0xFF904DFF);
  static const Color primary2 = Color(0xFF8033FF);
  static const Color primary1 = Color(0xFF711AFF);
  static const Color primary0 = Color(0xFF5500E0);

  static const Color srRed10 = Color(0xFFFDECF0);
  static const Color srRed9 = Color(0xFFFCDEE5);
  static const Color srRed8 = Color(0xFFFBD0DA);
  static const Color srRed7 = Color(0xFFF9B8C8);
  static const Color srRed6 = Color(0xFFF7A1B6);
  static const Color srRed5 = Color(0xFFF589A3);
  static const Color srRed4 = Color(0xFFF37291);
  static const Color srRed3 = Color(0xFFF15B7F);
  static const Color srRed2 = Color(0xFFEF436C);
  static const Color srRed1 = Color(0xFFEB1448);
  static const Color srRed0 = Color(0xFFCF123F);

  static const Color srBlue10 = Color(0xFFEBF6FF);
  static const Color srBlue9 = Color(0xFFDBF0FF);
  static const Color srBlue8 = Color(0xFFCCEAFF);
  static const Color srBlue7 = Color(0xFFB2DFFF);
  static const Color srBlue6 = Color(0xFF99D4FF);
  static const Color srBlue5 = Color(0xFF80C9FF);
  static const Color srBlue4 = Color(0xFF66BFFF);
  static const Color srBlue3 = Color(0xFF4DB4FF);
  static const Color srBlue2 = Color(0xFF33A9FF);
  static const Color srBlue1 = Color(0xFF0094FF);
  static const Color srBlue0 = Color(0xFF0082E0);

  static const Color gray25 = Color(0xFFFCFCFD);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF2F4F7);
  static const Color gray200 = Color(0xFFEAECF0);
  static const Color gray250 = Color(0xFFDBDFE5);
  static const Color gray300 = Color(0xFFD0D5DD);
  static const Color gray350 = Color(0xFFB5BDC9);
  static const Color gray400 = Color(0xFF98A2B3);
  static const Color gray500 = Color(0xFF667085);
  static const Color gray600 = Color(0xFF475467);
  static const Color gray700 = Color(0xFF344054);
  static const Color gray800 = Color(0xFF1D2939);
  static const Color gray900 = Color(0xFF101828);

  static const List<Color> gr1Gradient1 = [
    Color(0xFF80A0F7),
    Color(0xFFE8A3F4)
  ];
  static const List<Color> gr1Gradient1_1 = [
    Color(0xFFE8A3F4),
    Color(0xFF80A0F7)
  ];
  static const List<Color> gr1Gradient2 = [
    Color(0xFFF36C9F),
    Color(0xFFF99CB2),
    Color(0xFFFFD8F4),
  ];
  static const List<Color> gr1Gradient3 = [
    Color(0xFFA066FF),
    Color(0xFF4DB4FF),
  ];

  static const List<Color> gr1Gradient4 = [
    Color(0xFFA066FF),
    Color(0xFF8033FF),
  ];

  static const List<Color> gr1Gradient5 = [
    Color(0xFF4DB4FF),
    Color(0xFF0094FF),
  ];

  static const List<Color> gr1Gradient6 = [
    Color(0xFFC099FF),
    Color(0xFF8033FF)
  ];

  // gr2Gradient
  static const List<Color> gr2Gradient1 = [
    Color(0xFFFF4D6B),
    Color(0xFFFF7070),
  ];

  static const List<Color> gr2Gradient2 = [
    Color(0xFFF99CD6),
    Color(0xFFF9D0E1),
    Color(0xFFF9FAD3),
    Color(0xFFF6FBD6),
    Color(0xFFEDFCDE),
    Color(0xFFDEFFEB),
    Color(0xFFDCFEEE),
    Color(0xFFD6FDF7),
    Color(0xFFD4FCFB),
    Color(0xFFD3D8FE),
  ];

  static const List<Color> gr2Gradient3 = [
    Color(0xFFF99CD6),
    Color(0xFFF9FAD3),
  ];

  static const List<Color> gr2Gradient4 = [
    Color(0xFFF9FAD3),
    Color(0xFFDEFFEB),
  ];

  static const List<Color> gr2Gradient5 = [
    Color(0xFFDEFFEB),
    Color(0xFFD3ECFE),
  ];
  static const List<Color> gr2Gradient6 = [
    Color(0xFFD3ECFE),
    Color(0xFFD3D8FE),
  ];
  static const List<Color> gr2Gradient7 = [
    Color(0xFFD3D8FE),
    Color(0xFFFFC1E8),
  ];
  static const List<Color> gr2Gradient8 = [
    Color(0xFFFFA3B9),
    Color(0xFFFF4573)
  ];

  static const Color red_Gradient_1 = Color(0xFFFF7070);
}
