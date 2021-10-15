import 'package:copbayer_app/model/data_model.dart';
import 'package:copbayer_app/repositories/data_repository.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  DataRepository dataRepository = DataRepository();

  final _datasAlterCapital = <DataModel>[].obs;
  final _datasRetiradaCapital = <DataModel>[].obs;
  final _datasDesligamento = <DataModel>[].obs;
  final _datasQuitacao = <DataModel>[].obs;
  final _datasSolic = <DataModel>[].obs;

  List<DataModel> get datasAlterCapital => _datasAlterCapital;
  set datasAlterCapital(value) => this._datasAlterCapital.assignAll(value);

  List<DataModel> get datasRetiradaCapital => _datasRetiradaCapital;
  set datasRetiradaCapital(value) =>
      this._datasRetiradaCapital.assignAll(value);

  List<DataModel> get datasDesligamento => _datasDesligamento;
  set datasDesligamento(value) => this._datasDesligamento.assignAll(value);

  List<DataModel> get datasQuitacao => _datasQuitacao;
  set datasQuitacao(value) => this._datasQuitacao.assignAll(value);

  List<DataModel> get datasSolic => _datasSolic;
  set datasSolic(value) => this._datasSolic.assignAll(value);

  void getDatasAlterCapital(int matricula) {
    dataRepository
        .getDatasAlterCapital(matricula)
        .then((data) => {this._datasAlterCapital.assignAll(data)});
  }

  void getDatasRetiradaCapital(int matricula) {
    dataRepository
        .getDatasRetiradaCapital(matricula)
        .then((data) => {this._datasRetiradaCapital.assignAll(data)});
  }

  void getDatasDesligamento(int matricula) {
    dataRepository
        .getDatasDesligamento(matricula)
        .then((data) => {this._datasDesligamento.assignAll(data)});
  }

  void getDatasQuitacao(int matricula) {
    dataRepository
        .getDatasQuitacao(matricula)
        .then((data) => {this._datasQuitacao.assignAll(data)});
  }

  void getDatasSolic(int matricula) {
    dataRepository
        .getDatasSolic(matricula)
        .then((data) => {this._datasSolic.assignAll(data)});
  }
}
