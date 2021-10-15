import 'package:copbayer_app/model/fechamento_folha_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class FechamentoFolhaRepository {
  Future<List<FechamentoFolhaModel>> getDatasFechamento() async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/fechamentoFolha');
      return (response.data as List)
          .map((sol) => FechamentoFolhaModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
