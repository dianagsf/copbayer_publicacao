import 'package:copbayer_app/model/pedido_quitacao_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class PedidoQuitacaoRepository {
  Future<List<PedidoQuitacaoModel>> getQuitacaoAnalise() async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/pedidoQuitacao');
      return (response.data as List)
          .map((sol) => PedidoQuitacaoModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
