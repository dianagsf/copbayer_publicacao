class ControleModel {
  int iNTEGRACAO;
  String vERSAO;
  double taxaIOF;
  double taxaFatorIOF;

  ControleModel({
    this.iNTEGRACAO,
    this.vERSAO,
    this.taxaIOF,
    this.taxaFatorIOF,
  });

  ControleModel.fromJson(Map<String, dynamic> json) {
    iNTEGRACAO = json['INTEGRACAO'];
    vERSAO = json['VERSAO'];
    taxaIOF = json['TAXA_IOF'];
    taxaFatorIOF = json['FATOR_IOF'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['INTEGRACAO'] = this.iNTEGRACAO;
    data['VERSAO'] = this.vERSAO;
    data['TAXA_IOF'] = this.taxaIOF;
    data['FATOR_IOF'] = this.taxaFatorIOF;
    return data;
  }
}
