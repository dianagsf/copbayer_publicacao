class SaldoDevedorModel {
  var devedor;

  SaldoDevedorModel({this.devedor});

  SaldoDevedorModel.fromJson(Map<String, dynamic> json) {
    devedor = json['devedor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['devedor'] = this.devedor;
    return data;
  }
}
