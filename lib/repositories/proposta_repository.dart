import 'package:copbayer_app/model/proposta_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class PropostaRepository {
  Future<List<PropostaModel>> getPropostas(int matricula) async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/propostas/usuario/?matricula=$matricula');
      return (response.data as List)
          .map((sol) => PropostaModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
