import 'package:copbayer_app/model/senha_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class SenhaRepository {
  Future<List<SenhaModel>> getSenha(int matricula) async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/verificaSenha?matricula=$matricula');
      return (response.data as List)
          .map((sol) => SenhaModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
