class SenhaModel {
  String senha;

  SenhaModel({this.senha});

  SenhaModel.fromJson(Map<String, dynamic> json) {
    senha = json['senha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senha'] = this.senha;
    return data;
  }
}
