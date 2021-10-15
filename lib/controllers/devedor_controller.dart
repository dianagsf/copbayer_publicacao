import 'package:copbayer_app/model/devedor_model.dart';
import 'package:copbayer_app/repositories/devedor_repository.dart';
import 'package:get/get.dart';

class SaldoDevedorController extends GetxController {
  SaldoDevedorRepository saldoDevedorRepository = SaldoDevedorRepository();

  final _saldoDevedor = <SaldoDevedorModel>[].obs;

  List<SaldoDevedorModel> get saldoDevedor => _saldoDevedor;
  set saldoDevedor(value) => this._saldoDevedor.assignAll(value);

  void getSaldoDevedor(int matricula) {
    saldoDevedorRepository
        .getSaldoDevedor(matricula)
        .then((data) => {this._saldoDevedor.assignAll(data)});
  }
}
