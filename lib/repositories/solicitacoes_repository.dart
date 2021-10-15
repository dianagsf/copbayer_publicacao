import 'package:copbayer_app/model/solicitacao_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class SolicitacoesRepository {
  Future<List<SolicitacaoModel>> findAll(int matricula) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.get('/solicitacoes?matricula=$matricula');
      return (response.data as List)
          .map((sol) => SolicitacaoModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<List<SolicitacaoModel>> getSolRecentes(int matricula) async {
    var dio = CustomDio().instance;

    try {
      var response =
          await dio.get('/solicitacoes/recentes?matricula=$matricula');
      return (response.data as List)
          .map((sol) => SolicitacaoModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
