import 'package:copbayer_app/model/faixa_capital_model.dart';
import 'package:copbayer_app/repositories/faixa_capital_repository.dart';
import 'package:get/get.dart';

class FaixaCapitalController extends GetxController {
  FaixaCapitalRepository faixaCapitalRepository = FaixaCapitalRepository();

  final _faixaCapital = <FaixaCapitalModel>[].obs;

  List<FaixaCapitalModel> get faixaCapital => _faixaCapital;
  set faixaCapital(value) => this._faixaCapital.assignAll(value);

  void getFaixaCapital() {
    faixaCapitalRepository
        .getFaixas()
        .then((data) => {this._faixaCapital.assignAll(data)});
  }
}
