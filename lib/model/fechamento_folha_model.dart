class FechamentoFolhaModel {
  int fimmes;
  String datafechafolha;

  FechamentoFolhaModel({
    this.fimmes,
    this.datafechafolha,
  });

  FechamentoFolhaModel.fromJson(Map<String, dynamic> json) {
    fimmes = json['fimmes'];
    datafechafolha = json['datafechafolha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fimmes'] = this.fimmes;
    data['datafechafolha'] = this.datafechafolha;

    return data;
  }
}
