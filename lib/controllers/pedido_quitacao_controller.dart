import 'package:copbayer_app/model/pedido_quitacao_model.dart';
import 'package:copbayer_app/repositories/pedido_quitacao_repository.dart';
import 'package:get/get.dart';

class PedidoQuitacaoController extends GetxController {
  PedidoQuitacaoRepository pedidoQuitacaoRepository =
      PedidoQuitacaoRepository();

  final _pedidosQuitacao = <PedidoQuitacaoModel>[].obs;

  List<PedidoQuitacaoModel> get pedidosQuitacao => _pedidosQuitacao;
  set pedidosQuitacao(value) => this._pedidosQuitacao.assignAll(value);

  void getPedidosQuitacao() {
    pedidoQuitacaoRepository
        .getQuitacaoAnalise()
        .then((data) => {this._pedidosQuitacao.assignAll(data)});
  }
}
