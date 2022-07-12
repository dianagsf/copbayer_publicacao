import 'package:money_formatter/money_formatter.dart';

class FormatMoney {
  String formatterMoney(double money) {
    MoneyFormatter fmf = new MoneyFormatter(
      amount: money,
      settings: MoneyFormatterSettings(
        symbol: 'R\$',
        thousandSeparator: '.',
        decimalSeparator: ',',
        symbolAndNumberSeparator: ' ',
        fractionDigits: 2,
      ),
    );

    MoneyFormatterOutput fo = fmf.output;

    return fo.symbolOnLeft;
  }
}
