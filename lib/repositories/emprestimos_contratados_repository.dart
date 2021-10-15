import 'package:copbayer_app/model/emprestimos_contratados_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class EmpContratadosRepository {
  Future<List<EmpContratadosModel>> getInfos(int matricula) async {
    var dio = CustomDio().instance;
    try {
      var response =
          await dio.get('/emprestimosContrados?matricula=$matricula');
      return (response.data as List)
          .map((sol) => EmpContratadosModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
