import 'package:copbayer_app/model/devedor_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class SaldoDevedorRepository {
  Future<List<SaldoDevedorModel>> getSaldoDevedor(int matricula) async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/saldoDevedor?matricula=$matricula');
      return (response.data as List)
          .map((sol) => SaldoDevedorModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
