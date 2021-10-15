class PedidoQuitacaoModel {
  int emprestimo;

  PedidoQuitacaoModel({this.emprestimo});

  PedidoQuitacaoModel.fromJson(Map<String, dynamic> json) {
    emprestimo = json['emprestimo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emprestimo'] = this.emprestimo;
    return data;
  }
}
