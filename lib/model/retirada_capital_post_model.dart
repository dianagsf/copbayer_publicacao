class RetiradaCapitalModel {
  int matricula;
  var valor;
  String data;
  int numero;

  RetiradaCapitalModel({
    this.matricula,
    this.valor,
    this.data,
    this.numero,
  });

  RetiradaCapitalModel.fromJson(Map<String, dynamic> json) {
    matricula = json['matricula'];
    valor = json['valor'];
    data = json['data'];
    numero = json['numero'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matricula'] = this.matricula;
    data['valor'] = this.valor;
    data['data'] = this.data;
    data['numero'] = this.numero;
    return data;
  }
}
