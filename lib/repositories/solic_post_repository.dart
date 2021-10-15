import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class SolicPostRepository {
  Future<int> createSolic(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/solic', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
