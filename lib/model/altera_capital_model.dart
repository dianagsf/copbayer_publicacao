class AlteraCapitalModel {
  int matricula;
  String faixa;
  var valor;
  String data;
  String faixaAnterior;
  int numero;

  AlteraCapitalModel({
    this.matricula,
    this.faixa,
    this.valor,
    this.data,
    this.faixaAnterior,
    this.numero,
  });

  AlteraCapitalModel.fromJson(Map<String, dynamic> json) {
    matricula = json['matricula'];
    faixa = json['faixa'];
    valor = json['valor'];
    data = json['data'];
    faixaAnterior = json['faixaAnterior'];
    numero = json['numero'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matricula'] = this.matricula;
    data['faixa'] = this.faixa;
    data['valor'] = this.valor;
    data['data'] = this.data;
    data['faixaAnterior'] = this.faixaAnterior;
    data['numero'] = this.numero;
    return data;
  }
}
