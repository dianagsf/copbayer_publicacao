import 'package:copbayer_app/model/data_model.dart';
import 'package:copbayer_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class DataRepository {
  Future<List<DataModel>> getDatasAlterCapital(int matricula) async {
    var dio = CustomDio().instance;
    try {
      var response =
          await dio.get('/alteracaoCapital/datas?matricula=$matricula');
      return (response.data as List)
          .map((sol) => DataModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<List<DataModel>> getDatasRetiradaCapital(int matricula) async {
    var dio = CustomDio().instance;
    try {
      var response =
          await dio.get('/retiradaCapital/datas?matricula=$matricula');
      return (response.data as List)
          .map((sol) => DataModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<List<DataModel>> getDatasDesligamento(int matricula) async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/desligamento/datas?matricula=$matricula');
      return (response.data as List)
          .map((sol) => DataModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<List<DataModel>> getDatasQuitacao(int matricula) async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/quitacao/datas?matricula=$matricula');
      return (response.data as List)
          .map((sol) => DataModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<List<DataModel>> getDatasSolic(int matricula) async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/solic/datas?matricula=$matricula');
      return (response.data as List)
          .map((sol) => DataModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
