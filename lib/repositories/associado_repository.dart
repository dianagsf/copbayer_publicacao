import 'package:copbayer_app/model/associado_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class AssociadoRepository {
  Future<List<AssociadoModel>> getInfosAssoc(String cpf) async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/associado/?cpf=$cpf');
      return (response.data as List)
          .map((sol) => AssociadoModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<List<AssociadoModel>> getInfosAssocSenha(
      String cpf, String dataNasc) async {
    var dio = CustomDio().instance;
    try {
      var response =
          await dio.get('/associadoInfo/?cpf=$cpf&dataNasc=$dataNasc');
      return (response.data as List)
          .map((sol) => AssociadoModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
