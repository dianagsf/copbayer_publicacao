import 'package:copbayer_app/model/saldo_capital_model.dart';
import 'package:copbayer_app/repositories/saldo_capital_repository.dart';

import 'package:get/get.dart';

class SaldoCapitalController extends GetxController {
  SaldoCapitalRepository repositorySaldoCapital = SaldoCapitalRepository();

  final _saldoCapital = <SaldoCapitalModel>[].obs;

  List<SaldoCapitalModel> get saldoCapital => _saldoCapital;
  set saldoCapital(value) => this._saldoCapital.assignAll(value);

  void getSaldo(int matricula) {
    repositorySaldoCapital
        .getSaldoCapital(matricula)
        .then((data) => {this._saldoCapital.assignAll(data)});
  }
}
