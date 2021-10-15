import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class RetiradaCapitalRepository {
  Future<int> postRetiradaCapital(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/retiradaCapital', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
