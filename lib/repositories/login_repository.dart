import 'package:copbayer_app/model/login_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class LoginRepository {
  Future<List<LoginModel>> login(String cpf, String senha) async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/login?cpf=$cpf&senha=$senha');
      return (response.data as List)
          .map((sol) => LoginModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
