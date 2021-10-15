import 'package:copbayer_app/model/faixa_capital_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class FaixaCapitalRepository {
  Future<List<FaixaCapitalModel>> getFaixas() async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/faixas/capital');
      return (response.data as List)
          .map((sol) => FaixaCapitalModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<int> alteraCapital(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/alteraCapital', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
