import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class QuitacaoRepository {
  Future<int> savePedidoQuitacao(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/quitacao', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
