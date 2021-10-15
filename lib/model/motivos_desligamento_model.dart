class MotivosModel {
  int codigo;
  String motivo;

  MotivosModel({this.codigo, this.motivo});

  MotivosModel.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    motivo = json['motivo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['motivo'] = this.motivo;
    return data;
  }
}
