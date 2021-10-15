class FaixaCapitalModel {
  String faixas;
  int valor;

  FaixaCapitalModel({this.faixas, this.valor});

  FaixaCapitalModel.fromJson(Map<String, dynamic> json) {
    faixas = json['faixas'];
    valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['faixas'] = this.faixas;
    data['valor'] = this.valor;
    return data;
  }
}
