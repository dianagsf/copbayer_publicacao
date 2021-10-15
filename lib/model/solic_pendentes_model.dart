class SolicPendentesModel {
  String data;
  int matricula;
  var valor;
  int np;
  var prestacao;
  String situacao;
  String origem;

  SolicPendentesModel({
    this.data,
    this.matricula,
    this.valor,
    this.np,
    this.prestacao,
    this.situacao,
    this.origem,
  });

  SolicPendentesModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    matricula = json['matricula'];
    valor = json['valor'];
    np = json['np'];
    prestacao = json['prestacao'];
    situacao = json['situacao'];
    origem = json['origem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['data'] = this.data;
    data['matricula'] = this.matricula;
    data['valor'] = this.valor;
    data['np'] = this.np;
    data['prestacao'] = this.prestacao;
    data['situacao'] = this.situacao;
    data['origem'] = this.origem;
    return data;
  }
}
