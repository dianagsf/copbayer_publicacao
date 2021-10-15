class EmpContratadosModel {
  var desconto;
  int quantidade;
  String total;
  var saldoDevedor;

  EmpContratadosModel({
    this.desconto,
    this.quantidade,
    this.total,
    this.saldoDevedor,
  });

  EmpContratadosModel.fromJson(Map<String, dynamic> json) {
    desconto = json['desconto'];
    quantidade = json['quantidade'];
    total = json['total'];
    saldoDevedor = json['saldo_devedor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desconto'] = this.desconto;
    data['quantidade'] = this.quantidade;
    data['total'] = this.total;
    data['saldo_devedor'] = this.saldoDevedor;
    return data;
  }
}
