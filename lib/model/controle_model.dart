class ControleModel {
  int iNTEGRACAO;
  String vERSAO;

  ControleModel({this.iNTEGRACAO, this.vERSAO});

  ControleModel.fromJson(Map<String, dynamic> json) {
    iNTEGRACAO = json['INTEGRACAO'];
    vERSAO = json['VERSAO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['INTEGRACAO'] = this.iNTEGRACAO;
    data['VERSAO'] = this.vERSAO;
    return data;
  }
}
