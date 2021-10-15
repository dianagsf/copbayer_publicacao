class AssociadoModel {
  int matricula;
  String chapa;
  String nome;
  String cpf;
  String associado;
  String admissao;
  String codemp;
  String perfil;
  String tipodesc;
  var saldoCapAnterior;

  AssociadoModel({
    this.matricula,
    this.chapa,
    this.nome,
    this.cpf,
    this.associado,
    this.admissao,
    this.codemp,
    this.perfil,
    this.tipodesc,
    this.saldoCapAnterior,
  });

  AssociadoModel.fromJson(Map<String, dynamic> json) {
    matricula = json['matricula'];
    chapa = json['chapa'];
    nome = json['nome'];
    cpf = json['cpf'];
    associado = json['associado'];
    admissao = json['admissao'];
    codemp = json['codemp'];
    perfil = json['perfil'];
    tipodesc = json['tipodesc'];
    saldoCapAnterior = json['saldo_cap_anterior'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matricula'] = this.matricula;
    data['chapa'] = this.chapa;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['associado'] = this.associado;
    data['admissao'] = this.admissao;
    data['codemp'] = this.codemp;
    data['perfil'] = this.perfil;
    data['tipodesc'] = this.tipodesc;
    data['saldo_cap_anterior'] = this.saldoCapAnterior;
    return data;
  }
}
