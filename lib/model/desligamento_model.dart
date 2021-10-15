class DesligamentoModel {
  int matricula;
  String data;
  String motivo;
  String observacao;
  int numero;

  DesligamentoModel({
    this.matricula,
    this.data,
    this.motivo,
    this.observacao,
    this.numero,
  });

  DesligamentoModel.fromJson(Map<String, dynamic> json) {
    matricula = json['matricula'];
    data = json['data'];
    motivo = json['motivo'];
    observacao = json['observacao'];
    numero = json['numero'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matricula'] = this.matricula;
    data['data'] = this.data;
    data['motivo'] = this.motivo;
    data['observacao'] = this.observacao;
    data['numero'] = this.numero;

    return data;
  }
}
