import 'package:copbayer_app/model/controle_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class ControleRepository {
  Future<List<ControleModel>> getInfosControle() async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/controleAPP');
      return (response.data as List)
          .map((sol) => ControleModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
