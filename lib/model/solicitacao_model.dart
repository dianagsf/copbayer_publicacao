class SolicitacaoModel {
  String data;
  int matricula;
  var valor;
  int np;
  var prestacao;
  String situacao;
  String datasituacao;
  String motivo;
  int solicWeb;

  SolicitacaoModel({
    this.data,
    this.matricula,
    this.valor,
    this.np,
    this.prestacao,
    this.situacao,
    this.datasituacao,
    this.motivo,
    this.solicWeb,
  });

  SolicitacaoModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    matricula = json['matricula'];
    valor = json['valor'];
    np = json['np'];
    prestacao = json['prestacao'];
    situacao = json['situacao'];
    datasituacao = json['datasituacao'];
    motivo = json['motivo_recusa'];
    solicWeb = json['solic_web'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['data'] = this.data;
    data['matricula'] = this.matricula;
    data['valor'] = this.valor;
    data['np'] = this.np;
    data['prestacao'] = this.prestacao;
    data['situacao'] = this.situacao;
    data['datasituacao'] = this.datasituacao;
    data['motivo_recusa'] = this.motivo;
    data['solic_web'] = this.solicWeb;
    return data;
  }
}
