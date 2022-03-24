class FechamentoFolhaModel {
  var faixaA;
  int fimmes;
  String datafechafolha;

  FechamentoFolhaModel({
    this.faixaA,
    this.fimmes,
    this.datafechafolha,
  });

  FechamentoFolhaModel.fromJson(Map<String, dynamic> json) {
    faixaA = json['faixa_a'];
    fimmes = json['fimmes'];
    datafechafolha = json['datafechafolha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['faixa_a'] = this.faixaA;
    data['fimmes'] = this.fimmes;
    data['datafechafolha'] = this.datafechafolha;

    return data;
  }
}
