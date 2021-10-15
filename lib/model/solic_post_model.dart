class SolicPostModel {
  int numero;
  String data;
  int matricula;
  int valor;
  int np;
  int salario;
  double liquido;
  int pensao;
  int consignado;
  int anexos;
  int iof;
  double prestacao;
  int valorcr;
  String rENEGOCIACAO;
  Null utilizada;

  SolicPostModel(
      {this.numero,
      this.data,
      this.matricula,
      this.valor,
      this.np,
      this.salario,
      this.liquido,
      this.pensao,
      this.consignado,
      this.anexos,
      this.iof,
      this.prestacao,
      this.valorcr,
      this.rENEGOCIACAO,
      this.utilizada});

  SolicPostModel.fromJson(Map<String, dynamic> json) {
    numero = json['numero'];
    data = json['data'];
    matricula = json['matricula'];
    valor = json['valor'];
    np = json['np'];
    salario = json['salario'];
    liquido = json['liquido'];
    pensao = json['pensao'];
    consignado = json['consignado'];
    anexos = json['anexos'];
    iof = json['iof'];
    prestacao = json['prestacao'];
    valorcr = json['valorcr'];
    rENEGOCIACAO = json['RENEGOCIACAO'];
    utilizada = json['utilizada'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numero'] = this.numero;
    data['data'] = this.data;
    data['matricula'] = this.matricula;
    data['valor'] = this.valor;
    data['np'] = this.np;
    data['salario'] = this.salario;
    data['liquido'] = this.liquido;
    data['pensao'] = this.pensao;
    data['consignado'] = this.consignado;
    data['anexos'] = this.anexos;
    data['iof'] = this.iof;
    data['prestacao'] = this.prestacao;
    data['valorcr'] = this.valorcr;
    data['RENEGOCIACAO'] = this.rENEGOCIACAO;
    data['utilizada'] = this.utilizada;
    return data;
  }
}
