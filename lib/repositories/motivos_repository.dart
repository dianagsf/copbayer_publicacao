import 'package:copbayer_app/model/motivos_desligamento_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class MotivosRepository {
  Future<List<MotivosModel>> getMotivos() async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/motivos/desligamento');
      return (response.data as List)
          .map((sol) => MotivosModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
