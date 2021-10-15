import 'package:copbayer_app/repositories/retirada_post_repository.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class RetiradaCapitalController extends GetxController {
  RetiradaCapitalRepository retiradaCapitalRepository =
      RetiradaCapitalRepository();

  MoneyMaskedTextController controllerValor;
  List<Map<String, dynamic>> _retiradaCapital = [];

  List<Map<String, dynamic>> get retiradaCapital => _retiradaCapital;

  @override
  void onInit() {
    controllerValor = MoneyMaskedTextController(
        decimalSeparator: ',', thousandSeparator: '.');
    super.onInit();
  }

  //Convert money type to double
  /*String _convertDouble(String value) {
    String valor = value.replaceAll(',', '.');
    var valorDouble = [];
    valorDouble = valor.split(".");
    if (valorDouble != null) if (valorDouble.length == 2) {
      return "${valorDouble[0]}" + "." + "${valorDouble[1]}";
    } else {
      return "${valorDouble[0]}" +
          "${valorDouble[1]}" +
          "." +
          "${valorDouble[2]}";
    }

    return "${valorDouble[0]}";
  }*/

  void saveRetiradaCapital(int matricula, double valorArredondado) {
    int protocolo;
    var data = DateTime.now().toString().substring(0, 19);

    var codigo = matricula.toString() + " " + data;
    protocolo = codigo.hashCode;
    this._retiradaCapital = [
      {
        "matricula": matricula,
        "data": DateTime.now().toString().substring(0, 23),
        "valor": valorArredondado, //_convertDouble(controllerValor.text),
        "numero": protocolo,
      }
    ];

    retiradaCapitalRepository.postRetiradaCapital(this._retiradaCapital[0]);
  }

  @override
  void onClose() {
    controllerValor?.dispose();
    super.onClose();
  }
}
