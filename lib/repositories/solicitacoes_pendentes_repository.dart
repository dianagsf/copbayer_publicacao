import 'package:copbayer_app/model/solic_pendentes_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class SolicPendentesRepository {
  Future<List<SolicPendentesModel>> findAll(int matricula) async {
    var dio = CustomDio().instance;

    try {
      var response =
          await dio.get('/solicitacoes/pendentes?matricula=$matricula');
      return (response.data as List)
          .map((sol) => SolicPendentesModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
