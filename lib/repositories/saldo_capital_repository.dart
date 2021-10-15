import 'package:copbayer_app/model/saldo_capital_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class SaldoCapitalRepository {
  Future<List<SaldoCapitalModel>> getSaldoCapital(int matricula) async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/saldoCapital?matricula=$matricula');
      return (response.data as List)
          .map((sol) => SaldoCapitalModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
