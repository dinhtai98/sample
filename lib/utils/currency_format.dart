import 'package:intl/intl.dart';

class CurrencyFormat{
  CurrencyFormat._();
  static CurrencyFormat instance = CurrencyFormat._();

  String parse(Object? price, String? symbol, {bool start = false}){
    var formatter = NumberFormat('###,000');
    num value = 0;
    if (price is String) {
      value = double.tryParse(price) ?? 0;
    }else if (price is num){
      value = price.toDouble();
    }
    value = value.abs();
    String money;
    if (value > 999) {
      money = formatter.format(value);
    }else {
      money = value.toString();
    }
    if (money.endsWith(".0")){
      money = money.replaceFirst(".0", "");
    }
    if (symbol?.isNotEmpty == true) {
      if (start) {
        return "$symbol $money";
      } else {
        return "$money $symbol";
      }
    }
    return money;
  }
}