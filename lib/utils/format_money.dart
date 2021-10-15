import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class FormatMoney {
  String formatterMoney(double money) {
    MoneyFormatterOutput fo = FlutterMoneyFormatter(
        amount: money,
        settings: MoneyFormatterSettings(
          symbol: 'R\$',
          thousandSeparator: '.',
          decimalSeparator: ',',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 2,
        )).output;

    return fo.symbolOnLeft;
  }
}
