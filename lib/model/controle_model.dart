class ControleModel {
  int iNTEGRACAO;
  String vERSAO;
  var taxaIOF;
  var taxaFatorIOF;
  var taxaEmp;

  ControleModel({
    this.iNTEGRACAO,
    this.vERSAO,
    this.taxaIOF,
    this.taxaFatorIOF,
    this.taxaEmp,
  });

  ControleModel.fromJson(Map<String, dynamic> json) {
    iNTEGRACAO = json['INTEGRACAO'];
    vERSAO = json['VERSAO'];
    taxaIOF = json['TAXA_IOF'];
    taxaFatorIOF = json['FATOR_IOF'];
    taxaEmp = json['TAXA_EMP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['INTEGRACAO'] = this.iNTEGRACAO;
    data['VERSAO'] = this.vERSAO;
    data['TAXA_IOF'] = this.taxaIOF;
    data['FATOR_IOF'] = this.taxaFatorIOF;
    data['TAXA_EMP'] = this.taxaEmp;
    return data;
  }
}
