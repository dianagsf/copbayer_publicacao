import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class LogAppRepository {
  Future<int> saveLog(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/logApp', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
