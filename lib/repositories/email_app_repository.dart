import 'package:copbayer_app/model/email_app_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class EmailAppRepository {
  Future<List<EmailAppModel>> getDadosEmailApp() async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/emailAPP');
      return (response.data as List)
          .map((sol) => EmailAppModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
