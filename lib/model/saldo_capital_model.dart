class SaldoCapitalModel {
  String saldo;

  SaldoCapitalModel({this.saldo});

  SaldoCapitalModel.fromJson(Map<String, dynamic> json) {
    saldo = json['saldo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['saldo'] = this.saldo;
    return data;
  }
}
